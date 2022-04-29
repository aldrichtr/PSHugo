@{
    Staging = @{
        Path = 'stage'
    }
    Tests = @{
        Config = @{
            Analyzer = './.buildtool/pester.config.analyzertests.psd1'
            Unit = './.buildtool/pester.config.unittests.psd1'
            Performance = './.buildtool/pester.config.performancetests.psd1'
            Coverage = './.buildtool/pester.config.codecoverage.psd1'
        }
        Path = 'tests'
    }
    Project = @{
        Path = 'C:\Users\taldrich\projects\github\PSHugo'
        Name = 'PSHugo'
        Type = 'single'
        Modules = @{
            Root = @{
                Name = 'PSHugo'
                Path = 'source\PSHugo'
                Module = 'source\PSHugo\PSHugo.psm1'
                Manifest = 'source\PSHugo\PSHugo.psd1'
                Types = @(
                    'enum'
                    'classes'
                    'private'
                    'public'
                )
                CustomLoadOrder = ''
            }
        }
    }
    Plaster = @{
        Path = 'build/PlasterTemplates'
    }
    Artifact = @{
        Path = 'out'
    }
    Source = @{
        Path = 'source'
    }
    Build = @{
        Path = 'build'
        Rules = 'build/Rules'
        Config = 'build/Config'
        Tasks = 'build/Tasks'
        Tools = 'build/Tools'
    }
    Docs = @{
        Path = 'docs'
    }
}
