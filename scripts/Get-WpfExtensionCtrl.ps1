function Get-DeployedAssembliesPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    process {
        $DeployPath = Read-WpfCtrlSettings | Select -ExpandProperty 'deploy_assemblies_path'
        return $DeployPath
    }
}

function Get-DeployedRootPath {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    process {
        $DeployedRootPath = Read-WpfCtrlSettings | Select -ExpandProperty 'deployed_root_path'
        return $DeployedRootPath
    }
}


function Get-ExtensionControlDllPath {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release", "Any")]
        [string]$Target = "Any"
    )

    try {
        Write-Verbose "[Get-ExtensionControlDllPath] $Target"
        $LibBasename = "WebExtensionPack.Controls"
        $LibName = "{0}.dll" -f $LibBasename
        if($Target -eq 'Any'){ $ENV:Target = " " }else{ $ENV:Target = "$Target" }
        $DeployedAssembliesPath = Get-DeployedAssembliesPath
        Write-Verbose "[Get-ExtensionControlDllPath] Get-DeployedAssembliesPath `"$DeployedAssembliesPath`""

        if ($Target -eq 'Any') {
            Write-Verbose "[Get-ExtensionControlDllPath] Any Targets -> Searching in `"$DeployedAssembliesPath`""
            [string[]]$AllDlls = Get-ChildItem -Path "$DeployedAssembliesPath" -Filter "*.dll" -File -Recurse | Select -ExpandProperty Fullname | sort
            $DllFound = $AllDlls.Where({ $_.EndsWith("$LibName") }) | Select -First 1
            if ($DllFound) {
                Write-Verbose "Found `"$DllFound`""
                return $DllFound
            }
        } else {
            [string]$DllPath = Join-Path $DeployedAssembliesPath $LibName
            Write-Verbose "[Get-ExtensionControlDllPath] Target $Target -> trying direct path `"$DllPath`""
            if (Test-Path $DllPath) {
                Write-Verbose "Found `"$DllPath`""
                return $DllPath
            } else {
                [string]$TargetBinaryPath = Join-Path (Get-DeployedRootPath) "$Target"
                Write-Verbose "[Get-ExtensionControlDllPath] Target $Target -> Searching all Dlls in `"$TargetBinaryPath`""
                [string[]]$AllTargetedDlls = Get-ChildItem -Path "$TargetBinaryPath" -Filter "*.dll" -File -Recurse | Select -ExpandProperty Fullname | sort
                $DllTargetedFound = $AllTargetedDlls.Where({ $_.EndsWith("$Pattern") }) | Select -First 1
                if ($DllTargetedFound) {
                    Write-Verbose "[Get-ExtensionControlDllPath] Found `"$DllTargetedFound`""
                    return $DllTargetedFound
                }
                write-verbose "[Get-ExtensionControlDllPath] not found...."
            }
        }

        return $Null
    } catch {
        throw $_
    }
}

