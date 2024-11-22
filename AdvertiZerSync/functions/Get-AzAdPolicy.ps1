function Get-AzAdPolicy {
	<#
		.SYNOPSIS
			Downloads Azure Advertiser Policies
		
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
	$response = Invoke-WebRequest -Uri $script:AzAdPolicyCsv -ErrorAction Stop
	$policies = $response.Content | ConvertFrom-Csv -Delimiter "," -ErrorAction Stop
	return $policies
}