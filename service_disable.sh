#!/bin/bash
#It really doesn't make any sense as avahi is the linux 
#implementation of Apple's and others company for peer-to-peer communication
sudo systemctl disable avahi-daemon

# rarely used cupsd daemon (common unix printing service)
# running on a free TCP port and silently leeching your
# memory and network resources.
sudo systemctl disable cupsd
sudo systemctl disable cups-browsed

sudo systemctl disable keyboard-setup.service
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily.timer
sudo systemctl disable console-setup.service
#Disable the system log service there is no need for it in this project
sudo systemctl disable syslog.service