#!/bin/bash

#saving the default Gateway address
GW=$(sudo ip route show | grep default | awk '{ print $3}') && \
NI=$(sudo arp –n | grep ether | awk '{print $5}') && \ 
#updating the network interface address
sudo echo "# The primary network interface\n
auto $NI \n
iface $NI inet static\n
address 192.168.1.2\n
netmask 255.255.255.252\n
gateway $GW\n" >> /etc/network/interfaces && \
sudo service networking restart
