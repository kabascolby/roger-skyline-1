#!/bin/bash

#saving the default Gateway address
GW=$(sudo ip route show | grep default | awk '{ print $3}') && \

#saving the network interface Name (ex: en0 or eth1)
NI=$(sudo arp | grep ether | awk '{print $5}') && \

#remove all the address 
sudo ip address flush $NI && \

#stoping and disable the network daemon service
sudo systemctl stop NetworkManager.service && \
sudo systemctl disable NetworkManager.service  && \

#appending the static address to the network interface file
sudo echo "
#The primary network interface
allow-hotplug $NI
iface $NI inet static
	address 192.168.252.2
	netmask 255.255.255.252
	gateway $GW" >> /etc/network/interfaces && \

#restarting the network service
sudo service networking restart && \

#bring a network interface up with the statics values above
sudo ifup $NI