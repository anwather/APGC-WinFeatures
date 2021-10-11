New-GuestConfigurationPackage -Name InstallFeatures `
    -Configuration .\InstallFeatures\localhost.mof `
    -Type AuditAndSet -Force

$content = Publish-GuestConfigurationPackage -Path .\InstallFeatures\InstallFeatures.zip `
    -ResourceGroupName policy-rg `
    -StorageAccountName vmrpolgc01 -StorageContainerName dsc -Force | ForEach-Object ContentUri

Write-Output "$content"
$hash = (Get-FileHash .\InstallFeatures\InstallFeatures.zip).Hash
Write-Output $hash
