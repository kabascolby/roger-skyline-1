#!/bin/bash

#Boot to non Graphical user  NOn-GUI
systemctl set-default multi-user.target && \

#update packages
apt-get update -y && apt-get upgrade -y

# Project dependancy
sudo apt-get install vim portsentry fail2ban apache2 mailutils -y

#install dns-utils like ifconfig
sudo apt-get install dnsutils && \

#install network utils
apt-get install net-tools
