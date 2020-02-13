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
GW=$(sudo ip route show | grep default | awk '{ print $3}') && \
NI=$(sudo ip route show | grep –m1 default | awk '{print $5}') && \ 

# The primary network interface
allow-hotplug eth0
iface eth0 inet static
  address 192.168.1.2\
  netmask 255.255.255.252\
  gateway $GW\
  dns-nameservers 8.8.8.8 4.4.2.2" > /etc/network/interfaces && \
ifup $NI
