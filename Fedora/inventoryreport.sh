# need 
echo ---------------------------------------------------- >> inventory.txt
#System Name
echo SYSTEM NAME: >> inventory.txt
echo HOSTNAME: >> inventory.txt
hostname >> inventory.txt
#Purpose
echo ------------- >> inventory.txt
echo Enter your machines purpose:
read PURPOSE
echo PURPOSE >> inventory.txt
echo 'MACHINE PURPOSE'
echo $PURPOSE >> inventory.txt

echo ------------- >> inventory.txt
#OS and Version
echo OS RELEASE >> inventory.txt
cat /etc/os-release | grep 'NAME\|ID\|VERSION' >> inventory.txt
#IP adresses
echo ------------- >> inventory.txt
echo Grabbing IPADDRESS...
echo IP ADDRESS >> inventory.txt
ifconfig | grep inet >> inventory.txt

#Critical Applications
echo ------------- >> inventory.txt
echo Enter your critical Applications:
echo CRITICAL APPLICATIONS: >> inventory.txt
read CRITAPP
echo $CRITAPP >> inventory.txt

#List of admin/user/service accounts
echo ------------- >> inventory.txt
echo ACCOUNTS >> inventory.txt
cat /etc/passwd | grep [0-9][0-9][0-9] >> inventory.txt


#List of services running 
#systemctl | grep service >> inventory.txt
#List of open ports
echo ------------- >> inventory.txt
echo OPEN/LISTENING PORTS!! >> inventory.txt
sudo lsof -i -P -n | grep LISTEN >> inventory.txt
echo -------------------------------------------------------- >> inventory.txt
echo saved in inventory.txt