function Get-AzAdPolicyDefinitionVersion{
    param (
        [Parameter(Mandatory=$true)]
        [Alias("Definition")]
        [string]$PolicyDefinition
    )

    $definition_json = $PolicyDefinition | ConvertFrom-Json
    return $definition_json.properties.metadata.version
}