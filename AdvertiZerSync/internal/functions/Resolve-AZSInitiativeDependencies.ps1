function Resolve-AZSInitiativeDependencies {
    param (
        [Parameter(Mandatory=$true)]
        [Alias("Initiative", "Definition")]
        [object]$InitiativeDefinition,

        [Parameter()]
        [switch]$Force,

        [Parameter(
            ParameterSetName = 'ManagementGroupName',
            Mandatory = $true
        )]
        [string]$ManagementGroupName,

        [Parameter(
            ParameterSetName = 'SubscriptionId',
            Mandatory = $true
        )]
        [string]$SubscriptionId
    )
    # Determine whether to use Management Group Name or Subscription ID
    if ($PSBoundParameters.ContainsKey("ManagementGroup")) {
        $arguements = @{
            ManagementGroupName = $ManagementGroupName
        }
    }
    elseif ($PSBoundParameters.ContainsKey("SubscriptionId")) {
        $arguements = @{
            SubscriptionId = $SubscriptionId
        }
    }
    else {
        throw "Error no ManagementGroupName or SubscriptionId found"
    }
    $initiative_definition_json = $InitiativeDefinition.Definition | ConvertFrom-Json -Depth 100
    $policydefinitions = $initiative_definition_json.properties.policyDefinitions
    foreach ($policydefinition in $policydefinitions) {
        $policy_id = $policydefinition.policyDefinitionId.Split("/")[-1]
        Write-Debug "Checking if $policy_id exists in Azure already"
        try {
            if ($Force) {
                Update-AZSPolicy -PolicyId $policy_id -Force @arguements
            } else {
                Update-AZSPolicy -PolicyId $policy_id @arguements
            }
        } catch [BuiltInPolicyException] {
            Write-Debug "BuiltIn policy skipping dependency update"
            continue
        } 
        # catch {
        #     Write-Debug "CAUGHT ERROR $_"
        # }
        Write-Debug "Updating Policy Path"
        $azure_policy = Get-AzPolicyDefinition @arguements -Custom | Where-object {$_.Name -eq $policy_id}
        if ($azure_policy) {
            Write-Debug "Updating Policy Path from `"$($policydefinition.policyDefinitionId)`" -> `"$($azure_policy.Id)`""
            $policydefinition.policyDefinitionId = $azure_policy.Id
        } else {
            throw "Error - Policy was not uploaded successfully so there was a missing dependency for $policy_id"
        }
    }
    $InitiativeDefinition.Definition = $initiative_definition_json | ConvertTo-Json -Depth 100
    return $InitiativeDefinition
}