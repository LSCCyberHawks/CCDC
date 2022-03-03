#this is to generate ssl certs

#create a new dir in /opt/splunk/etc/auth and name it mycerts

opt/splunk/bin/splunk cmd openssl genrsa -aes256 -out myCAPrivateKey.key 2048
#create password
/opt/splunk/bin/splunk cmd openssl req -new -key myCAPrivateKey.myCAPrivateKey -out myCACertificate.csr
#provide password from pervious step
/opt/splunk/bin/splunk cmd openssl x509 -req -in myCACertificate.csr -signkey myCAPrivateKey.key -out myCACertificate.pem -days 3650
#enter password when prompted


#gen new priv key for splunk web
/opt/splunk/bin/splunk cmd openssl genrsa -aes256 -out mySplunkWebPrivatekey.key 2048
#create password
/opt/splunk/bin/splunk cmd openssl rsa -in mySplunkWebPrivateKey.key
 -out mySplunkWebPrivateKey.key


#create new server cert + sign
opt/splunk/bin/splunk cmd openssl req -new -key mySplunkWebPrivateKey.key
 -out mySplunkWebCert.csr

opt/splunk/bin/splunk cmd openssl x509 -req -in mySplunkWebCert.csr -CA myCACertificate.pem
-CAkey myCAPrivateKey.key -CAcreateserial -out mySplunkWebCert.pem -days 1095
#enter password when prompted


#combine server cert an dpublic cert into pem file
cat mySplunkWebCert.pem myCACertificate.pem > mySplunkWebCertificate.pem

#
#configure splunk web to use the key and the cert files
#

#open or create a local web.conf configuration file for the Search app in $SPLUNK_HOME/etc/system/local. If you use a deployment server, you can create this file in any application directory that you make available to the deployment server for download to deployment clients.
#under the [settings] stanza, configure the path to the file that contains the web server SSL certificate private key file and the path to the Splunk web server certificate file
#the following example shows an edited settings stanza:

[settings]
enableSplunkWebSSL = true
privKeyPath = /opt/splunk/etc/auth/mycerts/mySplunkWebPrivateKey.key
serverCert = /opt/splunk/etc/auth/mycerts/mySplunkWebCertificate.pem


#save and close the file

opt/splunk/bin/splunk restart splunkd