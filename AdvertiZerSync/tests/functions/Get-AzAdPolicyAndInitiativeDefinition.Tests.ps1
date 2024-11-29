<#
.DESCRIPTION
    This test verifies, that all strings that have been used,
    are listed in the language files and thus have a message being displayed.

    It also checks, whether the language files have orphaned entries that need cleaning up.
#>

Describe "Testing Get-AzAdPolicyDefinition" {
    Context "Check if Single Community Policy Download is Successful" {
        It "Returns an the json object of the policy definition" {
            $policy_id = "06b50e5f-2815-4e79-bc97-02996a363c4d"
            $policy_definition = Get-AzAdPolicyDefinition -PolicyID $policy_id

            # Expected json result:
            $expected_results = @()
            $url1 = "https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/API%20Management/audit-sample-products-should-be-removed-from-api-management/azurepolicy.json"
            $expected_results += (Invoke-WebRequest -Uri $url1).Content
            $url2 = "https://www.azadvertizer.net/azpolicyadvertizerdta/06b50e5f-2815-4e79-bc97-02996a363c4d_1.0.0_dta.json"
            $expected_results += (Invoke-WebRequest -Uri $url2).Content

            $expected_results.Contains($policy_definition.Definition) | Should -Be $true
        }
    }
    Context "Check if Single Azure Landing Zone Policy Download is Successful" {
        It "Returns an the json object of the policy definition" {
            $policy_id = "Deny-APIM-TLS"
            $policy_definition = Get-AzAdPolicyDefinition -PolicyID $policy_id

            # Expected json result:
            $url1 = "https://github.com/Azure/Enterprise-Scale/raw/refs/heads/main/src/resources/Microsoft.Authorization/policyDefinitions/Deny-APIM-TLS.json"
            $expected_results += (Invoke-WebRequest -Uri $url1).Content
            $url2 = "https://www.azadvertizer.net/azpolicyadvertizerdta/Deny-APIM-TLS_1.0.0_dta.json"
            $expected_results += (Invoke-WebRequest -Uri $url2).Content

            $expected_results.Contains($policy_definition.Definition) | Should -Be $true
        }
    }

    Context "Check if Pipeline Azure Landing Zone Policy Download is Successful" {
        It "Returns an array of Policy Definitions" {
            $policies = Get-AzAdPolicy | Where-Object {$_.policyType -ne "BuiltIn"} | Select-Object -First 5
            # Write-Host ($policies | Out-String)
            $policy_definitions = $policies | Get-AzAdPolicyDefinition

            # Write-Host ($policy_definitions | Get-Member | Out-String)

            foreach ($policy_definition in $policy_definitions) {
                Write-Debug $policy_definition
            }
            # Expected json result:
            $policy_definitions | Should -Not -BeNullOrEmpty
        }
    }
}
Describe "Testing Get-AzAdInitiativeDefinition" {
    Context "Check if Single Azure Landing Zone Policy Download is Successful" {
        It "Returns an the json object of the initiative definition" {
            $initiative_id = "Enforce-EncryptTransit_20240509"
            $initiative_definition = Get-AzAdInitiativeDefinition -InitiativeID $initiative_id

            # Expected json result:
            $url = "https://raw.githubusercontent.com/Azure/Enterprise-Scale/refs/heads/main/src/resources/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit_20240509.json"
            $expected_result = (Invoke-WebRequest -Uri $url).Content
            $initiative_definition.Definition | Should -Be $expected_result
        }
    }

    Context "Check if Pipeline Azure Landing Zone Policy Download is Successful" {
        It "Returns an array of initiative Definitions" {
            $initiatives = Get-AzAdInitiative | Where-Object {$_.initiativeType -ne "BuiltIn"} | Select-Object -First 5
            Write-Host ($initiatives | Out-String)
            $initiatives_definitions = $initiatives | Get-AzAdInitiativeDefinition

            # Write-Host ($policy_definitions | Get-Member | Out-String)

            foreach ($initiative_definition in $initiatives_definitions) {
                Write-Debug $initiative_definition
            }
            # Expected json result:
            $initiatives_definitions | Should -Not -BeNullOrEmpty
        }
    }
}