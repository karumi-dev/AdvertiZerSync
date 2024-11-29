function Get-AzAdInitiativeGithubLink{
    param (
        [Parameter(Mandatory=$true)]
        [Alias("PolicyName")]
        [string]$Name
    )

    $az_advertiser_url = "$($script:AzAdInitiativeURL)" -f $Name
    Write-Debug "AzAdvertiser Initiative URL: $az_advertiser_url"
    $response = Invoke-WebRequest -Uri $az_advertiser_url -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        # Get Github URL
        $html_content = $response.Content
        foreach ($regex in $script:AzAdGithubRegex) {
            $github_url = $html_content | Select-String -Pattern $script:AzAdGithubRegex
            # No Regex match found try the next pattern
            if (!$github_url) {
                continue
            }

            $github_url = $github_url.Matches[0].Value
            Write-Debug "Pattern Found with: $regex"
            Write-Debug "Match Result: `"$github_url`""

            # Add the Policy path to the Github URL (Usually adds /azurepolicy.json)
            if (!($github_url -like "*.json")) {
                $github_url = $github_url + $script:AzAdGithubAzurePolicyFileName
            }

            # Convert the github link to the raw link to the json file for downloading
            $github_raw = Convert-GitHubLinkToRaw $github_url

            Write-Debug "Returning Converted Github Raw Link: `"$github_raw`""
            return [string]$github_raw
        }
        Write-Debug "No Regex Patterns Matches for the Azure Policy $az_advertiser_url"
        throw [BuiltInPolicyException] ("Regex match failed for trying to find Azure Advertiser Github Policy Link, Check if the policy is a BuiltInPolicy $az_advertiser_url")
    }
    throw "Azure Policy $Name not found in Azure Advertiser"
}