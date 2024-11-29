function Get-AzAdPolicyDTALink{
    param (
        [Parameter(Mandatory=$true)]
        [Alias("PolicyName")]
        [string]$Name
    )

    $az_advertiser_url = "$($script:AzAdPolicyURL)" -f $Name
    $response = Invoke-WebRequest -Uri $az_advertiser_url -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        # Get dta URL
        $html_content = $response.Content
        foreach ($regex in $script:AzAdDTARegex) {
            $dta_url = $html_content | Select-String -Pattern $regex
            # No Regex match found try the next pattern
            if (!$dta_url) {
                continue
            }
            $dta_url = $dta_url.Matches[0].Value
            Write-Debug "Pattern Found with: $regex"
            Write-Debug "Match Result: `"$dta_url`""

            # Convert the dta link to the raw link to the json file for downloading
            $dta_raw = Convert-DTALinkToRaw $dta_url

            Write-Debug "Returning Converted dta Raw Link: `"$dta_raw`""
            return [string]$dta_raw
        }
        Write-Debug "No Regex Patterns Matches for the Azure Policy $az_advertiser_url"
        throw [NoDTALinkException] ("Regex match failed for trying to find Azure Advertiser dta Policy Link, Check if the policy is a BuiltInPolicy $az_advertiser_url")
    }
    throw "Azure Policy $Name not found in Azure Advertiser"
}