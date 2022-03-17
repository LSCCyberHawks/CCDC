# Written by: Bobby Dorman
# Created on: 10/6/2020
# Note: Dear god don't run this on anything production. 
# Purpose: To get a list of users from AD and loop through user accounts to reset password. 

# Get list of users: 
$users = Get-ADUser -filter * -Properties SamAccountName

# Set AD Account Passwords: 
foreach($user in $users)
    {
        Set-ADAccountPassword -Identity $user.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force)
        Write-Host "Password set for: " $user.SamAccountName
    }
