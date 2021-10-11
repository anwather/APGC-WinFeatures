Configuration InstallFeatures {
    Import-DscResource -ModuleName PSDscResources
    Import-DscResource -ModuleName cFeatureSet

    Node localhost {
        cFeatureSet features {
            FeatureName = "replaced"
            Ensure      = "Present"
        }
    }
}

InstallFeatures