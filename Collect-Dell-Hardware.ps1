# Read-only hardware collector. Run on the Dell, not the desktop preparing this EFI.
$ErrorActionPreference = 'Stop'
$machine = Get-CimInstance Win32_ComputerSystem
if ($machine.Manufacturer -notmatch 'Dell' -or $machine.Model -notmatch '3481') {
    throw "Expected a Dell Inspiron 3481. Detected $($machine.Manufacturer) $($machine.Model). No report written."
}
$reportDir = Join-Path $PSScriptRoot 'Dell-hardware-local'
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
$devices = Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^(PCI|USB|HDAUDIO|ACPI)\\' }
$records = foreach ($device in $devices) {
    $hw = Get-PnpDeviceProperty -InstanceId $device.InstanceId -KeyName 'DEVPKEY_Device_HardwareIds' -ErrorAction SilentlyContinue
    $paths = Get-PnpDeviceProperty -InstanceId $device.InstanceId -KeyName 'DEVPKEY_Device_LocationPaths' -ErrorAction SilentlyContinue
    [pscustomobject]@{ Name = $device.FriendlyName; Class = $device.Class; HardwareIds = $hw.Data; LocationPaths = $paths.Data }
}
[pscustomobject]@{
    Manufacturer = $machine.Manufacturer
    Model = $machine.Model
    CPU = @(Get-CimInstance Win32_Processor | Select-Object Name)
    Storage = @(Get-CimInstance Win32_DiskDrive | Select-Object Model,InterfaceType)
    Devices = @($records)
} | ConvertTo-Json -Depth 8 | Set-Content -Encoding utf8 (Join-Path $reportDir 'hardware.json')
Write-Output "Saved selected hardware details to $reportDir. No EFI, driver or firmware setting was changed."
Write-Output 'Original ACPI and a physical USB port map still need separate collection. Review before sharing.'
