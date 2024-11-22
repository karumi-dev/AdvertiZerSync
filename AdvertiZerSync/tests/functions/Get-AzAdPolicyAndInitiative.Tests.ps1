<#
.DESCRIPTION
    This test verifies, that all strings that have been used,
    are listed in the language files and thus have a message being displayed.

    It also checks, whether the language files have orphaned entries that need cleaning up.
#>

Describe "Testing Get-AzAdPolicy" {
    Context "Download Policy and CSV Conversion" {
        It "Returns an Object with list of Policies" {
            Get-AzAdPolicy | Should -Not -BeNullOrEmpty
        }
    }
}
Describe "Testing Get-AzAdInitiative" {
    Context "Download Initiative and CSV Conversion" {
        It "Returns an Object with list of Policy Initiatives" {
            Get-AzAdInitiative | Should -Not -BeNullOrEmpty
        }
    }
}