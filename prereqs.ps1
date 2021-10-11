Install-Module GuestConfiguration -Verbose -Force
Install-Module PSDscResources -Verbose -Force

Connect-AzAccount

New-AzResourceGroup -Location australiaeast -Name policy-rg -Force
New-AzStorageAccount -ResourceGroupName policy-rg `
    -StorageAccountName vmrpolgc01 `
    -Location australiaeast `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableHttpsTrafficOnly $true `
    -MinimumTlsVersion TLS1_2
$ctx = (Get-AzStorageAccount -ResourceGroupName policy-rg -Name vmrpolgc01).Context
New-AzStorageContainer -Name dsc -Context $ctx -Permission Off

$assignment = New-AzPolicyAssignment -Name deployGCPre `
    -Location australiaeast `
    -Scope (Get-AzResourceGroup -Name policy-rg).ResourceId `
    -PolicySetDefinition (Get-AzPolicySetDefinition -Id '/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8') `
    -AssignIdentity

New-AzRoleAssignment -Scope (Get-AzResourceGroup -Name policy-rg).ResourceId `
    -RoleDefinitionName 'Contributor' `
    -ObjectId $assignment.Identity.principalId

Copy-Item .\cFeatureSet $env:PSModulePath.Split(";")[0] -Force -Recurse