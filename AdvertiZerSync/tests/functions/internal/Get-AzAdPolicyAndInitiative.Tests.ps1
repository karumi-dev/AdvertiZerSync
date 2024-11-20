<#
.DESCRIPTION
    This test verifies, that all strings that have been used,
    are listed in the language files and thus have a message being displayed.

    It also checks, whether the language files have orphaned entries that need cleaning up.
#>

Describe "Testing Get-AzAdPolicy" {
    Context "Successful Download Policy and CSV Conversion" {
        It "Returns an Object with list of Policies" {
            $result = Get-AzAdPolicy | Out-String
            Write-PSFMessage -Level Verbose ($result)
            Get-AzAdPolicy | Should -Not -BeNullOrEmpty
        }
    }
    Context "Successful Download Policy Initiative and CSV Conversion" {
        It "Returns an Object with list of Policy Initiatives" {
            $result = Get-AzAdPolicyInitiative | Out-String
            Write-PSFMessage -Level Verbose ($result)
            Get-AzAdPolicyInitiative | Should -Not -BeNullOrEmpty
        }
    }
}