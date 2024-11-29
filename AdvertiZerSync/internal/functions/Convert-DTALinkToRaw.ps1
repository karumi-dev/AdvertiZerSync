function Convert-DTALinkToRaw {
    param (
        [Parameter(Mandatory=$true)]
        [Alias("URL", "URI")]
        [string]$DTAURL
    )
    $result = [System.Web.HttpUtility]::UrlDecode($dtaURL)
    $result = $result | Select-String -Pattern "https:\/\/www\.azadvertizer\.net\/azpolicyadvertizerdta.*\.json"
    $result = $result.matches[0]
    return $result
}