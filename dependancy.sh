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
apt install net-tools && \
#saving the default Gateway address
GW=$(ip route show | grep default | awk '{ print $3}') && \
#updating the network interface address
sudo echo "auto enp0s3 \
  iface enp0s3 inet static\
  address 192.168.1.2\
  netmask 255.255.255.252\
  gateway $GW\
  dns-nameservers 8.8.8.8 4.4.2.2" > /etc/network/interfaces 