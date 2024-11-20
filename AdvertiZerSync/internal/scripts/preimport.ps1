# Place all code that should be run before functions are imported here

# Azure Advertiser Policy CSV HTTP Path
New-Variable -Name AzAdPolicyCsv -Value "https://www.azadvertizer.net/azpolicyadvertizer-comma.csv" -Scope Script -Force
New-Variable -Name AzAdPolicyInitiativeCsv -Value "https://www.azadvertizer.net/azpolicyinitiativesadvertizer-comma.csv" -Scope Script -Force