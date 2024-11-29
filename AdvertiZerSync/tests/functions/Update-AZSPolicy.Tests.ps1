<#
.DESCRIPTION
    This test verifies, that all strings that have been used,
    are listed in the language files and thus have a message being displayed.

    It also checks, whether the language files have orphaned entries that need cleaning up.
#>
Describe "Testing Update-AZSPolicy" {
    Context "Check if successfully upload a single policy that doesn't exist" {
        It "New Policy should now be found" {
            # https://www.azadvertizer.net/azpolicyadvertizer/a00ef680-cc0e-4828-b3ea-8586b98be163.html
            $policy_id = "a00ef680-cc0e-4828-b3ea-8586b98be163"
            $subscription_id = "9cd09ea5-c3e0-4322-b29c-9a86586e5f64"

            $exists = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
            if ($exists) {
                Remove-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -Force
            }
            Update-AZSPolicy -SubscriptionId $subscription_id -PolicyId $policy_id -Force
            $result = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
            $result | Should -Not -BeNullOrEmpty
        }
    }
    Context "Check if successfully upload a single policy that exists with outdated version" {
        It "Updated Policy should now be found" {
            # https://www.azadvertizer.net/azpolicyadvertizer/a00ef680-cc0e-4828-b3ea-8586b98be163.html
            $policy_id = "a00ef680-cc0e-4828-b3ea-8586b98be163"
            $subscription_id = "9cd09ea5-c3e0-4322-b29c-9a86586e5f64"

            $exists = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
            if ($exists) {
                Remove-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -Force
            }
            Update-AZSPolicy -SubscriptionId $subscription_id -PolicyId $policy_id -Force
            Update-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -MetaData '{"version": "0.0.1"}'

            Update-AZSPolicy -SubscriptionId $subscription_id -PolicyId $policy_id -Force
            $result = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
            $result | Should -Not -Be "0.0.1"
            Remove-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -Force
        }
    }
    Context "Check if successfully upload of policies from the pipeline" {
        It "New Policies should now be found" {
            # https://www.azadvertizer.net/azpolicyadvertizer/a00ef680-cc0e-4828-b3ea-8586b98be163.html
            $policy_id = "a00ef680-cc0e-4828-b3ea-8586b98be163"
            $subscription_id = "9cd09ea5-c3e0-4322-b29c-9a86586e5f64"

            $exists = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
            if ($exists) {
                Remove-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -Force
            }
            Update-AZSPolicy -SubscriptionId $subscription_id -PolicyId $policy_id -Force
            Update-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -MetaData '{"version": "0.0.1"}'

            Update-AZSPolicy -SubscriptionId $subscription_id -PolicyId $policy_id -Force
            $result = Get-AzPolicyDefinition -SubscriptionId $subscription_id -Custom | Where-object {$_.Name -eq $policy_id}
            $result | Should -Not -Be "0.0.1"
            Remove-AzPolicyDefinition -SubscriptionId $subscription_id -Name $policy_id -Force
        }
    }
}