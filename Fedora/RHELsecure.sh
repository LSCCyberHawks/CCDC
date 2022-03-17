#!/bin/bash
#Fedora2022CCDC script - RyanKleffman
echo READ ME!! - RUN AS ROOT
echo This is a basic RHEL lockdown script, however based upon what box you are using,
echo you may need to change the firewall ports being opened/closed!
echo NOTE: this uses firewalld due to its flexibility! If you are running IPTABLES, stop the service before running this script
echo LAST!: if you have custom services - splunk etc - add their path to the chattr at the end of this script! keeps red team out with basic user accounts

echo ----------------------------------------------------------------

#Password change. Users with UID over 1000 are usually actual (non system) accounts

echo Edit Passwords


echo changing root password cause security 
echo changing root password cause security >> /var/log/ryanlog.log
passwd root
echo root password is changed

## show all users to double check for /nologin
echo listing all users with UID above 999
cat /etc/passwd | grep '1[0-9][0-9][0-9]'

read -p "Press enter to continue and csetup firewall"

echo ----------------------------------------------------------------

#Firewall
#yum install nano -y
yum install firewalld -y
dnf install firewalld -y

echo Turning on firewalld! Defaulting to drop connections - must add ports to allow connections! - aka edit the script -

	sudo systemctl start firewalld
		echo "Firewall is on"
        echo $(date): firewalld turned on >> /var/log/ryanlog.log
#Setting connections to drop unless allowed
		firewall-cmd --get-default-zone >> /var/log/ryanlog.log # the default zone config, useful incase servers go down
		firewall-cmd --set-default-zone=drop
		firewall-cmd --reload
# Adding Rules
		firewall-cmd --permanent --add-port=25/tcp
		firewall-cmd --permanent --add-port=110/tcp
		firewall-cmd --permanent --add-port=143/tcp
		firewall-cmd --reload
#blocking rules
		echo "Removing SSH (22)"
		firewall-cmd --permanent --remove-service=ssh
		firewall-cmd --permanent --remove-port=22/tcp
		firewall-cmd --permanent --remove-port=22/udp
		echo "Removing cockpit (9090)"
		firewall-cmd --permanent --remove-port=9090/tcp
		firewall-cmd --permanent --remove-port=9090/udp
		echo "Reloading Firewall"
		firewall-cmd --reload
#echo 'Allowing ports 25 (SMTP) 110 (pop3) and 143 (IMAP) to be open'
		firewall-cmd --list-all

echo Make Sure to check for additional ports and services that should not be open!!
read -p "Press enter to continue "

echo ----------------------------------------------------------------
#### NEEDS TESTIGN


# Script for rapid user password changes
# ver.1.0 2/2/22

## this code is commented out, but in here for easy access, it will change all your passwords
#echo This is a mass pass changer! Use at your own risk


echo " Backing up password file incase you fuck up later on!"
mkdir /root/backup
cp /etc/shadow /root/backup/shadow.txt.bac
cp /etc/passwd /root/backup/passwd.txt.bac

echo shadow/passwd backed up to /root/backup/
#echo "Backed up, now Enter new password"
#echo "Enter Password"
#read password

#cat /etc/passwd | cut -d: -f1 /etc/passwd > username.txt
#sed 's/$/:'$password'/' username.txt > chpass.txt
#cat chpass.txt | chpasswd


echo ----------------------------------------------------------------

	
#root only in chron
echo Allowing only root in chron


cd /etc/
/bin/rm -f cron.deny at.deny
echo root >cron.allow
echo root >at.allow
/bin/chown root:root cron.allow at.allow
/bin/chmod 400 cron.allow at.allow
echo done!


## may need to change to httpd due to fedora
##read -p "Press enter to continue "
#echo Setting root:root for apache/apache2 if present
#chown -R root:root /etc/apache2
#chown -R root:root /etc/apache







read -p "Press enter to continue "
echo ----------------------------------------------------------------







echo Getting rid of media 
echo $(date): Logging media >> /var/log/ryanlog.log

	find / -name "*.mp3" -type f >> /var/log/ryanlog.log
	find / -name "*.wav" -type f >> /var/log/ryanlog.log
	find / -name "*.wmv" -type f >> /var/log/ryanlog.log
	find / -name "*.mp4" -type f >> /var/log/ryanlog.log
	find / -name "*.mov" -type f >> /var/log/ryanlog.log
	find / -name "*.avi" -type f >> /var/log/ryanlog.log
	find / -name "*.mpeg" -type f >> /var/log/ryanlog.log
	find /home -name "*.jpeg" -type f >> /var/log/ryanlog.log
	find /home -name "*.jpg" -type f >> /var/log/ryanlog.log
	find /home -name "*.png" -type f >> /var/log/ryanlog.log
	find /home -name "*.gif" -type f >> /var/log/ryanlog.log
	find /home -name "*.tif" -type f >> /var/log/ryanlog.log
	find /home -name "*.tiff" -type f >> /var/log/ryanlog.log
	find / -name "*.mp3" -type f -delete
	find / -name "*.wav" -type f -delete
	find / -name "*.wmv" -type f -delete
	find / -name "*.mp4" -type f -delete
	find / -name "*.mov" -type f -delete
	find / -name "*.avi" -type f -delete
	find / -name "*.mpeg" -type f -delete
	find /home -name "*.jpeg" -type f -delete
	find /home -name "*.jpg" -type f -delete
	find /home -name "*.png" -type f -delete
	find /home -name "*.gif" -type f -delete
	find /home -name "*.tif" -type f -delete
	find /home -name "*.tiff" -type f -delete
echo Media removed

echo ----------------------------------------------------------------

#chattr lock -> last on purpose so things can be configured first
read -p "Press enter to lock files with chattr"

echo using chattr to lock files
echo $(date): using chattr +i to lock files >> /var/log/ryanlog.log
	chattr -R +i /sbin/nologin
	chattr -R +i /etc/sudoers
	chattr -R +i /etc/sudoers.d
	chattr -R +i /etc/shadow
	chattr -R +i /etc/passwd
	chattr -R +i /etc/gpasswd
	chattr -R +i /etc/group
	chattr -R +i /etc/inittab
	chattr -R +i /etc/sshd
	chattr -R +i /etc/ssh
	chattr -R +i /usr/lib/systemd/system/ctrl-alt-del.override
	#Service blocking - could cause issues?
	chattr -R +i /etc/dovecot
	chattr -R +i /etc/postfix
read -p "Press enter to  finish"

echo '### Computer (somewhat) Secured ###'




#echo installing tools
# note, may not need for actual comp
#read -p "Press enter to install RKhunter - it will auto run a scan"

	#dnf install rkhunter -y

	#rkhunter –propupd
	#rkhunter -update

	#rkhunter --check

	#echo 'results logged at /var/log/rkhunter/rkhunter.log'
	
	#finish up - uhhhm add stuff - find a way to make only root have access/check sudoers file etc
