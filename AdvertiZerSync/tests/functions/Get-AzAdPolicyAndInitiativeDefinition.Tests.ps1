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
            $policy_definition = Get-AzAdPolicyDefinition -Name $policy_id -Debug

            # Expected json result:
            $url = "https://raw.githubusercontent.com/Azure/Community-Policy/master/policyDefinitions/API%20Management/audit-sample-products-should-be-removed-from-api-management/azurepolicy.json"
            $expected_result = (Invoke-WebRequest -Uri $url).Content
            $policy_definition | Should -Be $expected_result
        }
    }
    Context "Check if Single Azure Landing Zone Policy Download is Successful" {
        It "Returns an the json object of the policy definition" {
            $policy_id = "Deny-APIM-TLS"
            $policy_definition = Get-AzAdPolicyDefinition -Name $policy_id -Debug

            # Expected json result:
            $url = "https://github.com/Azure/Enterprise-Scale/raw/refs/heads/main/src/resources/Microsoft.Authorization/policyDefinitions/Deny-APIM-TLS.json"
            $expected_result = (Invoke-WebRequest -Uri $url).Content
            $policy_definition | Should -Be $expected_result
        }
    }
    # Context "Successful Download Policy Initiative and CSV Conversion" {
    #     It "Returns an Object with list of Policy Initiatives" {
    #         $result = Get-AzAdPolicyInitiative | Out-String
    #         Write-PSFMessage -Level Verbose ($result)
    #         Get-AzAdPolicyInitiative | Should -Not -BeNullOrEmpty
    #     }
    # }
}