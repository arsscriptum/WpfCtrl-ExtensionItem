




function Get-ExtensionControlDllPath {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release")]
        [string]$Target = "Release"

    )

    $RootPath = (Resolve-Path "$PSScriptRoot\..").Path
    [string]$DllPath = "{0}\src\bin\{1}\net6.0-windows\WebExtensionPack.Controls.dll" -f $RootPath, $Target
    if(Test-Path $DllPath){
        return $DllPath
    }else{
        [string]$BinaryPath = "{0}\src\bin\{1}" -f $RootPath, $Target
        [string]$AllBinaryPath = "{0}\src\bin" -f $RootPath
        $AllTargetedDlls = Get-ChildItem -Path "$BinaryPath" -Filter "*.dll" -File -Recurse | Select -ExpandProperty Fullname
        $AllDlls = Get-ChildItem -Path "$BinaryPath" -Filter "*.dll" -File -Recurse | Select -ExpandProperty Fullname
        $DllTargetedFound = $AllTargetedDlls -match "WebExtensionPack.Controls"
        $DllFound = $AllDlls -match "WebExtensionPack.Controls"
        if($DllTargetedFound){
            return $DllTargetedFound
        }elseif($DllFound){
            return $DllFound
        }
    }
    return $Null

}


function Register-ExtensionControlDll {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release")]
        [string]$Target = "Release"

    )

    $DllPath = Get-ExtensionControlDllPath $Target 
    if(($DllPath) -And (Test-Path $DllPath)){
        return $DllPath
    }
    return $Null
}


function Show-ExtensionItemDialog {
    param ()

    Register-ExtensionControlDll

    Add-Type -Path $DllPath
    Add-Type -AssemblyName PresentationFramework

    # Create window
    $window = New-Object System.Windows.Window
    $window.Width = 400
    $window.Height = 120
    $window.Title = "ExtensionItem State Demo"
    $window.WindowStartupLocation = "CenterScreen"

    # Main grid
    $grid = New-Object System.Windows.Controls.Grid
    $grid.Margin = [System.Windows.Thickness]::new(8)

    $grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
    $grid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))

    # Add ExtensionItem control
    $ctrl = New-Object WebExtensionPack.Controls.ExtensionItem
    $ctrl.ExtensionLabel = "Sample Extension"
    $ctrl.Status = [WebExtensionPack.Controls.ExtensionStatus]::Pending
    [System.Windows.Controls.Grid]::SetRow($ctrl, 0)
    $grid.Children.Add($ctrl)

    # Add Button
    $button = New-Object System.Windows.Controls.Button
    $button.Content = "Change State"
    $button.Width = 120
    $button.Height = 28
    $button.HorizontalAlignment = "Left"
    $button.Margin = [System.Windows.Thickness]::new(0,10,0,0)
    [System.Windows.Controls.Grid]::SetRow($button, 1)
    $grid.Children.Add($button)

    # Cycling logic
    $states = [WebExtensionPack.Controls.ExtensionStatus]::GetValues([WebExtensionPack.Controls.ExtensionStatus])
    $i = 0
    $button.Add_Click({
        $i = ($i + 1) % $states.Count
        $ctrl.Status = $states[$i]
        $button.Content = "State: $($states[$i]) (click to cycle)"
    })
    $button.Content = "State: Pending (click to cycle)"

    $window.Content = $grid
    $window.ShowDialog()
}
