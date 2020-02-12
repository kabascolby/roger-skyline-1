#!/bin/bash

#saving the default Gateway address
GW=$(sudo ip route show | grep default | awk '{ print $3}') && \
NI=$(sudo arp –n | grep ether | awk '{print $5}') && \
remove all the address 
Sudo ip address flush $NI && \
#stoping and disable the network daemon the services
sudo systemctl stop NetworkManager.service && \
sudo systemctl disable NetworkManager.service  && \
#updating the network interface address
sudo echo "# The primary network interface
auto $NI
iface $NI inet static
address 192.168.1.2
netmask 255.255.255.252
gateway $GW
#End" >> /etc/network/interfaces && \
sudo service networking restart