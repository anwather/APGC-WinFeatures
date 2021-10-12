enum Ensure {
    Absent
    Present
}

[DscResource()]
class cFeatureSet {


    [DscProperty(Key)]
    [string] $FeatureName

    [DscProperty()]
    [Ensure] $Ensure
    
    # Gets the resource's current state.
    [cFeatureSet] Get() {
        $this.SetPath()
        $features = $this.FeatureName.Split(",")
        $counter = 0
        $status = Get-WindowsFeature -Name $features
        foreach ($s in $status) {
            switch ($status.InstallState) {
                "Installed" { $this.Ensure = [Ensure]::Present }
                default { $counter++ }
            }
        
        }
        if ($counter -gt 0) {
            $this.Ensure = [Ensure]::Absent
        }
        return $this
    }
    
    # Sets the desired state of the resource.
    [void] Set() {
        $this.SetPath()
        $features = $this.FeatureName.Split(",")
        if ($this.Ensure -eq "Present") {
            Install-WindowsFeature -Name $features -Verbose
        }
        else {
            Uninstall-WindowsFeature -Name $features -Remove -Verbose
        }
    }
    
    # Tests if the resource is in the desired state.
    [bool] Test() {
        $this.SetPath()
        $features = $this.FeatureName.Split(",")
        $counter = 0
        $status = Get-WindowsFeature -Name $features
        foreach ($s in $status) {
            switch ($s.InstallState) {
                "Installed" {}
                default { $counter++ }
            }
        
        }
        if ($counter -gt 0) {
            return $false
        }
        return $true
    }

    [void] SetPath() {
        $env:PSModulePath += ";C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules"
    }
}