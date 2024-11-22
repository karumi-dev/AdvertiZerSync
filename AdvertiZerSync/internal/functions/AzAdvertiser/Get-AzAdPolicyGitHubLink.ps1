function Get-AzAdPolicyGithubLink{
    param (
        [Parameter(Mandatory=$true)]
        [Alias("PolicyName")]
        [string]$Name
    )

    $az_advertiser_url = "$($script:AzAdURL)" -f $Name
    $response = Invoke-WebRequest -Uri $az_advertiser_url -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        # Get Github URL
        $html_content = $response.Content
        $github_url = $html_content | Select-String -Pattern $script:AzAdGithubRegex
        if (!$github_url) {
            throw "Regex match failed for trying to find Azure Advertiser Github Policy Link, Check if the policy is a BuiltInPolicy $az_advertiser_url"
        } else {
            $github_url = $github_url.Matches[0].Value
        }
        # Add the Policy path to the Github URL (Usually adds /azurepolicy.json)
        $github_policy_url = $github_url + $script:AzAdGithubAzurePolicyFileName

        # Convert the github link to the raw link to the json file for downloading
        $github_raw = Convert-GitHubLinkToRaw $github_policy_url

        return [string]$github_raw
    }
    throw "Azure Policy $Name not found in Azure Advertiser"
}