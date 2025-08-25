
function Get-ExtensionControlDllPath {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release", "Any")]
        [string]$Target = "Any"

    )

    try {
        $LibBasename = "WebExtensionPack.Controls"
        $LibName = "{0}.dll" -f $LibBasename
        $BinaryRootPath = Get-BinariesPath

        if ($Target -eq 'Any') {
            Write-Verbose "[Get-ExtensionControlDllPath] Any Targets -> Searching in `"$BinaryRootPath`""
            [string[]]$AllDlls = Get-ChildItem -Path "$BinaryRootPath" -Filter "*.dll" -File -Recurse | Select -ExpandProperty Fullname | sort
            $DllFound = $AllDlls.Where({ $_.EndsWith("$LibName") }) | Select -First 1
            if ($DllFound) {
                Write-Verbose "Found `"$DllFound`""
                return $DllFound
            }
        } else {
            [string]$DllPath = "{0}\{1}\net6.0-windows\{2}" -f $BinaryRootPath, $Target, $LibName
            Write-Verbose "[Get-ExtensionControlDllPath] Target $Target -> trying direct path `"$DllPath`""
            if (Test-Path $DllPath) {
                Write-Verbose "Found `"$DllPath`""
                return $DllPath
            } else {
                [string]$TargetBinaryPath = Join-Path "$BinaryRootPath" "$Target"
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

