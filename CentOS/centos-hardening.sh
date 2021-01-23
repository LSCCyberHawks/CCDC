#!/bin/sh

#CentOS 6.0 Hardening Script - Created by Cameron Birkland

clear

echo "CentOS 6 Hardening Script"
echo "NOTE: This script must be ran with root priveliges!"
echo " "
echo "Ensure repositories are up and working before running this script!"

sleep 10
clear

echo "Disabling Networking..."

ifdown eth0

echo " "
sleep 0.5

echo "Adding New User..."

adduser bobj
passwd bobj

echo " "
sleep 0.5

echo "Changing Root Password..."

passwd

echo " "
sleep 0.5

echo "Chattr Locking Files..."

chattr +i /etc/passwd
chattr +i /etc/shadow

echo " "
sleep 0.5

echo "Disabling SSH..."

chkconfig sshd off
service sshd stop
echo " "
echo "Change PermitRootLogin no!"
echo "Opening /etc/ssh/sshd_config..."
sleep 5
vi /etc/ssh/sshd_config

echo " "
sleep 0.5

echo "Configuring Networking..."
echo " "
echo "NOTE: Check IP Address, netmask, gateway, and DNS"

vi /etc/sysconfig/network-scripts/ifcfg-eth0

echo "Enabling Networking..."

ifup eth0

echo " "
sleep 0.5

echo "Updating Repositories..."

yum update
yum --enablerepo=extras install epel-release

echo " "
sleep 0.5
clear

echo "Installing nano..."

yum install nano

sleep 0.5
clear

echo "Installing ufw..."

yum install ufw

echo " "
sleep 0.5

echo "Configuring ufw..."

ufw enable
ufw allow 80
ufw allow 443

echo " "
sleep 0.5

echo "Installing fail2ban..."

yum install fail2ban

echo " "
sleep 0.5

echo "Configuring fail2ban..."

echo " "
sleep 0.5

echo "Change logtarget = SYSLOG to logtarget = /var/log/fail2ban/log"
echo "Opening /etc/fail2ban/fail2ban.conf in 7 seconds..."
sleep 7
vi /etc/fail2ban/fail2ban.conf

echo "	Copying jail.conf..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sleep 0.5

echo "	Creating joomla Definition..."
echo "[Definition]
failregex = ^.*INFO <HOST> .*joomlafailure.*(Benutzername|Username).*" > /etc/fail2ban/filter.d/joomla-login-errors.conf
sleep 0.5

echo "[joomla-login-errors]
enabled = true
filter = joomla-login-errors
port   = http,https
logpath = /var/www/*/tmp/error.php
          /var/www/*/htdocs/tmp/error.php
          /var/www/*/htdocs/logs/error.php
          /var/www/*/apps/*/error.php" > /etc/fail2ban/jail.d/joomla-login-errors.conf
# NOTE: LOGPATHS MAY NEED TO BE MODIFIED
sleep 0.5

echo "USER INTERVENTION REQUIRED!: increase bantime to 36000, enable apache jails if necessary"
echo "Opening /etc/fail2ban/jail.local in 7 seconds..."
sleep 7

vi /etc/fail2ban/jail.local
service fail2ban restart

echo " "
sleep 0.5

echo "Installing ClamAV..."

yum install clamav clamd
echo "Configuring ClamAV..."
/etc/init.d/clamd start
/usr/bin/freshclam
setsebool -P antivirus_can_scan_system 1

echo " "
sleep 0.5

echo "Installing RKHunter..."

yum install rkhunter
rkhunter update

echo " "
sleep 0.5

echo "Configuring NTP..."

yum install ntp ntpdate ntp-doc

chkconfig ntpd on
ntpdate 172.20.241.254
/etc/init.d/ntpd start

echo "Performing \"yum upgrade\"..."

yum upgrade

echo "Done!"

sleep 4
