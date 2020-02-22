#!/bin/bash
NAME="laminekaba.com"
EMAIL="kabascolby@gmail.com"
IP=$(hostname -I)

#Create the directory for example.com as follows,
sudo mkdir -p /var/www/$NAME/html && \

#Assign ownership of the directory with the $USER environmental variable
sudo chown -R $USER:$USER /var/www/$NAME/html

#Change the permissions of your web roots folder
sudo chmod -R 755 /var/www/$NAME && \

#Create a sample index.html and insert a html content inside
sudo cp -rf index.html /var/www/$NAME/html/ && \

#Updating the the Hostfile
#sudo echo "$IP   debian $NAME" | sudo tee -a /etc/hosts && \

#Create a virtual host file 
sudo echo "
<VirtualHost *:80>
    ServerAdmin $EMAIL
    ServerName "www.$NAME"
    ServerAlias $NAME
    DocumentRoot /var/www/$NAME/html
	Redirect "/" "https://$IP/"
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/$NAME.conf && \

#Enable the configuration file with the a2ensite tool
sudo a2ensite $NAME.conf && \

#Disable the default site defined in 000-default.conf
sudo a2dissite 000-default.conf

#Test for configuration errors
sudo apache2ctl configtest

#Restart Apache to implement your changes
sudo systemctl restart apache2