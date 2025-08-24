




function Get-ExtensionControlDllPath {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release", "Any")]
        [string]$Target = "Any"

    )

    $LibBasename = "WebExtensionPack.Controls"
    $LibName = "{0}.dll" -f $LibBasename
    $RootPath = (Resolve-Path "$PsScriptRoot\..").Path
    [string]$BinaryRootPath = "{0}\src\bin" -f $RootPath
    [string]$DebugBinaryPath = Join-Path "$BinaryRootPath" "Debug"
    [string]$ReleaseBinaryPath = Join-Path "$BinaryRootPath" "Release"


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

}


function Register-ExtensionControlDll {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "targets")]
        [ValidateSet("Debug", "Release", "Any")]
        [string]$Target = "Any"
    )

    if(Test-ExtensionControlLoaded){
        Write-Verbose "[Register-ExtensionControlDll] already loaded"
        return;
    }

    $DllPath = Get-ExtensionControlDllPath $Target
    if (($DllPath) -and (Test-Path $DllPath)) {
        Write-Verbose "[Register-ExtensionControlDll] Add-Type -Path `"$DllPath`""
        Add-Type -Path "$DllPath"
    }else{
        throw "No Assemblies Found"
    }
}


function Test-ExtensionControlLoaded {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    try{
        $Obj = [WebExtensionPack.Controls.ExtensionStatus] -as [type]
        return $True
    }catch{
        return $False
    }
}



function Show-ExtensionItemDialog {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    Register-ExtensionControlDll
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
    $ctrl.ResetExtensionStatus();
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
    $button.Margin = [System.Windows.Thickness]::new(0, 10, 0, 0)
    [System.Windows.Controls.Grid]::SetRow($button, 1)
    $grid.Children.Add($button)

    # Cycling logic
    $states = [WebExtensionPack.Controls.ExtensionStatus]::GetValues([WebExtensionPack.Controls.ExtensionStatus])
    $i = 0
    $button.Add_Click({
            $ctrl.SetNextExtensionStatus();
            $currStatus = $ctrl.GetExtensionStatusString()
            $button.Content = "State: $currStatus (click to cycle)"
        })
    $button.Content = "State: Pending (click to cycle)"

    $window.Content = $grid
    $window.ShowDialog()
}
