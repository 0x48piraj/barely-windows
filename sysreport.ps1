# Define the log file path relative to the project's location
$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$logFilePath = Join-Path -Path $projectPath -ChildPath "SystemInfo.log"

# Function to log messages to the log file
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $message" | Out-File -Append -FilePath $logFilePath
}

# Clear previous log file
if (Test-Path $logFilePath) {
    Remove-Item $logFilePath
}

# Log Windows version
$WinVersion = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' CurrentBuild
Log-Message "Windows Version: $WinVersion"

# Log OS information
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
Log-Message "OS Name: $($osInfo.Caption)"
Log-Message "OS Architecture: $($osInfo.OSArchitecture)"
Log-Message "OS Version: $($osInfo.Version)"
Log-Message "Build Number: $($osInfo.BuildNumber)"
Log-Message "Install Date: $($osInfo.InstallDate)"

# Log system information
$systemInfo = Get-WmiObject -Class Win32_ComputerSystem
Log-Message "Manufacturer: $($systemInfo.Manufacturer)"
Log-Message "Model: $($systemInfo.Model)"
Log-Message "Total Physical Memory: $([math]::round($systemInfo.TotalPhysicalMemory / 1GB, 2)) GB"
Log-Message "Number of Logical Processors: $($systemInfo.NumberOfLogicalProcessors)"
Log-Message "Number of Physical Processors: $($systemInfo.NumberOfProcessors)"

# Log disk information
$disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
foreach ($disk in $disks) {
    Log-Message "Disk Drive: $($disk.DeviceID) - Free Space: $([math]::round($disk.FreeSpace / 1GB, 2)) GB - Total Size: $([math]::round($disk.Size / 1GB, 2)) GB"
}

# Log network adapter information
$networkAdapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }
foreach ($adapter in $networkAdapters) {
    Log-Message "Network Adapter: $($adapter.Description) - IP Address: $($adapter.IPAddress -join ', ')"
}

# Finish logging
Log-Message "System information logging completed."
