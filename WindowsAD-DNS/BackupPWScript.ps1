# First need to create a userlist.txt file in c:\temp\ with all usernames that you
#  want to reset password for.  Can export from GUI or use PS Get-AdUser Command and copy paste
# Exporting users with PS: Get-ADUser -Filter 'Company -like "<enterName>"' -Properties * | Select -Property SamAccountName | Export-CSV "C:\\users.csv" -NoTypeInformation -Encoding UTF8
# Convert csv to Txt
# Import ActiveDirectory module
 Import-module ActiveDirectory
# Grab list of users from a text file.
 $ListOfUsers = Get-Content C:\Temp\userlist.txt
 foreach ($user in $ListOfUsers) {
     #Generate a 15-character random password.
     $Password = -join ((33..126) | Get-Random -Count 15 | ForEach-Object { [char]$_ })
     #Convert the password to secure string.
     $NewPwd = ConvertTo-SecureString $Password -AsPlainText -Force
     #Assign the new password to the user.
     Set-ADAccountPassword $user -NewPassword $NewPwd -Reset
     #Force user to change password at next logon.
     Set-ADUser -Identity $user -ChangePasswordAtLogon $true
     #Display userid and new password on the console.
     Write-Host $user, $Password
 }