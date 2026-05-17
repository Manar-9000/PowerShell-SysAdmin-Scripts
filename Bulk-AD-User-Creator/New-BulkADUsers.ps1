# ============================================================
# Script: New-BulkADUsers.ps1
# Purpose: Reads a CSV file and creates AD user accounts in bulk
# Run on: Windows Server 2022 Domain Controller (as Administrator)
# ============================================================

# this tells the script where to find the CSV file
$CSVPath = "C:\Scripts\users_template.csv"

# AD uses this format to locate things in the directory
$DomainDN = "DC=manar,DC=local"

# this is the list of all the rows in the csv
$Users = Import-Csv -Path $CSVPath
Write-Host "Found $($Users.Count) users to create..." -ForegroundColor Cyan

# Loops through each row and for each it creates the user accounts
foreach ($User in $Users) {

    # this tells AD which folder/OU to put them in
    $OUPath = "OU=$($User.OU),$DomainDN"

    # AD requires passwords in encrypted format, this converts plain text to SecureString
    $SecurePassword = ConvertTo-SecureString $User.Password -AsPlainText -Force

    # This command is the user creation command in PowerShell
    New-ADUser `
        -GivenName $User.FirstName `
        -Surname $User.LastName `
        -Name "$($User.FirstName) $($User.LastName)" `
        -SamAccountName $User.Username `
        -UserPrincipalName "$($User.Username)@manar.local" `
        -Department $User.Department `
        -Path $OUPath `
        -AccountPassword $SecurePassword `
        -ChangePasswordAtLogon $true `
        -Enabled $true

    Write-Host "Created: $($User.Username) - $($User.FirstName) $($User.LastName)" -ForegroundColor Green
}

Write-Host "`nDone! All users created successfully." -ForegroundColor Cyan
Write-Host "Verify in Active Directory Users and Computers > MANAR_Users OU." -ForegroundColor Cyan
