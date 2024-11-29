<#
.DESCRIPTION
    This test verifies, that all strings that have been used,
    are listed in the language files and thus have a message being displayed.

    It also checks, whether the language files have orphaned entries that need cleaning up.
#>
Describe "Testing Update-AZSInitiative" {
    Context "Check if successfully upload a single initiative that doesn't exist" {
        It "New Policy should now be found" {
            # https://www.azadvertizer.net/azpolicyadvertizer/a00ef680-cc0e-4828-b3ea-8586b98be163.html
            $initiative_id = "Enforce-ALZ-Decomm"
            $subscription_id = "9cd09ea5-c3e0-4322-b29c-9a86586e5f64"

            $exists = Get-AzPolicySetDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $initiative_id}
            if ($exists) {
                Remove-AzPolicySetDefinition -SubscriptionId $subscription_id -Name $initiative_id
            }
            Update-AZSInitiative -SubscriptionId $subscription_id -InitiativeID $initiative_id -Force
            $result = Get-AzPolicySetDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $initiative_id}
            $result | Should -Not -BeNullOrEmpty
            Remove-AzPolicySetDefinition -SubscriptionId $subscription_id -Name $initiative_id -Force
        }
    }
    Context "Check if successfully upload an initiative that exists with outdated version" {
        It "Updated Initiative should now be found" {
            # https://www.azadvertizer.net/azpolicyadvertizer/a00ef680-cc0e-4828-b3ea-8586b98be163.html
            $initiative_id = "Enforce-ALZ-Decomm"
            $subscription_id = "9cd09ea5-c3e0-4322-b29c-9a86586e5f64"

            $exists = Get-AzPolicySetDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $initiative_id}
            if (!$exists) {
                Update-AZSInitiative -SubscriptionId $subscription_id -InitiativeID $initiative_id -Force
            }
            Update-AzPolicySetDefinition -SubscriptionId $subscription_id -Metadata '{"version": "0.0.1"}' -Name $initiative_id

            Update-AZSInitiative -SubscriptionId $subscription_id -InitiativeID $initiative_id
            $result = Get-AzPolicySetDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $initiative_id}
            $result | Should -Not -Be "0.0.1"
            Remove-AzPolicySetDefinition -SubscriptionId $subscription_id -Name $initiative_id -Force
        }
    }
    # Context "Check if successfully upload of policies from the pipeline" {
    #     It "New Policies should now be found" {
    #         # https://www.azadvertizer.net/azpolicyadvertizer/a00ef680-cc0e-4828-b3ea-8586b98be163.html
    #         $policy_id = "a00ef680-cc0e-4828-b3ea-8586b98be163"
    #         $subscription_id = "9cd09ea5-c3e0-4322-b29c-9a86586e5f64"

    #         $exists = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
    #         if ($exists) {
    #             Remove-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -Force
    #         }
    #         Update-AZSPolicy -SubscriptionId $subscription_id -PolicyId $policy_id -Force
    #         Update-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -MetaData '{"version": "0.0.1"}'

    #         Update-AZSPolicy -SubscriptionId $subscription_id -PolicyId $policy_id -Force
    #         $result = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
    #         $result | Should -Not -Be "0.0.1"
    #         Remove-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -Force
    #     }
    # }
}