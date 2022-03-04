#Fedora2022CCDC script - RyanKleffman

echo ----------------------------------------------------------------

#Password change. Users with UID over 1000 are usually actual (non system) accounts

echo Edit Passwords


echo changing root password cause security bro
echo changing root password cause security bro >> /var/log/ryanlog.log
passwd root
echo root password is changed

## show all users to double check for /nologin
echo listing all users with UID above 999
cat /etc/passwd | grep '1[0-9][0-9][0-9]'

read -p "Press enter to continue"

echo ----------------------------------------------------------------

#Firewall
echo Turning on firewalld NOTE! Firewall will be turned on, but ports 
echo to be configured still!!
	sudo systemctl start firewalld
		echo "Firewall is on"
        echo $(date): firewalld turned on >> /var/log/ryanlog.log
#echo 'Allowing ports 25 (SMTP) 110 (pop3) and 143 (IMAP) to be open'
echo Make Sure to check for additional ports and services that should not be open!!

echo ----------------------------------------------------------------

read -p "Press enter to continue "


	
#root only in chron
echo Allowing only root in chron


cd /etc/
/bin/rm -f cron.deny at.deny
echo root >cron.allow
echo root >at.allow
/bin/chown root:root cron.allow at.allow
/bin/chmod 400 cron.allow at.allow
echo 

echo ----------------------------------------------------------------

read -p "Press enter to continue "
echo Setting root:root for apache/apache2 if present
chown -R root:root /etc/apache2
chown -R root:root /etc/apache

read -p "Press enter to continue "
echo ----------------------------------------------------------------

echo 'securing apache 2'

#Secure Apache 2
if [ -e /etc/apache2/apache2.conf ]; then
	echo \<Directory \> >> /etc/apache2/apache2.conf
	echo -e ' \t AllowOverride None' >> /etc/apache2/apache2.conf
	echo -e ' \t Order Deny,Allow' >> /etc/apache2/apache2.conf
	echo -e ' \t Deny from all' >> /etc/apache2/apache2.conf
	echo \<Directory \/\> >> /etc/apache2/apache2.conf
	echo UserDir disabled root >> /etc/apache2/apache2.conf
	echo $(date): Apache security measures enabled >> /var/log/mikescript.log
fi
read -p "Press enter to Secure SSh"
	
echo ----------------------------------------------------------------

echo Configuring SSH if present
#SSH config
cat /etc/ssh/sshd_config | grep PermitRootLogin | grep yes
if [ $?==0 ]; then
                sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
               	echo $(date): PermitRootLogin rule detected in SSH >> /var/log/ryanlog.log
           	


fi
cat /etc/ssh/sshd_config | grep Protocol | grep 1
if [ $?==0 ]; then
                sed -i 's/Protocol 2,1/Protocol 2/g' /etc/ssh/sshd_config
                sed -i 's/Protocol 1,2/Protocol 2/g' /etc/ssh/sshd_config
               	echo $(date): Protocol rule detected in SSH >> /var/log/ryanlog.log
        	


fi
grep X11Forwarding /etc/ssh/sshd_config | grep yes
if [ $?==0 ]; then
                sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config
               	echo $(date): X11Forwarding rule detected in SSH >> /var/log/ryanlog.log
     	        


fi

read -p "Press enter to continue "
echo ----------------------------------------------------------------

echo Requiring password for sudoers file
#sudiers file require a password
grep PermitEmptyPasswords /etc/ssh/sshd_config | grep yes
if [ $?==0 ]; then
                sed -i 's/PermitEmptyPasswords yes/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
               	echo $(date): PermitEmptyPasswords rule detected in SSH >> /var/log/mikescript.log
     	        #msg=$(echo PermitEmptyPasswords rule changed to no | sed 's/\//%2F/g' | sed 's/\./%2E/g' | sed 's/\ /%20/g'  )

fi
grep NOPASSWD /etc/sudoers
if [ $?==0 ]; then
               tits=$(grep NOPASSWD /etc/sudoers)
		sed -i 's/$tits/ /g' /etc/sudoers
		echo $(date): NOPASSWD rule detected >> /var/log/mikescript.log
     	        #msg=$(echo SUDOERS NOPASSWD rule removed | sed 's/\//%2F/g' | sed 's/\./%2E/g' | sed 's/\ /%20/g'  )


fi

     	        #msg=$(echo Removed any sudoers.d rules other than cyberpatriot | sed 's/\//%2F/g' | sed 's/\./%2E/g' | sed 's/\ /%20/g'  )

		
read -p "Press enter to continue "
echo ----------------------------------------------------------------


#CTRLALTDEL disable - CTRLALTDEL restarts the system on linux
echo 'Disabling CTRL ALT DELETE - ITS BROOOOOKEN'

#sed '/^exec/ c\exec false' /etc/init/control-alt-delete.conf 
		#/usr/lib/systemd/system/ctrl-alt-del.target
echo "exec true" >> /usr/lib/systemd/system/ctrl-alt-del.override
# /etc/init/control-alt-delete.override
echo ctrl alt del disabled

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
echo media removed

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
	chattr -R +i /etc/sshd
	chattr -R +i /usr/lib/systemd/system/ctrl-alt-del.override
read -p "Press enter to continue "



#echo installing tools
# note, may not need for actual comp
#read -p "Press enter to install RKhunter - it will auto run a scan"

	#dnf install rkhunter -y

	#rkhunter –propupd
	#rkhunter -update

	#rkhunter --check

	#echo 'results logged at /var/log/rkhunter/rkhunter.log'
	
	#finish up - uhhhm add stuff - find a way to make only root have access/check sudoers file etc
