
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
    [ValidateSet("Debug", "Release", "All")]
    [string]$Target = "All",
    [Parameter(Mandatory = $false)]
    [switch]$Clean
)

try {


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
            $NegativeColor = @{Cyan='Red'; Red='Cyan'; Green='Magenta'; Magenta='Green'; Yellow='Blue'; Blue='Yellow'; Gray='White'; Black='White'; White='DarkBlue'; DarkBlue='White'}[$Color]
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


    "BUILDING $($Target.ToUpper()) TARGET" | Format-BuildTitle

    $srcPath = Get-SourcesPath
    $dotnetCmd = (Get-Command "dotnet.exe" -ErrorAction Stop).Source
    Push-Location $srcPath
    $FrameworkVer = Get-ProjectFrameworkVersion


    if ($Clean) {
        $ToDelete = @((Get-BinariesPath), (Get-TempObjectsPath))
        Write-Host "[CLEAN] " -f DarkRed -n
        Write-Host "Removing Transciemt Directories" -f DarkYellow
        $ToDelete | % { Write-Host "  -> $_" -f DarkYellow }
        Remove-Item $ToDelete -Recurse -Force -Confirm:$False -ErrorAction Ignore
    }

    $Command = if ($Clean) { "clean" } else { "build" }

    if ($Target -eq 'All') {
        & "$dotnetCmd" "$Command" '--framework' "$FrameworkVer" '-c' 'Debug'
        if ($LASTEXITCODE -eq 0) {
            $CommandId = "Get-Binaries{0}Path" -f "Debug"
            $GetPathCmd = Get-Command -Name "$CommandId" -ErrorAction Ignore
            $ResPath = & $GetPathCmd
            $GeneratedFiles = Get-ChildItem "$ResPath" -File | Select -ExpandProperty FullName
            "BUILD RESULTS" | Format-BuildTitle  -Color Cyan
            $GeneratedFiles | Format-BuildResults -Color Blue
        }
        $Command = "build"
        & "$dotnetCmd" "$Command" '--framework' "$FrameworkVer" '-c' 'Release'
        if ($LASTEXITCODE -eq 0) {
            $CommandId = "Get-Binaries{0}Path" -f "Release"
            $GetPathCmd = Get-Command -Name "$CommandId" -ErrorAction Ignore
            $ResPath = & $GetPathCmd
            $GeneratedFiles = Get-ChildItem "$ResPath" -File | Select -ExpandProperty FullName
            "BUILD RESULTS" | Format-BuildTitle  -Color Red
            $GeneratedFiles | Format-BuildResults -Color Magenta
        }
    } else {
        & "$dotnetCmd" "$Command" '--framework' "$FrameworkVer" '-c' "$Target"
    }


    Pop-Location
} catch {
    Show-ExceptionDetails ($_)
}
finally {
    Pop-Location
}
