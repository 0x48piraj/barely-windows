#Requires -RunAsAdministrator


# Show error if current PowerShell environment does not have LanguageMode set to FullLanguage 
if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage") {
    Write-Host "Error: Barely Windows is unable to run on your system, PowerShell execution is restricted by security policies" -ForegroundColor Red
    Write-Output ""
    Write-Output "Press enter to exit..."
    Read-Host | Out-Null
    Exit
}


# Function to await key press before exiting
function AwaitKeyToExit {
    if (-not $Silent) {
        Write-Output ""
        Write-Output "Press any key to exit..."
        $null = [System.Console]::ReadKey()
    }
}

# Function to apply FPS Boost
function Enable-FPSBoost {
    Write-Host "Enabling FPS Boost..."
    # Apply settings that optimize system for gaming and performance
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "GameDVR_Enabled" -Value 0
}

# Forcefully removes Microsoft Edge using its uninstaller
function ForceRemoveEdge {
    # Based on work from loadstring1 & ave9858
    Write-Output "> Forcefully uninstalling Microsoft Edge..."

    $regView = [Microsoft.Win32.RegistryView]::Registry32
    $hklm = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $regView)
    $hklm.CreateSubKey('SOFTWARE\Microsoft\EdgeUpdateDev').SetValue('AllowUninstall', '')

    # Create stub (Creating this somehow allows uninstalling Edge)
    $edgeStub = "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
    New-Item $edgeStub -ItemType Directory | Out-Null
    New-Item "$edgeStub\MicrosoftEdge.exe" | Out-Null

    # Remove Edge
    $uninstallRegKey = $hklm.OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge')
    if ($null -ne $uninstallRegKey) {
        Write-Output "Running uninstaller..."
        $uninstallString = $uninstallRegKey.GetValue('UninstallString') + ' --force-uninstall'
        Start-Process cmd.exe "/c $uninstallString" -WindowStyle Hidden -Wait

        Write-Output "Removing leftover files..."

        $edgePaths = @(
            "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk",
            "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk",
            "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk",
            "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Tombstones\Microsoft Edge.lnk",
            "$env:PUBLIC\Desktop\Microsoft Edge.lnk",
            "$env:USERPROFILE\Desktop\Microsoft Edge.lnk",
            "$edgeStub"
        )

        foreach ($path in $edgePaths) {
            if (Test-Path -Path $path) {
                Remove-Item -Path $path -Force -Recurse -ErrorAction SilentlyContinue
                Write-Host "  Removed $path" -ForegroundColor DarkGray
            }
        }

        Write-Output "Cleaning up registry..."

        # Remove ms edge from autostart
        reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "MicrosoftEdgeAutoLaunch_A9F6DCE4ABADF4F51CF45CD7129E3C6C" /f *>$null
        reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Microsoft Edge Update" /f *>$null
        reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "MicrosoftEdgeAutoLaunch_A9F6DCE4ABADF4F51CF45CD7129E3C6C" /f *>$null
        reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "Microsoft Edge Update" /f *>$null

        Write-Output "Microsoft Edge was uninstalled"
    }
    else {
        Write-Output ""
        Write-Host "Error: Unable to forcefully uninstall Microsoft Edge, uninstaller could not be found" -ForegroundColor Red
    }
    
    Write-Output ""
}

# Import & execute regfile
function RegImport {
    param (
        $message,
        $path
    )

    Write-Output $message

    if (!$global:Params.ContainsKey("sysprep")) {
        reg import "$PSScriptRoot\imports\$path"
    }
    else {
        $defaultUserPath = $env:USERPROFILE.Replace($env:USERNAME, 'Default\NTUSER.DAT')
        
        reg load "HKU\Default" $defaultUserPath | Out-Null
        reg import "$PSScriptRoot\imports\sysprep\$path"
        reg unload "HKU\Default" | Out-Null
    }

    Write-Output ""
}

# Replace the startmenu for all users, when using the default startmenuTemplate this clears all pinned apps
function ReplaceStartMenuForAllUsers {
    param (
        $startMenuTemplate = "$PSScriptRoot/Start/start2.bin"
    )

    Write-Output "> Removing all pinned apps from the start menu for all users..."

    # Check if template bin file exists, return early if it doesn't
    if (-not (Test-Path $startMenuTemplate)) {
        Write-Host "Error: Unable to clear start menu, start2.bin file missing from script folder" -ForegroundColor Red
        Write-Output ""
        return
    }

    # Get path to start menu file for all users
    $userPathString = $env:USERPROFILE.Replace($env:USERNAME, "*\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState")
    $usersStartMenuPaths = get-childitem -path $userPathString

    # Go through all users and replace the start menu file
    ForEach ($startMenuPath in $usersStartMenuPaths) {
        ReplaceStartMenu "$($startMenuPath.Fullname)\start2.bin" $startMenuTemplate
    }

    # Also replace the start menu file for the default user profile
    $defaultStartMenuPath = $env:USERPROFILE.Replace($env:USERNAME, 'Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState')

    # Create folder if it doesn't exist
    if (-not(Test-Path $defaultStartMenuPath)) {
        new-item $defaultStartMenuPath -ItemType Directory -Force | Out-Null
        Write-Output "Created LocalState folder for default user profile"
    }

    # Copy template to default profile
    Copy-Item -Path $startMenuTemplate -Destination $defaultStartMenuPath -Force
    Write-Output "Replaced start menu for the default user profile"
    Write-Output ""
}

# Replace the startmenu for the current user using the provided template
function ReplaceStartMenu {
    param (
        $startMenuBinFile = "$env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin",
        $startMenuTemplate = "$PSScriptRoot/Start/start2.bin"
    )

    $userName = $startMenuBinFile.Split("\")[2]

    # Check if template bin file exists, return early if it doesn't
    if (-not (Test-Path $startMenuTemplate)) {
        Write-Host "Error: Unable to clear start menu, start2.bin file missing from script folder" -ForegroundColor Red
        return
    }

    # Check if bin file exists, return early if it doesn't
    if (-not (Test-Path $startMenuBinFile)) {
        Write-Host "Error: Unable to clear start menu for user $userName, start2.bin file could not found" -ForegroundColor Red
        return
    }

    $backupBinFile = $startMenuBinFile + ".bak"

    # Backup current start menu file
    Move-Item -Path $startMenuBinFile -Destination $backupBinFile -Force

    # Copy template file
    Copy-Item -Path $startMenuTemplate -Destination $startMenuBinFile -Force

    Write-Output "Replaced start menu for user $userName"
}

# Function to remove apps
function RemoveApps {
    param (
        $appsList
    )

    # Check if winget is installed
    $global:wingetInstalled = Get-Command "winget" -ErrorAction SilentlyContinue
    if ($global:wingetInstalled -eq $null) {
        Write-Host "Warning: WinGet is not installed or outdated, some apps may not be removed." -ForegroundColor Yellow
    }

    Foreach ($app in $appsList) { 
        Write-Output "Attempting to remove $app..."

        if (($app -eq "Microsoft.OneDrive") -or ($app -eq "Microsoft.Edge")) {
            # Use winget to remove OneDrive and Edge
            if ($global:wingetInstalled -eq $null) {
                Write-Host "Error: WinGet is not installed or outdated, $app could not be removed" -ForegroundColor Red
            }
            else {
                # Uninstall app via winget
                Strip-Progress -ScriptBlock { winget uninstall --accept-source-agreements --disable-interactivity --id $app } | Tee-Object -Variable wingetOutput 

                If (($app -eq "Microsoft.Edge") -and (Select-String -InputObject $wingetOutput -Pattern "93")) {
                    Write-Host "Unable to uninstall Microsoft Edge via Winget" -ForegroundColor Red
                    Write-Output ""

                    if ($( Read-Host -Prompt "Would you like to forcefully uninstall Edge? NOT RECOMMENDED! (y/n)" ) -eq 'y') {
                        Write-Output ""
                        ForceRemoveEdge
                    }
                }
            }
        }
        else {
            # Use Remove-AppxPackage to remove other apps
            $app = '*' + $app + '*'

            # Remove installed app for all users
            try {
                Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction Continue
            }
            catch {
                Write-Host "Unable to remove $app for all users" -ForegroundColor Yellow
                Write-Host $psitem.Exception.StackTrace -ForegroundColor Gray
            }

            # Remove provisioned app from OS image
            try {
                Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName }
            }
            catch {
                Write-Host "Unable to remove $app from Windows image" -ForegroundColor Yellow
                Write-Host $psitem.Exception.StackTrace -ForegroundColor Gray
            }
        }
    }

    Write-Output ""
}

# Function to read the JSON config
function ReadConfig {
    param (
        [string]$configPath = "$PSScriptRoot/bw.config.json"
    )
    if (Test-Path $configPath) {
        return Get-Content -Raw -Path $configPath | ConvertFrom-Json
    }
    else {
        Write-Host "Error: Configuration file not found!" -ForegroundColor Red
        Exit
    }
}

# Function to remove apps
function RemoveApps {
    param (
        $appsList
    )

    # Check if winget is installed
    $global:wingetInstalled = Get-Command "winget" -ErrorAction SilentlyContinue
    if ($global:wingetInstalled -eq $null) {
        Write-Host "Warning: WinGet is not installed or outdated, some apps may not be removed." -ForegroundColor Yellow
    }

    Foreach ($app in $appsList) { 
        Write-Output "Attempting to remove $app..."

        if (($app -eq "Microsoft.OneDrive") -or ($app -eq "Microsoft.Edge")) {
            # Use winget to remove OneDrive and Edge
            if ($global:wingetInstalled -eq $null) {
                Write-Host "Error: WinGet is not installed or outdated, $app could not be removed" -ForegroundColor Red
            }
            else {
                # Uninstall app via winget
                Strip-Progress -ScriptBlock { winget uninstall --accept-source-agreements --disable-interactivity --id $app } | Tee-Object -Variable wingetOutput 

                If (($app -eq "Microsoft.Edge") -and (Select-String -InputObject $wingetOutput -Pattern "93")) {
                    Write-Host "Unable to uninstall Microsoft Edge via Winget" -ForegroundColor Red
                    Write-Output ""
                    if ($( Read-Host -Prompt "Would you like to forcefully uninstall Edge? NOT RECOMMENDED! (y/n)" ) -eq 'y') {
                        Write-Output ""
                        ForceRemoveEdge
                    }
                }
            }
        }
        else {
            # Use Remove-AppxPackage to remove all other apps
            $appPattern = '*' + $app + '*'

            # Remove installed app for all existing users
            try {
                if ($WinVersion -ge 22000) {
                    # Windows 11 build 22000 or later
                    Get-AppxPackage -Name $appPattern -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction Continue
                } else {
                    # Windows 10
                    Get-AppxPackage -Name $appPattern | Remove-AppxPackage -ErrorAction SilentlyContinue
                    Get-AppxPackage -Name $appPattern -PackageTypeFilter Main, Bundle, Resource -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                }
            } catch {
                Write-Host "Unable to remove $app for users" -ForegroundColor Yellow
                Write-Host $psitem.Exception.StackTrace -ForegroundColor Gray
            }

            # Remove provisioned app from OS image, so the app won't be installed for any new users
            try {
                Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $appPattern } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName }
            }
            catch {
                Write-Host "Unable to remove $app from windows image" -ForegroundColor Yellow
                Write-Host $psitem.Exception.StackTrace -ForegroundColor Gray
            }
        }
    }
            
    Write-Output ""
}

# Main execution block

# Read the configuration
$config = ReadConfig

# Remove unwanted apps based on config
if ($config.bloatwareRemoval -eq $true) {
    Write-Output "> Removing bloatware apps..."
    RemoveApps -appsList $config.bloatwareApps
}

# Disable Telemetry
if ($config.disableTelemetry -eq $true) {
    RegImport "> Disabling telemetry, diagnostic data, activity history, app-launch tracking, and targeted ads..." "Disable_Telemetry.reg"

    # Disable telemetry-related services and registry settings
    Set-Service -Name "DiagnosticsTrackingService" -StartupType Disabled
    Stop-Service -Name "DiagnosticsTrackingService"

    # Disable telemetry settings in registry
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
}

# Disable Ads
if ($config.disableAds -eq $true) {
    RegImport "> Disabling ads across Windows..." "Disable_Windows_Suggestions.reg"
    # Disable personalized ads
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "DisabledByUser" -Value 1 -Force
}

# Disable Bing (Web Search & Cortana)
if ($config.disableBing -eq $true) {
    RegImport "> Disabling Bing web search, Bing AI & Cortana in Windows search..." "Disable_Bing_Cortana_In_Search.reg"
    # Optionally remove Bing Search app package
    $appsList = 'Microsoft.BingSearch'
    RemoveApps $appsList

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Force
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaEnabled" -Value 0 -Force
}

# Disable Windows Copilot
if ($config.disableCopilot -eq $true) {
    RegImport "> Disabling & removing Windows Copilot..." "Disable_Copilot.reg"
    $appsList = 'Microsoft.Copilot'
    RemoveApps $appsList
}

# Show File Extensions in Explorer
if ($config.showFileExtensions -eq $true) {
    RegImport "> Enabling file extensions for known file types..." "Show_Extensions_For_Known_File_Types.reg"
}

# Hide 3D Objects in Explorer
if ($config.hide3DObjects -eq $true) {
    RegImport "> Hiding the 3D objects folder from the File Explorer navigation pane..." "Hide_3D_Objects_Folder.reg"
}

# Disable Widgets
if ($config.disableWidgets -eq $true) {
    RegImport "> Disabling the widget service and hiding the widget icon from the taskbar..." "Disable_Widgets_Taskbar.reg"
}

# Hide Chat (Taskbar Icon)
if ($config.hideChat -eq $true) {
    RegImport "> Hiding the chat icon from the taskbar..." "Disable_Chat_Taskbar.reg"
}

# Handle Windows Version
if ($config.windowsVersion -eq "windows10") {
    Write-Output "> Configuring for Windows 10..."
    # Add specific configurations for Windows 10 if necessary
}

if ($config.forceRemoveEdge) {
    ForceRemoveEdge
}

if ($config.disableDVR) {
    RegImport "> Disabling Xbox game/screen recording..." "Disable_DVR.reg"
}

if ($config.clearStart) {
    Write-Output "> Removing all pinned apps from the start menu for user $env:USERNAME..."
    ReplaceStartMenu
}

if ($config.clearStartAllUsers) {
    ReplaceStartMenuForAllUsers
}

if ($config.disableLockscreenTips) {
    RegImport "> Disabling tips & tricks on the lockscreen..." "Disable_Lockscreen_Tips.reg"
}

if ($config.disableSuggestions) {
    RegImport "> Disabling tips, tricks, suggestions, and ads across Windows..." "Disable_Windows_Suggestions.reg"
}

if ($config.revertContextMenu) {
    RegImport "> Restoring the old Windows 10 style context menu..." "Disable_Show_More_Options_Context_Menu.reg"
}

if ($config.taskbarAlignLeft) {
    RegImport "> Aligning taskbar buttons to the left..." "Align_Taskbar_Left.reg"
}

if ($config.hideSearchTb) {
    RegImport "> Hiding the search icon from the taskbar..." "Hide_Search_Taskbar.reg"
}

if ($config.showSearchIconTb) {
    RegImport "> Changing taskbar search to icon only..." "Show_Search_Icon.reg"
}

if ($config.showSearchLabelTb) {
    RegImport "> Changing taskbar search to icon with label..." "Show_Search_Icon_And_Label.reg"
}

if ($config.showSearchBoxTb) {
    RegImport "> Changing taskbar search to search box..." "Show_Search_Box.reg"
}

if ($config.hideTaskview) {
    RegImport "> Hiding the taskview button from the taskbar..." "Hide_Taskview_Taskbar.reg"
}

if ($config.disableRecall) {
    RegImport "> Disabling Windows Recall snapshots..." "Disable_AI_Recall.reg"
}

if ($config.hideWidgets) {
    RegImport "> Disabling the widget service and hiding the widget icon from the taskbar..." "Disable_Widgets_Taskbar.reg"
}

if ($config.showHiddenFolders) {
    RegImport "> Unhiding hidden files, folders, and drives..." "Show_Hidden_Folders.reg"
}

if ($config.hideHome) {
    RegImport "> Hiding the home section from the File Explorer navigation pane..." "Hide_Home_from_Explorer.reg"
}

if ($config.hideGallery) {
    RegImport "> Hiding the gallery section from the File Explorer navigation pane..." "Hide_Gallery_from_Explorer.reg"
}

if ($config.hideDupliDrive) {
    RegImport "> Hiding duplicate removable drive entries from the File Explorer navigation pane..." "Hide_duplicate_removable_drives_from_navigation_pane_of_File_Explorer.reg"
}

if ($config.hideOnedrive) {
    RegImport "> Hiding the OneDrive folder from the File Explorer navigation pane..." "Hide_Onedrive_Folder.reg"
}

if ($config.hideMusic) {
    RegImport "> Hiding the music folder from the File Explorer navigation pane..." "Hide_Music_folder.reg"
}

if ($config.hideIncludeInLibrary) {
    RegImport "> Hiding 'Include in library' in the context menu..." "Disable_Include_in_library_from_context_menu.reg"
}

if ($config.hideGiveAccessTo) {
    RegImport "> Hiding 'Give access to' in the context menu..." "Disable_Give_access_to_context_menu.reg"
}

if ($config.hideShare) {
    RegImport "> Hiding 'Share' in the context menu..." "Disable_Share_from_context_menu.reg"
}

# Other actions based on configuration can be added here, such as FPS boost techniques, storage tricks, etc.

if ($config.fpsBoost) {
    Write-Output "> Enabling FPS boost for gaming..."
    Enable-FPSBoost
}

Write-Output ""
Write-Output "Script completed successfully!"
AwaitKeyToExit

# Restart PC if needed
Restart-Computer -Delay 60 -M "Your computer will restart in 1 minute. All changes have been successfully applied."
