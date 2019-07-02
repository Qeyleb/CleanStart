# CleanStart - Qeyleb's Start Menu / Taskbar customizer
# https://github.com/Qeyleb/CleanStart
# Version 0.1 last updated 2019/07/01

# Big thanks and credit to User9752134896231 at https://superuser.com/a/1442733

# WARNING: This will wipe out your Start Menu and Taskbar pins and change the layout.

# Purpose: LayoutModification.xml and Import-StartLayout only work for other user profiles...
# Until now!  This will apply the embedded StartLayout XML to your user profile.
# Great for applying a new standard layout, or clearing the Candy Crush etc junk.

# Note: This won't work if you've got a Group Policy to apply a customized Start Menu.

# Edit this XML as you like.
$startLayout = @"
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
    xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
    xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6">
        <start:Group Name="Create">
          <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!Microsoft.WindowsLive.Mail" />
          <start:Tile Size="2x2" Column="4" Row="2" AppUserModelID="Microsoft.Office.OneNote_8wekyb3d8bbwe!microsoft.onenoteim" />
          <start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!Microsoft.WindowsLive.Calendar" />
          <start:Tile Size="2x2" Column="0" Row="2" AppUserModelID="Microsoft.MSPaint_8wekyb3d8bbwe!Microsoft.MSPaint" />
          <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.WindowsAlarms_8wekyb3d8bbwe!App" />
          <start:Tile Size="2x2" Column="2" Row="2" AppUserModelID="Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App" />
        </start:Group>
        <start:Group Name="Play">
          <start:Tile Size="2x2" Column="0" Row="2" AppUserModelID="Microsoft.ZuneVideo_8wekyb3d8bbwe!Microsoft.ZuneVideo" />
          <start:Tile Size="2x2" Column="2" Row="2" AppUserModelID="Microsoft.ZuneMusic_8wekyb3d8bbwe!Microsoft.ZuneMusic" />
          <start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="Microsoft.XboxApp_8wekyb3d8bbwe!Microsoft.XboxApp" />
          <start:Tile Size="2x2" Column="4" Row="2" AppUserModelID="Microsoft.SkypeApp_kzf8qxf38zg5c!App" />
          <start:Tile Size="4x2" Column="2" Row="0" AppUserModelID="Microsoft.Windows.Photos_8wekyb3d8bbwe!App" />
        </start:Group>
        <start:Group Name="Explore">
          <start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="Microsoft.WindowsStore_8wekyb3d8bbwe!App" />
          <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />
          <start:Tile Size="2x2" Column="0" Row="2" AppUserModelID="Microsoft.WindowsMaps_8wekyb3d8bbwe!App" />
          <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" />
          <start:Tile Size="4x2" Column="2" Row="2" AppUserModelID="Microsoft.BingWeather_8wekyb3d8bbwe!App" />
        </start:Group>
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
  <CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>
        <taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
      </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
  </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@

$layoutFile = "$Env:TEMP\StartLayout.xml"

# Relaunch as administrator if necessary
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Start-Process "$PsHome\powershell.exe" "-NoProfile -ExecutionPolicy Bypass -File `"$($script:MyInvocation.MyCommand.Path)`" `"$args`"" -Verb RunAs; exit
}

# Delete temporary layout file if it already exists
if (Test-Path "$layoutFile") {
    Remove-Item "$layoutFile"
}

# Write the layout to a temporary file
Add-Content "$layoutFile" $startLayout

$regAliases = @("HKLM", "HKCU")

# Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases) {
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    if (-not (Test-Path -Path $keyPath)) { 
        New-Item -Path $basePath -Name "Explorer"
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value "$layoutFile"
}

# Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
Stop-Process -Name explorer
Start-Sleep -s 5
$wshShell = New-Object -ComObject WScript.Shell; $wshShell.SendKeys('^{ESCAPE}')
Start-Sleep -s 5

# Apply LayoutModification for all users
Import-StartLayout -LayoutPath "$layoutFile" -MountPath "$Env:SystemDrive\"

# Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases) {
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}

# Restart Explorer and delete the layout file
Stop-Process -Name explorer
Remove-Item "$layoutFile"