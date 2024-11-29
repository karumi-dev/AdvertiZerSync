function Update-AZSPolicy {
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
        [string]$PolicyID,

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
        [object[]]$Policies
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
        $azure_custom_policies = Get-AzPolicyDefinition @arguements -Custom
        $azure_custom_policy_ids = $azure_custom_policies.Name
    }
    Process {
        if ($PSBoundParameters.ContainsKey("PolicyID")) {
            $policy_id = $PolicyID
        }
        $policy_definition = Get-AzAdPolicyDefinition -PolicyId $policy_id
        $policy_definition_path = "./$($policy_definition.PolicyID).json"
        $policy_definition.Definition | Out-File $policy_definition_path
        Write-Debug "Policy Definition File Path $policy_definition_path"

        if ($azure_custom_policy_ids.Contains($policy_definition.PolicyId)) {
            # Check if policy exists already in Azure and compare versions
            Write-Debug "Policy Already Exists in Azure"
            $policy_definition_version = Get-AzAdPolicyDefinitionVersion -Definition $policy_definition.Definition
            $azure_policy_definition_version = ($azure_custom_policies | Where-Object {$_.Name -eq $policy_definition.PolicyId}).Metadata.Version
            if ($policy_definition_version -eq $azure_policy_definition_version) {
                Write-Debug "Matching Versions $policy_definition_version, $azure_policy_definition_version. Skipping Update"
            } else {
                # Update the policy to the new definition
                Write-Debug "Updating Policy to the Newer Version $azure_policy_definition_version -> $policy_definition_version"
                if ($Force -or $PSCmdlet.ShouldProcess(
                    "Policy Definition '$($policy_definition.PolicyID)'",
                    "Performing the opertaion `"Update-AzPolicyDefinition`" on target `"$($policy_definition.PolicyID)`" from version $azure_policy_definition_version -> $policy_definition_version",
                    "Are you sure you want to update existing Policy Definition?"
                )) {
                    # If no policy exists in Azure then create a new definition of it
                    Update-AzPolicyDefinition @arguements -Name $policy_definition.PolicyID -Policy $policy_definition_path
                    Write-Debug "Policy Definition Updated"
                }
            }
        } else {
            Write-Debug "Policy Not Found in Azure"
            if ($Force -or $PSCmdlet.ShouldProcess(
                "Policy Definition '$($policy_definition.PolicyID)'",
                "Performing the opertaion `"New-AzPolicyDefinition`" on target `"$($policy_definition.PolicyID)`"",
                "Are you sure you want to create new Policy Definition?"
            )) {
                # If no policy exists in Azure then create a new definition of it
                New-AzPolicyDefinition @arguements -Name $policy_definition.PolicyID -Policy $policy_definition_path
                Write-Debug "Policy Definition Created"
            }
        }

    }
    End {
        if (Test-Path $policy_definition_path -PathType Leaf) {
            Remove-Item $policy_definition_path | Out-Null
        }
    }

}