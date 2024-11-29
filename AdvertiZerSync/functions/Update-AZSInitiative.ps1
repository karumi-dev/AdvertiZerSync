function Update-AZSInitiative {
	<#
		.SYNOPSIS
            Gets the difference between Azure and Advertiser Policies
		
		.DESCRIPTION
			This helper function is used during module initialization.
			It should always be dotsourced itself, in order to proper function.
			
			This provides a central location to react to files being imported, if later desired
		
		.PARAMETER Path
			The path to the file to load
		
		.EXAMPLE
			PS C:\> . Import-ModuleFile -File $function.FullName
	
			Imports the file stored in $function according to import policy
	#>
    [CmdletBinding(DefaultParameterSetName = 'ManagementGroupName', SupportsShouldProcess=$true, ConfirmImpact="High")]
    param(
        [Parameter(
            Mandatory = $false
        )]
		[Alias('ID', "Name")]
        [string]$InitiativeID,

        [Parameter()]
        [switch]$Force,

        [Parameter(
            ParameterSetName = 'ManagementGroupName',
            Mandatory = $true
        )]
        [string]$ManagementGroupName,

        [Parameter(
            ParameterSetName = 'SubscriptionId',
            Mandatory = $true
        )]
        [string]$SubscriptionId,

        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $false
        )]
        [object[]]$Initiatives
    )
	Begin {
        # Check if a valid Az Account is connected
		$result = Get-AzContext
		if (!$result) {
			throw "Please login to Azure first with Connect-AzAccount"
		}
        # Determine whether to use Management Group Name or Subscription ID
        if ($PSBoundParameters.ContainsKey("ManagementGroup")) {
            $arguements = @{
                ManagementGroupName = $ManagementGroupName
            }
        }
        elseif ($PSBoundParameters.ContainsKey("SubscriptionId")) {
            $arguements = @{
                SubscriptionId = $SubscriptionId
            }
        } else {
            throw "Error no ManagementGroupName or SubscriptionId found"
        }
        $azure_custom_initiatives = Get-AzPolicySetDefinition @arguements -Custom
        $azure_custom_initiatives_ids = $azure_custom_initiatives.Name
    }
    Process {
        if ($PSBoundParameters.ContainsKey("InitiativeID")) {
            $initiative_id = $InitiativeID
        }
        $initiative_definition = Get-AzAdInitiativeDefinition -InitiativeID $initiative_id
        $initiative_definition_path = "./$($initiative_definition.InitiativeID).json"
        $initiative_definition.Definition | Out-File $initiative_definition_path
        Write-Debug "Initiative Definition File Path $initiative_definition_path"

        if ($azure_custom_initiatives_ids.Contains($initiative_definition.InitiativeID)) {
            # Check if policy exists already in Azure and compare versions
            Write-Debug "Iinitiative Already Exists in Azure"
            $initiative_definition_version = Get-AzAdPolicyDefinitionVersion -Definition $initiative_definition.Definition
            $azure_initiative_definition_version = ($azure_custom_initiatives | Where-Object {$_.Name -eq $initiative_definition.InitiativeID}).Metadata.Version
            if ($initiative_definition_version -eq $azure_initiative_definition_version) {
                Write-Debug "Matching Versions $initiative_definition_version, $azure_initiative_definition_version. Skipping Update"
            } else {
                # Update the policy to the new definition
                Write-Debug "Updating Initiative to the Newer Version $azure_initiative_definition_version -> $initiative_definition_version"
                # if ($Force -or $PSCmdlet.ShouldProcess(
                #     "Policy Definition '$($initiative_definition.PolicyID)'",
                #     "Performing the opertaion `"Update-AzPolicyDefinition`" on target `"$($policy_definition.PolicyID)`" from version $azure_policy_definition_version -> $policy_definition_version",
                #     "Are you sure you want to update existing Policy Definition?"
                # )) {
                #     # If no policy exists in Azure then create a new definition of it
                #     Update-AzPolicySetDefinition @arguements -Name $policy_definition.PolicyID -Policy $initiative_definition_path
                #     Write-Debug "Policy Definition Updated"
                # }
            }
        } else {
            Write-Debug "Policy Not Found in Azure"
            if ($Force -or $PSCmdlet.ShouldProcess(
                "Initiative Definition '$($initiative_definition.InitiativeID)'",
                "Performing the opertaion `"New-AzPolicySetDefinition`" on target `"$($initiative_definition.InitiativeID)`"",
                "Are you sure you want to create new Policy Set Definition?"
            )) {
                # If no policy exists in Azure then create a new definition of it
                Write-Debug "Checking Dependencies"
                Resolve-AZSInitiativeDependencies -InitiativeDefinition $initiative_definition @arguements
                $initiative_definition_json = $initiative_definition.Definition | ConvertFrom-Json -Depth 100
                $new_policy_arguements = @{
                    Name = $initiative_definition.InitiativeID
                    DisplayName = $initiative_definition_json.properties.displayName
                    Description = $initiative_definition_json.properties.description
                    Metadata = $initiative_definition_json.properties.metadata | ConvertTo-json -Depth 100
                    Parameter = $initiative_definition_json.properties.parameters | ConvertTo-Json -Depth 100
                    PolicyDefinition = $initiative_definition_json.properties.policyDefinitions | ConvertTo-Json -Depth 100
                }
                Write-Debug ($new_policy_arguements.PolicyDefinition | Out-String)
                Write-Debug ($new_policy_arguements.Metadata | Out-String)
                Write-Debug ($new_policy_arguements.Parameter | Out-String)
                New-AzPolicySetDefinition @arguements @new_policy_arguements
                Write-Debug "Policy Set Definition Created $($initiative_definition.InitiativeID)"
            }
        }

    }
    End {
        if (Test-Path $initiative_definition_path -PathType Leaf) {
            # Remove-Item $initiative_definition_path | Out-Null
        }
    }

}