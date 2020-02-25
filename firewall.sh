#!/bin/sh
### BEGIN INIT INFO
# Provides:          Firewall roger-skyline1
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:
# Default-Stop:
# X-Interactive:     false
# Short-Description: Firewall roger-skyline1
### END INIT INFO

##Reset all the rules to 0
# Flush all current rules from iptables
iptables -t filter -F
# Flush all the personal rules
iptables -t filter -X
echo "reset with success"
#Setting a rules
iptables -N LKABA-FIREWALL

# Block all the rules (incoming and outgoing)
iptables -t filter -P INPUT ACCEPT
iptables -t filter -P FORWARD ACCEPT
iptables -t filter  -P OUTPUT ACCEPT
echo "Trafics blocked with sucess"

# Setup new chain to avoid writing rules for input and output
iptables -A INPUT -j LKABA-FIREWALL
iptables -A FORWARD -j LKABA-FIREWALL

# Avoid to broked all establish trafics
# Accept packets belonging to established and related connections
iptables -A LKABA-FIREWALL -m state --state ESTABLISHED,RELATED -j ACCEPT

# Autorize loopback # Set access for localhost
iptables -A LKABA-FIREWALL -i lo -j ACCEPT
echo "localhost communication set"

# Block ping
iptables -t filter -A INPUT -p icmp -j DROP
iptables -t filter -A OUTPUT -p icmp -j DROP
#echo "ping disabled"

# Allow SSH connections on tcp port 1450
# This is essential when working on remote servers via SSH to prevent locking yourself out of the system
iptables -A LKABA-FIREWALL -m state --state NEW -m tcp -p tcp --dport 1450 -j ACCEPT
echo "SSH activated"

# Allow web
iptables -A LKABA-FIREWALL -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -A LKABA-FIREWALL -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
echo "http/https port open"

# Reject everything else
iptables -A LKABA-FIREWALL -j REJECT --reject-with icmp-host-prohibited

# Save settings
sudo iptables-save | sudo tee /etc/iptables.conf