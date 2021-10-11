<#$parameterObj = @{
    Name                 = "FeatureName"
    DisplayName          = "Feature Names"
    Description          = "Comma separated list of feature names"
    ResourceType         = "cFeatureSet"
    ResourceId           = "features"
    ResourcePropertyName = 'FeatureName'
}

New-GuestConfigurationPolicy `
    -PolicyId '5242240f-ad9b-4f55-8d4d-746171a446f7' `
    -ContentUri $content `
    -DisplayName 'Enable Windows Features on a Virtual Machine from the FeatureName Tag' `
    -Description 'Enable Windows Features on a Virtual Machine from the FeatureName Tag' `
    -Path './policies' `
    -Platform Windows `
    -Version 1.0.0 `
    -Mode ApplyAndAutoCorrect `
    -Tag @{FeatureName = "replaceme" } `
    -Parameter $parameterObj `
    -Verbose
#> # Don't need to run this section - just update the policy file in ./policies

$policyDefinition = Get-Content -Path .\policies\DeployIfNotExists.json | ConvertFrom-Json 

$policyDefinition.properties.metadata.guestConfiguration.contentHash = $hash
$policyDefinition.properties.policyRule.then.details.existenceCondition.allOf[1].equals = $hash
$policyDefinition.properties.policyRule.then.details.deployment.properties.parameters.contentHash.value = $hash

$policyDefinition.properties.metadata.guestConfiguration.contentUri = $content
$policyDefinition.properties.policyRule.then.details.deployment.properties.parameters.contentUri.value = $content

$policyDefinition | ConvertTo-Json -Depth 100 | Out-File .\policies\DeployIfNotExists.json -Force

Publish-GuestConfigurationPolicy -Path .\policies