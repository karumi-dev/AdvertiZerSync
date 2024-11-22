function Convert-GitHubLinkToRaw {
    param (
        [Parameter(Mandatory=$true)]
        [Alias("URL", "URI")]
        [string]$GitHubUrl
    )

    # Check if the URL is a valid GitHub URL
    if ($GitHubUrl -notmatch '^https://github\.com/') {
        throw "Invalid GitHub URL. Please provide a valid GitHub URL."
    }

    # Replace 'github.com' with 'raw.githubusercontent.com'
    $rawUrl = $GitHubUrl -replace '^https://github\.com/', 'https://raw.githubusercontent.com/'

    # Remove '/tree/' or '/blob/' from the URL
    $rawUrl = $rawUrl -replace '/tree/|/blob/', '/'

    return $rawUrl
}