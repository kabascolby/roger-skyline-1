#!/bin/bash

#creating environment variable
NAME="laminekaba.com"
EMAIL="kabascolby@gmail.com"
IP=$(hostname -I)

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048\
	-subj "/C=US/ST=CA/L=Fremont/O=42/OU=roger-skyline/CN=$IP"\
	-keyout /etc/ssl/private/$NAME.key\
	-out /etc/ssl/certs/$NAME.crt

sudo echo "<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin $EMAIL
		ServerName	$IP

		DocumentRoot /var/www/$NAME/html

		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		SSLEngine on

		SSLCertificateFile	/etc/ssl/certs/$NAME.crt
		SSLCertificateKeyFile /etc/ssl/private/$NAME.key

		<FilesMatch "\.(cgi|shtml|phtml|php)$">
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>

	</VirtualHost>
</IfModule>
" > /etc/apache2/sites-available/default-ssl.conf && \

#Enable mod_ssl, the Apache SSL module
sudo a2enmod ssl && \

#Enable mod_headers, which is needed by some of the settings in our SSL snippet,
sudo a2enmod headers && \

#Enable your SSL Virtual Host with the a2ensite command
sudo a2ensite default-ssl && \

#Enable your ssl-params.conf file, to read in the values you’ve set
sudo a2enconf ssl-params && \

#Test if everything is OK
sudo apache2ctl configtest && \

#Restart apache server
sudo systemctl restart apache2