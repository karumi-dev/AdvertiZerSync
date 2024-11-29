function Get-AzAdPolicyDefinition {
	<#
		.SYNOPSIS
			Downloads Azure Advertiser Policy Initiatives
		
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
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(
            ParameterSetName = 'PolicyID',
            Mandatory = $false
        )]
		[Alias('ID', 'Name')]
        [string]$PolicyID,

        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $false
        )]
        [object[]]$AzAdPolicy
    )
	Begin {
    }
    Process {
        if ($PSBoundParameters.ContainsKey("AzAdPolicy")) {
            $policy_id = $AzAdPolicy.PolicyId
        }
        else {
            $policy_id = $PolicyID
        }
        try {
            $policy_link = Get-AzAdPolicyDTALink $policy_id
            Write-Debug "Successfully got DTA Link $policy_link"
        } catch [NoDTALinkException] {
            Write-Debug "Failed to get DTA Link Error: $_"
            $policy_link = Get-AzAdPolicyGitHubLink $policy_id
            Write-Debug "Successfully got Github Link $policy_link"
        }

        $response = Invoke-WebRequest -Uri $policy_link
        $policy_definition = $response.content
        $result = [PSCustomObject]@{
            PolicyID   = $policy_id
            Definition = $policy_definition
        }
        return $result
    }
    End {
    }
}