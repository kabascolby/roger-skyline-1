#!/bin/bash

#Boot to non Graphical user  NOn-GUI
systemctl set-default multi-user.target && \

#add Current user to sudoer group
usermod -aG sudo $USER && \

#update packages
apt Update

#install dns-utils
apt install dnsutils && \

#install network utils
apt install net-tools
