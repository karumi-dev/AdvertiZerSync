# Place all code that should be run before functions are imported here
# Classes
# Azure Advertiser Policy CSV HTTP Path
New-Variable -Name AzAdPolicyCsv -Value "https://www.azadvertizer.net/azpolicyadvertizer-comma.csv" -Scope Script -Force
New-Variable -Name AzAdPolicyInitiativeCsv -Value "https://www.azadvertizer.net/azpolicyinitiativesadvertizer-comma.csv" -Scope Script -Force
New-Variable -Name AzAdPolicyURL -Value "https://www.azadvertizer.net/azpolicyadvertizer/{0}.html" -Scope Script -Force
New-Variable -Name AzAdInitiativeURL -Value "https://www.azadvertizer.net/azpolicyinitiativesadvertizer/{0}.html" -Scope Script -Force
New-Variable -Name AzAdGithubRegex -Value @("https?:\/\/github\.com\/Azure[^\s<>`"]*policyDefinitions[^`"]*","https?:\/\/github\.com\/Azure[^\s<>`"]*policySetDefinitions[^`"]*") -Scope Script -Force
New-Variable -Name AzAdGithubAzurePolicyFileName -Value "/azurepolicy.json" -Scope Script -Force
New-Variable -Name AzAdDTARegex -Value @("https:\/\/portal\.azure\.com\/#blade\/Microsoft_Azure_Policy\/CreatePolicyDefinitionBlade\/uri\/.*dta\.json", "https:\/\/www\.azadvertizer\.net\/azpolicyadvertizerdta.*\.json") -Scope Script -Force