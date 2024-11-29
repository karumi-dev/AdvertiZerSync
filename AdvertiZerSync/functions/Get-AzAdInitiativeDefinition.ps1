function Get-AzAdInitiativeDefinition {
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
            ParameterSetName = 'InitiativeID',
            Mandatory = $false
        )]
		[Alias('ID', 'Name')]
        [string]$InitiativeID,

        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $false
        )]
        [object[]]$AzAdInitiative
    )
	Begin {
    }
    Process {
        if ($PSBoundParameters.ContainsKey("AzAdInitiative")) {
            $initiative_id = $AzAdInitiative.initiativeID
        }
        else {
            $initiative_id = $InitiativeID
        }
        Write-Debug "Initiative ID: $initiative_id"
        $initiative_link = Get-AzAdInitiativeGitHubLink $initiative_id
        $response = Invoke-WebRequest -Uri $initiative_link
        $initiative_definition = $response.content
        $initiative_definition = $initiative_definition -replace "\[\[","["
        $result = [PSCustomObject]@{
            InitiativeID   = $initiative_id
            Definition = $initiative_definition
        }
        return $result
    }
    End {
    }
}