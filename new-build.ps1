#╔════════════════════════════════════════════════════════════════════════════════╗
#║                                                                                ║
#║   new-build.ps1                                                                ║
#║   Test functions for my WPF control                                            ║
#║                                                                                ║
#╟────────────────────────────────────────────────────────────────────────────────╢
#║   Guillaume Plante <codegp@icloud.com>                                         ║
#║   Code licensed under the GNU GPL v3.0. See the LICENSE file for details.      ║
#╚════════════════════════════════════════════════════════════════════════════════╝

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [Alias("rel", "r")]
    [switch]$Release,
    [Parameter(Mandatory = $false)]
    [Alias("gifs")]
    [switch]$AnimatedGifs
)
if (($Debug) -and ($Release)) {
    Write-Host "[ERROR] " -n -f DarkRed
    Write-Host "You cannot use both Debug and Release flag." -f DarkYellow
    return -1;
}


if ($Release) {
    $Target = "Release"
} else {
    $Target = "Debug"
}


Write-Host "=========================================================" -f DarkGray
Write-Host " Setting up build..`n" -f DarkYellow
Write-Host "  ✔️ Configuration $Target" -f DarkYellow


$ProjectPath = (Resolve-Path -Path "$PSScriptRoot").Path
$scriptsPath = Join-Path $ProjectPath "scripts"
$libsPath = Join-Path $ProjectPath "libs"
$BuildPath = Join-Path $ProjectPath "src"
$BinPath = Join-Path $BuildPath "bin"
$ArtifactsPath = Join-Path $BuildPath "artifacts"


Write-Host "=========================================================" -f DarkGray
Write-Host " Cleaning up...`n" -f DarkYellow
Write-Host "  ✔️  Deleting binaries path $BinPath" -f DarkYellow
Write-Host "  ✔️  Deleting artifacts path $ArtifactsPath" -f DarkYellow
Remove-ITem -Path "$BinPath" -Force -Recurse -ErrorAction Ignore | Out-Null
Remove-ITem -Path "$ArtifactsPath" -Force -Recurse -ErrorAction Ignore | Out-Null

$IncludeScript = Join-Path $scriptsPath "Include.ps1"
$BuildQueueScript = Join-Path $scriptsPath "BuildQueue.ps1"
$BuildRequestScript = Join-Path $scriptsPath "BuildRequest.ps1"
$RegisterDepScript = Join-Path $scriptsPath "Register-Dependencies.ps1"

Write-Host "=========================================================" -f DarkGray
Write-Host " Global Class Declaration (build queue, build requests, etc...)`n" -f DarkGray
Write-Host "  ✔️  Including Script $IncludeScript" -f DarkCyan
. "$IncludeScript"
Write-Host "  ✔️  Including Script $BuildQueueScript" -f DarkCyan
. "$BuildQueueScript"
Write-Host "  ✔️  Including Script $BuildRequestScript" -f DarkCyan
. "$BuildRequestScript"



Initialize-RegistryProjectPathProperties "ExtensionItemCtrl"



Write-Host "=========================================================" -f DarkGray
Write-Host " Dependencies...`n" -f DarkGray
Write-Host "  ✔️  Including Script $RegisterDepScript" -f Magenta
. "$RegisterDepScript"

[string]$tmp = if ($AnimatedGifs) { "Using AnimatedGifs" } else { "Simple Control" }
[string]$BuildInfo = "Target {0}, {1}" -f $Target, $tmp

Write-Host "=========================================================" -f DarkGray
Write-Host " Initialization Completed!...`n" -f Blue
Write-Host "  ✔️  Creating a NEW BUILD REQUEST $BuildInfo" -f Blue

$request2 = New-BuildRequest -WorkingDirectory "$BuildPath" -ProjectFilePath "WebExtensionPack.Controls.csproj" -Architecture "win-x64" -OutputPath "bin" -DeployPath "$libsPath" -ArtifactsPath "artifacts" -Configuration "$Target" -Framework "net472" -Version "1.0.1" -LogLevel Normal -Owner "gp"

if ($AnimatedGifs) {
    $request2.AddProperty("USE_ANIMATED_GIFS", "true")
} else {
    $request2.AddProperty("USE_ANIMATED_GIFS", "false")
}
$request2.AddProperty("LOGGING_ENABLED", "true")


while (BuildsRemaining) {
    $BuildRequest = Get-NextBuildRequest
    "STARTED BUILD $($BuildRequest.BuildId)" | Out-BuildTitle
    StartBuild $BuildRequest
}




[System.Management.Automation.PathInfo]$pi = Resolve-Path -Path "libs\WebExtensionPack" -RelativeBasePath "..\.." -ErrorAction Ignore
if (($pi) -and ($pi.Path)) {
    $DestinationDeployPath = $pi.Path

Write-Host "=========================================================" -f DarkGray
Write-Host " DEPLOYING BINARIES TO MAIN SOLUTION $DestinationDeployPath`n" -f DarkYellow

    Remove-Item -Path "$DestinationDeployPath" -Recurse -Force -ErrorAction Ignore
    if ($Release) {
        $sourcePath = Join-Path $libsPath "Release"
    } else {
        $sourcePath = Join-Path $libsPath "Debug"
    }

    Get-ChildItem -Path $sourcePath -File | % {
        $fn = $_.Fullname
        $bn = $_.Basename
        $srcFile = "$bn"
        Write-Host "  ✔️ $srcFile => " -f White -n 
        Write-Host "$DestinationDeployPath" -f DarkMagenta
        Copy-Item "$fn" "$DestinationDeployPath" -Force
    }

}
