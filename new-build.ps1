#╔════════════════════════════════════════════════════════════════════════════════╗
#║                                                                                ║
#║   new-build.ps1                                                                ║
#║   Test functions for my WPF control                                            ║
#║                                                                                ║
#╟────────────────────────────────────────────────────────────────────────────────╢
#║   Guillaume Plante <codegp@icloud.com>                                         ║
#║   Code licensed under the GNU GPL v3.0. See the LICENSE file for details.      ║
#╚════════════════════════════════════════════════════════════════════════════════╝



. "C:\Dev\PsBuild\Include.ps1"
. "C:\Dev\PsBuild\BuildQueue.ps1"
. "C:\Dev\PsBuild\BuildRequest.ps1"



function Get-ProjectFrameworkVersion {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    #$FrameworkVer = "net6.0-windows"
    $FrameworkVer = "net472"
    return $FrameworkVer
}


$Target = "Release"
$FrameworkVer = Get-ProjectFrameworkVersion
$ProjectPath = (Resolve-Path -Path "$PSScriptRoot").Path
$scriptsPath = Join-Path $ProjectPath "scripts"
$RegisterDepScript = Join-Path $scriptsPath "Register-Dependencies.ps1"
$libsPath = Join-Path $ProjectPath "libs"
$BuildPath = Join-Path $ProjectPath "src"
$BinPath = Join-Path $BuildPath "bin"
$ReleasePath = Join-Path $BinPath "$Target"
$ReleaseBinariesPath = Join-Path $ReleasePath (Get-ProjectFrameworkVersion)
$ArtifactsPath = Join-Path $BuildPath "artifacts"

Remove-ITem -Path "$BinPath" -Force -Recurse -ErrorAction Ignore | Out-Null
Remove-ITem -Path "$ArtifactsPath" -Force -Recurse -ErrorAction Ignore | Out-Null



function Invoke-DeployBinaries {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release")]
        [string]$Target = "Release"
    )
    Write-Verbose "[Invoke-DeployBinaries] $Target"
    $ProjectPath = (Resolve-Path -Path "$PSScriptRoot").Path
    $TargetProjectPath = "C:\Dev\BinaryDepot-DownloadTool"
    $DeployPath = Join-Path "$TargetProjectPath" "libs\WebExtensionPack"
    Write-Verbose "[Invoke-DeployBinaries] DeployPath $DeployPath"
    Remove-ITem -Path "$DeployPath" -Force -Recurse -ErrorAction Ignore | Out-Null

    $BuildPath = Join-Path $ProjectPath "src"
    $BinPath = Join-Path $BuildPath "bin"
    $ReleasePath = Join-Path $BinPath "$Target"

    $MovedItem = Move-Item -Path "$ReleasePath" -Destination "$DeployPath" -Force -Passthru
    $MovedItem

    $TargetLibPath = Join-Path "$($MovedItem.FullName)" "WebExtensionPack.Controls.dll"



    $TargetLibPathExists = Test-Path "$TargetLibPath" -PathType Leaf
    $TargetLibPathWriteTime = (gi $TargetLibPath).LastWriteTime
    $DeltaTargetLibPath = (Get-Date) - $TargetLibPathWriteTime
    $WhenTargetLibPath = Out-TimeSpan $DeltaTargetLibPath

    Write-Host "=====================================================" -f DarkCyan
    Write-Host "                Invoke-DeployBinaries                " -f White
    Write-Host "=====================================================" -f DarkCyan
    Write-Host "TargetProjectPath $TargetProjectPath" -f White
    Write-Host "TargetLibPathExists (exists $TargetLibPathExists) $TargetLibPath" -f White
    Write-Host "TargetLibPath Updated $WhenTargetLibPath ago" -f DarkYellow

}


$request2 = New-BuildRequest -WorkingDirectory "$BuildPath" -ProjectFilePath "WebExtensionPack.Controls.csproj" -Architecture "win-x64" -OutputPath "bin" -DeployPath "$libsPath" -ArtifactsPath "artifacts" -Configuration "Release" -Framework "$FrameworkVer" -Version "1.0.1" -LogLevel Normal -Owner "gp"

while (BuildsRemaining) {
    $BuildRequest = Get-NextBuildRequest
    "STARTED BUILD $($BuildRequest.BuildId)" | Out-BuildTitle
    StartBuild $BuildRequest
}


Invoke-DeployBinaries