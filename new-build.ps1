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

$ProjectPath = "C:\Dev\WpfCtrl-ExtensionItem"
$TmpPath = Join-Path $ProjectPath "tmp"
$BuildPath = Join-Path $ProjectPath "src"
$BinPath = Join-Path $BuildPath "bin"
$ArtifactsPath = Join-Path $BuildPath "artifacts"
$Target = "Release"
Remove-ITem -Path "$BinPath" -Force -Recurse -ErrorAction Ignore | Out-Null
Remove-ITem -Path "$ArtifactsPath" -Force -REcurse -ErrorAction Ignore | Out-Null

#$request1 = New-BuildRequest -WorkingDirectory "C:\Dev\WpfCtrl-ExtensionItem\src" -ProjectFilePath "WebExtensionPack.Controls.csproj" -Architecture "win-x64" -OutputPath "bin" -ArtifactsPath "artifacts" -Configuration "Debug" -Framework "net6.0-windows" -Version "1.0.1" -LogLevel Normal -Owner "gp"
$request2 = New-BuildRequest -WorkingDirectory "C:\Dev\WpfCtrl-ExtensionItem\src" -ProjectFilePath "WebExtensionPack.Controls.csproj" -Architecture "win-x64" -OutputPath "bin" -DeployPath "$TmpPath" -ArtifactsPath "artifacts" -Configuration "Release" -Framework "net6.0-windows" -Version "1.0.1" -LogLevel Normal -Owner "gp"

while (BuildsRemaining) {
    $BuildRequest = Get-NextBuildRequest
    "STARTED BUILD $($BuildRequest.BuildId)" | Out-BuildTitle
    StartBuild $BuildRequest
}


