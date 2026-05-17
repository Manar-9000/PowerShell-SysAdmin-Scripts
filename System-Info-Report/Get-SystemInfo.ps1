# ============================================================
# Script: Get-SystemInfo.ps1
# Purpose: Collects and displays key system information
# Run on: Any Windows machine (Server or Workstation)
# ===========================================================

#prints a clear header
Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "   System Information Report" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# pulls a large object full of system details from Windows
$SysInfo = Get-ComputerInfo

# filters to get only the active IPv4 address, ignoring loopback
$IPAddress = Get-NetIPAddress | Where-Object {
    $_.AddressFamily -eq "IPv4" -and
    $_.IPAddress -ne "127.0.0.1"
} | Select-Object -ExpandProperty IPAddress

# calculates uptime by subtracting last boot time from right now
$LastBoot = $SysInfo.OsLastBootUpTime
$Uptime = (Get-Date) - $LastBoot

# converts RAM from bytes/kilobytes to gigabytes and rounds to 2 decimals
#correct
$TotalRAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)# correct
$TotalRAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$FreeRAM = [math]::Round($SysInfo.OsFreePhysicalMemory / 1MB, 2)

# displays the full report
Write-Host "`nHostname:       $($SysInfo.CsName)" -ForegroundColor Green
Write-Host "OS:             $($SysInfo.OsName)" -ForegroundColor Green
Write-Host "OS Build:       $($SysInfo.OsBuildNumber)" -ForegroundColor Green
Write-Host "Current User:   $($env:USERNAME)" -ForegroundColor Green
Write-Host "IP Address:     $IPAddress" -ForegroundColor Green
Write-Host "Last Boot:      $LastBoot" -ForegroundColor Green
Write-Host "Uptime:         $($Uptime.Days)d $($Uptime.Hours)h $($Uptime.Minutes)m" -ForegroundColor Green
Write-Host "Total RAM:      $TotalRAM GB" -ForegroundColor Green
Write-Host "Free RAM:       $FreeRAM GB" -ForegroundColor Green
Write-Host "`n=====================================" -ForegroundColor Cyan
