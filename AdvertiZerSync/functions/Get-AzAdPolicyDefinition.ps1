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
            ParameterSetName = 'Name',
            Mandatory = $false
        )]
		[Alias('ID', "PolicyID")]
        [string]$Name,

        [Parameter(
            ParameterSetName = 'Pipeline',
            ValueFromPipeline = $true,
            Mandatory = $false
        )]
        [object]$AzAdPolicy
    )
	Begin {
    }
    Process {
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $policy_link = Get-AzAdPolicyGitHubLink $Name
            $response = Invoke-WebRequest -Uri $policy_link
            $policy_definition = $response.content
            return $policy_definition
        }
        elseif ($PSBoundParameters.ContainsKey("Pipeline")) {
            Write-Host "Pipeline"
        }
        else {
            Write-Host "Processing pipeline input: $InputObject"
        }
    }
    End {
    }
}