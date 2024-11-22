# Place all code that should be run before functions are imported here

# Azure Advertiser Policy CSV HTTP Path
New-Variable -Name AzAdPolicyCsv -Value "https://www.azadvertizer.net/azpolicyadvertizer-comma.csv" -Scope Script -Force
New-Variable -Name AzAdPolicyInitiativeCsv -Value "https://www.azadvertizer.net/azpolicyinitiativesadvertizer-comma.csv" -Scope Script -Force
New-Variable -Name AzAdURL -Value "https://www.azadvertizer.net/azpolicyadvertizer/{0}.html" -Scope Script -Force
New-Variable -Name AzAdGithubRegex -Value "https?:\/\/github\.com\/[^\s<>`"'']*Community-Policy[^\s<>`"'']*policyDefinitions[^`"']*" -Scope Script -Force
New-Variable -Name AzAdGithubAzurePolicyFileName -Value "/azurepolicy.json" -Scope Script -Force