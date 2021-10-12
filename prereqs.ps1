Install-Module GuestConfiguration -Verbose -Force
Install-Module PSDscResources -Verbose -Force

Connect-AzAccount

$resourceGroupName = "resource group name" # Update with your own details
$storageAccountName = "storage account name" # Update with your own details
$location = "australiaeast" # Update with your own details

New-AzResourceGroup -Location $location -Name $resourceGroupName -Force
New-AzStorageAccount -ResourceGroupName $resourceGroupName `
    -StorageAccountName $storageAccountName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableHttpsTrafficOnly $true `
    -MinimumTlsVersion TLS1_2
$ctx = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName).Context
New-AzStorageContainer -Name dsc -Context $ctx -Permission Off

$assignment = New-AzPolicyAssignment -Name deployGCPre `
    -Location $location `
    -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId `
    -PolicySetDefinition (Get-AzPolicySetDefinition -Id '/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8') `
    -AssignIdentity

New-AzRoleAssignment -Scope (Get-AzResourceGroup -Name $resourceGroupName).ResourceId `
    -RoleDefinitionName 'Contributor' `
    -ObjectId $assignment.Identity.principalId

Copy-Item .\cFeatureSet $env:PSModulePath.Split(";")[0] -Force -Recurse