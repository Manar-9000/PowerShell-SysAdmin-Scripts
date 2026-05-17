# ============================================================
# Script: Get-LockedAccounts.ps1
# Purpose: Finds all locked Active Directory user accounts
# Run on: Windows Server 2022 Domain Controller (as Administrator)
# ============================================================

# prints a clear header so the output is easy to read
Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "   AD Locked Account Checker" -ForegroundColor Cyan
Write-Host "   Domain: manar.local" -ForegroundColor Cyan
Write-Host "=====================================`n" -ForegroundColor Cyan

# searches AD specifically for locked out user accounts only
$LockedUsers = Search-ADAccount -LockedOut -UsersOnly

# if nobody is locked, print good news and stop the script
if ($LockedUsers.Count -eq 0) {
    Write-Host "No locked accounts found. All users are active." -ForegroundColor Green
    Write-Host ""
    exit
}

# if we get here, at least one account is locked — report them
Write-Host "Found $($LockedUsers.Count) locked account(s):`n" -ForegroundColor Yellow

foreach ($User in $LockedUsers) {

    # get detailed info — must request these fields explicitly or they come back empty
    $Details = Get-ADUser -Identity $User.SamAccountName `
        -Properties LockedOut, BadLogonCount, DisplayName

    Write-Host "-------------------------------------" -ForegroundColor Red
    Write-Host "Username:      $($Details.SamAccountName)" -ForegroundColor Red
    Write-Host "Full Name:     $($Details.DisplayName)" -ForegroundColor Red
    Write-Host "Bad Attempts:  $($Details.BadLogonCount)" -ForegroundColor Red
    Write-Host "Locked Out:    $($Details.LockedOut)" -ForegroundColor Red
}

# footer reminding admin how to unlock
Write-Host "-------------------------------------" -ForegroundColor Red
Write-Host "`nTo unlock an account, run:" -ForegroundColor Cyan
Write-Host "Unlock-ADAccount -Identity <username>" -ForegroundColor Yellow
Write-Host ""
