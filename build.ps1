
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
    [ValidateSet("Debug", "Release", "All")]
    [string]$Target = "All",
    [Parameter(Mandatory = $false)]
    [switch]$Clean
)

$Script:TranscientString = ""

if ([string]::IsNullOrEmpty($Script:TranscientString)) {
    $Script:TranscientString = [guid]::NewGuid().ToString('N').SubString(0, 6).ToUpper()
}

$settings = Read-WpfCtrlSettings

if ($Settings.scripts -and $Settings.scripts.Count -gt 0) {
    foreach ($scriptPath in $Settings.scripts) {
        if (Test-Path $scriptPath) {
            Write-Verbose "Sourcing: $scriptPath"
            .$scriptPath
        } else {
            Write-Warning "Script not found: $scriptPath"
        }
    }
} else {
    Write-Warning "No scripts listed in settings."
}



try {

    $ErrorMsg = @"

                           _____ ____  ____   ___  ____  
                          | ____|  _ \|  _ \ / _ \|  _ \ 
                          |  _| | |_) | |_) | | | | |_) |
                          | |___|  _ <|  _ <| |_| |  _ < 
                          |_____|_| \_\_| \_\\___/|_| \_\

"@



    $AssembliesMsg = @"

      __   __   ___        __          ___  __           __   __        ___  __ 
 /\  /__` /__` |__   |\/| |__) |    | |__  /__`    |    /  \ /  ` |__/ |__  |  \
/~~\ .__/ .__/ |___  |  | |__) |___ | |___ .__/    |___ \__/ \__, |  \ |___ |__/

"@


    function Get-ProjectRootPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $ProjectRootPath = "C:\Dev\WpfCtrl-ExtensionItem"
        return $ProjectRootPath
    }


    function Get-SourcesPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $SourcesPath = Join-Path (Get-ProjectRootPath) "src"
        return $SourcesPath
    }


    function Get-TranscientTempPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()
        $tmpDateStr = (Get-Date).ToString('HHmmss')

        $libsPath = Join-Path (Get-ProjectRootPath) "libs"
        $tmpPath = Join-Path "$libsPath" "tmp"
        $TranscientTempPath = Join-Path $tmpPath "$($Script:TranscientString)"
        if (!(Test-Path "$TranscientTempPath")) { New-Item -Path "$TranscientTempPath" -ItemType Directory -Force | out-Null }
        return $TranscientTempPath
    }

    function Get-ScriptsPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $ScriptsPath = Join-Path (Get-ProjectRootPath) "scripts"
        return $ScriptsPath
    }

    function Get-DeployedRootPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $DeployedRootPath = Read-WpfCtrlSettings | Select -ExpandProperty 'deployed_root_path'
        return $DeployedRootPath
    }

    function Get-CompiledLibrariesPath {
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = 'Input file paths')]
            [string]$Target = " "
        )
        process {
            $ENV:Target = "$Target"
            $DeployPath = Read-WpfCtrlSettings | Select -ExpandProperty 'deploy_assemblies_path'
            return $DeployPath
        }

    }

    function Get-BinariesPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $BinariesPath = Join-Path (Get-SourcesPath) "bin"
        return $BinariesPath
    }


    function Get-TempObjectsPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $BinariesPath = Join-Path (Get-SourcesPath) "obj"
        return $BinariesPath
    }


    function Get-ProjectFrameworkVersion {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $FrameworkVer = "net6.0-windows"
        return $FrameworkVer
    }


    function Get-BinariesDebugPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $DebugPath = Join-Path (Get-BinariesPath) "Debug"
        $DebugPath = Join-Path $DebugPath (Get-ProjectFrameworkVersion)
        return $DebugPath
    }



    function Get-BinariesReleasePath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $ReleasePath = Join-Path (Get-BinariesPath) "Release"
        $ReleasePath = Join-Path $ReleasePath (Get-ProjectFrameworkVersion)
        return $ReleasePath
    }





    function Get-ProjectFrameworkVersion {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $FrameworkVer = "net6.0-windows"
        return $FrameworkVer
    }


    function Get-BinariesDebugPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $DebugPath = Join-Path (Get-BinariesPath) "Debug"
        $DebugPath = Join-Path $DebugPath (Get-ProjectFrameworkVersion)
        return $DebugPath
    }


    function Get-ProjectFrameworkVersion {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $FrameworkVer = "net6.0-windows"
        return $FrameworkVer
    }


    function Format-BuildTitle {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Input file paths')]
            [string]$Title,
            [Parameter(Mandatory = $false, HelpMessage = 'Output color')]
            [ValidateSet("Blue", "Cyan", "Green", "Yellow", "Magenta", "Gray", "White", "Red")]
            [string]$Color = "Cyan"
        )

        process {
            $NegativeColor = @{ Cyan = 'Red'; Red = 'Cyan'; Green = 'Magenta'; Magenta = 'Green'; Yellow = 'Blue'; Blue = 'Yellow'; Gray = 'White'; Black = 'White'; White = 'DarkBlue'; DarkBlue = 'White' }[$Color]
            $TitleColor = $Color
            $sep = [string]::new("=", 80)
            $titleLen = $Title.Length
            $padsLen = (80 / 2) - ($titleLen / 2)
            $pads = [string]::new(" ", $padsLen)
            $PaddedTitle = "{0}{1}" -f $pads, $Title
            Write-Host "`n`n$sep" -f $NegativeColor
            Write-Host "$PaddedTitle" -f $TitleColor
            Write-Host "$sep`n`n" -f $NegativeColor
        }
    }


    function Get-BinariesDebugPath {
        [CmdletBinding(SupportsShouldProcess)]
        param()

        $DebugPath = Join-Path (Get-BinariesPath) "Debug"
        $DebugPath = Join-Path $DebugPath (Get-ProjectFrameworkVersion)
        return $DebugPath
    }

    function Format-BuildResults {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Input file paths')]
            [string[]]$Path,
            [Parameter(Mandatory = $false, HelpMessage = 'Output color')]
            [ValidateSet("Blue", "Cyan", "Green", "Yellow", "Magenta", "Gray", "White", "Red")]
            [string]$Color = "Cyan"
        )

        begin {
            $header = "{0,-40} {1,10} {2,22} {3,12} {4,15}" -f "Name", "Size", "LastWriteTime", "Age", "Version"
            Write-Host $header -ForegroundColor White
            Write-Host ("".PadLeft($header.Length, '-')) -ForegroundColor DarkGray
        }
        process {
            foreach ($file in $Path) {
                if (-not (Test-Path $file)) {
                    Write-Host "Not found: $file" -ForegroundColor Red
                    continue
                }
                $info = Get-Item $file

                if ($info.Length -ge 1GB) { $sizeStr = "{0:N2} GB" -f ($info.Length / 1GB) }
                elseif ($info.Length -ge 1MB) { $sizeStr = "{0:N2} MB" -f ($info.Length / 1MB) }
                elseif ($info.Length -ge 1KB) { $sizeStr = "{0:N2} KB" -f ($info.Length / 1KB) }
                else { $sizeStr = "$($info.Length) B" }

                $lastWrite = $info.LastWriteTime
                $age = (Get-Date) - $lastWrite
                $ageStr = if ($age.TotalDays -ge 1) {
                    "{0}d {1}h" -f [int]$age.TotalDays, $age.Hours
                } elseif ($age.TotalHours -ge 1) {
                    "{0}h {1}m" -f [int]$age.TotalHours, $age.Minutes
                } else {
                    "{0}m {1}s" -f [int]$age.TotalMinutes, $age.Seconds
                }

                $versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($info.FullName)
                $ver = $versionInfo.FileVersion

                Write-Host ("{0,-40} {1,10} {2,22} {3,12} {4,15}" -f `
                         $info.Name,
                    $sizeStr,
                    $lastWrite.ToString("yyyy-MM-dd HH:mm:ss"),
                    $ageStr,
                    $ver
                ) -ForegroundColor $Color
            }
        }
    }

    $commandName = Read-WpfCtrlSettings | Select -ExpandProperty 'unregister_assemblies'
    $rcmd = Get-command -Name "$commandName" -ErrorAction Ignore
    if ($rcmd) {
        & $rcmd -Force
    }


    "BUILDING $($Target.ToUpper()) TARGET" | Format-BuildTitle

    $srcPath = Get-SourcesPath
    $dotnetCmd = (Get-Command "dotnet.exe" -ErrorAction Stop).Source
    Push-Location $srcPath
    $FrameworkVer = Get-ProjectFrameworkVersion

    try {
        Remove-Item (Get-CompiledLibrariesPath) -Recurse -Force -Confirm:$False -ErrorAction Stop
    } catch {
        $p = (Get-CompiledLibrariesPath)
        Write-Host "$p are in use..."
    }
    if ($Clean) {
        $ToDelete = @((Get-BinariesPath), (Get-TempObjectsPath))
        Write-Host "[CLEAN] " -f DarkRed -n
        Write-Host "Removing Transciemt Directories" -f DarkYellow
        $ToDelete | % { Write-Host "  -> $_" -f DarkYellow }
        try {
            Remove-Item $ToDelete -Recurse -Force -Confirm:$False -ErrorAction Stop
        } catch {
            Write-Host "$ErrorMsg" -f DarkRed
            Write-Host "$AssembliesMsg" -f DarkRed
            Unregister-ExtensionControlDll -Force
        }

    }



    $Command = if ($Clean) { "clean" } else { "build" }

    if ($Target -eq 'All') {
        $stdout = (New-TemporaryFile).FullName
        $stderr = (New-TemporaryFile).FullName
        [System.Collections.ArrayList]$LaunchArgs = [System.Collections.ArrayList]::new()
        [void]$LaunchArgs.Add("$Command")
        [void]$LaunchArgs.Add('--framework')
        [void]$LaunchArgs.Add("$FrameworkVer")
        [void]$LaunchArgs.Add('-c')
        [void]$LaunchArgs.Add("Debug")
        $SrcPath = Get-SourcesPath
        $Parameters = @{
            FilePath = "$dotnetCmd"
            ArgumentList = $LaunchArgs
            WorkingDirectory = "$SrcPath"
            NoNewWindow = $true
            Passthru = $true
            RedirectStandardError = $stderr
        }
        $cmd = Start-Process @Parameters
        while (!($cmd.HasExited)) { Start-Sleep -Milliseconds 500 }
        $BuildReturnCode = $cmd.ExitCode
        if ($BuildReturnCode -ne 0) {
            Write-Host "Build Failure!"
        }
        $Command = "build"
        $stdout = (New-TemporaryFile).FullName
        $stderr = (New-TemporaryFile).FullName
        [System.Collections.ArrayList]$LaunchArgs = [System.Collections.ArrayList]::new()
        [void]$LaunchArgs.Add("$Command")
        [void]$LaunchArgs.Add('--framework')
        [void]$LaunchArgs.Add("$FrameworkVer")
        [void]$LaunchArgs.Add('-c')
        [void]$LaunchArgs.Add("Release")
        $SrcPath = Get-SourcesPath
        $Parameters = @{
            FilePath = "$dotnetCmd"
            ArgumentList = $LaunchArgs
            WorkingDirectory = "$SrcPath"
            NoNewWindow = $true
            Passthru = $true
            RedirectStandardError = $stderr
        }
        $cmd = Start-Process @Parameters
        while (!($cmd.HasExited)) { Start-Sleep -Milliseconds 500 }
        $BuildReturnCode = $cmd.ExitCode
        if ($BuildReturnCode -ne 0) {
            Write-Host "Build Failure!"
        }
    } else {
        & "$dotnetCmd" "$Command" '--framework' "$FrameworkVer" '-c' "$Target"
    }

    $BinariesDebugPath = @("$(Get-BinariesDebugPath)", "$(Get-BinariesReleasePath)")
    if (!(Test-Path "$(Get-TranscientTempPath)")) { New-Item -Path "$(Get-TranscientTempPath)" -ItemType Directory -Force | out-Null }

    $tmpDbg = Join-Path (Get-TranscientTempPath) "Debug"
    $tmpRel = Join-Path (Get-TranscientTempPath) "Release"

    $TranscientTempPaths = @("$($tmpDbg)", "$($tmpRel)")


    "COMPILATION COMPLETED - DEPLOYING ASSEMBLIES TO WORKING DIRECTORIES" | Format-BuildTitle


    0..1 | % {
        $s = $BinariesDebugPath[$_]
        $d = $TranscientTempPaths[$_]

        $sourceExists = (Test-Path -Path "$s" -PathType Container)
        $sourceFilesCount = (Get-ChildItem -Path "$s" -Recurse -File) | Measure-Count
        if( ($sourceExists -eq $true) -and ($sourceFilesCount -gt 0) ) {
            try {
                $retVal = Move-Item -Path "$s" -Destination "$d" -Passthru -ErrorAction Stop
            } catch {
                Write-Host "[Deploy] " -f DarkRed -n
                Write-Host "Attempt #1 => Relocation Failed. $_" -f DarkYellow
            }
            Write-Host "[Deploy] " -f DarkRed -n
            Write-Host "Attempt #2 => Copy Assemblies Containers and all the files they contain to useable location. `"$s`" To Destination `"$d`"" -f DarkYellow
            try {
                $retVal = Copy-Item -Path $BinariesDebugPath -Destination "$DeployedRootPath" -Passthru -Recurse -ErrorAction Stop
                Remove-Item -Path "$BinariesDebugPath" -Recurse -Force -ErrorAction Ignore | Out-Null
            } catch {
                Write-Host "[Deploy] " -f DarkRed -n
                Write-Host "Attempt #2 => Copy Failed. $_" -f DarkYellow
            }
        }
    }

    if((Read-WpfCtrlSettings | Select -ExpandProperty 'register_assemblies_after_build') -eq 1){
            "AUTOMATIC ASSEMBLY REGISTRATION" | Format-BuildTitle
            Register-ExtensionControlDll
    }

    Pop-Location
} catch {
    Show-ExceptionDetails ($_)
}
