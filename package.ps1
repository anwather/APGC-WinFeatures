$resourceGroupName = "resource group name" # Update with your own details
$storageAccountName = "storage account name" # Update with your own details
$location = "australiaeast" # Update with your own details

New-GuestConfigurationPackage -Name InstallFeatures `
    -Configuration .\InstallFeatures\localhost.mof `
    -Type AuditAndSet -Force

$content = Publish-GuestConfigurationPackage -Path .\InstallFeatures\InstallFeatures.zip `
    -ResourceGroupName $resourceGroupName `
    -StorageAccountName $storageAccountName -StorageContainerName dsc -Force | ForEach-Object ContentUri

Write-Output "$content"
$hash = (Get-FileHash .\InstallFeatures\InstallFeatures.zip).Hash
Write-Output $hash
