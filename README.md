# Roger Skyline 1

I love Linux

## About

After learning some basics commands and scripting in network administration
from the first project `Init`.
This project will help us to implement some practical case to:

- Install a Virtual Machine;
- Implement a static ip;
- Create a SSH token with access restriction;
- Configure a firewall;
- Create a web server.
- Schedule a task
- Deploy the server

### Prerequisites

Hypervisor of your choice

```text
Virtual Box, Hyper-v, VMWare...
```

- A disk size of 8 GB.
- Have at least one 4.2 GB partition.

Download a Linux OS image of your choice and install it in your hypervisor.
(Debian, Jessie, CentOS 7...)

### Implementation

This project in my case will be implemented with Debian 9 some command might
be slightly different based on the linux version you choose.
I added some extra packages in the dependancy script to cover some

Run your virtual machine with preference to use non graphical mode or
if you are in graphical mode open a terminal.

### Create and configure SUDO user

1. You have to login as root with a command `su` and insert your `password`

```bash
su
```

2.Create a new user account add to a sudoer groups and change current user<br>
to the new user
avoid running code as a root it's a very bad practice

```bash
adduser "Your username"
usermod -aG sudo "Your username"
su - "username"
```

3. Pull the script folder from my repo<br>
   I try to comments most part of the scripts
   change the execution permission to the scripts

```bash
sudo apt-get update
sudo apt-get install git
git clone https://github.com/kabascolby/roger-skyline-1.git
cd roger-skyline-1
chmod +x *.sh
```

Some implementation might not be a standard because the requirements
from subject for more details:
To make the documentation easy to read, I created some scripts files.
all the implementation details are inside those scripts.

### Install all the dependancy

```bash
sudo sh dependancy.sh
```

### Network interface

We have to:

1. Calculate the Netmask base on Classless inter-domain routing (CIDR) 30<br>
   the mask will be: 255.255.255.252/30 and default mask will be 255.255.255.0
2. Calculate the static ip address based on the netmask <br>
   based on my calulation only two Ip addresses can be used unless you configure
   a subnet addressing.
3. In virtualbox machine settings you have to change the default `NAT` Network Adapter by `Bridged Adapter`<br>
   I choose that configuration in purpose to be part of the cluster network so they can access to the my webserver
   and also test how robust is my firewall :)
4. Edit the newtowk interface file `/etc/network/interfaces`<br>

- Set the ip and the mask manually
  To edit the network interface I created a script in my repos `network.sh`
  `this file has to be executed only once`.

```bash
sudo sh network.sh
```

#### Test

```bash
sudo ip address
```

```console
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.113.100.13  netmask 255.255.255.252  broadcast 10.113.100.15
        inet6 fe80::a00:27ff:fe77:e815  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:77:e8:15  txqueuelen 1000  (Ethernet)
        RX packets 3099  bytes 566864 (553.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1078  bytes 153983 (150.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2  bytes 78 (78.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
```

### iptables configuration

I choose to use iptable
extra
sudo cp -f firewall /etc/init.d/
update-rc.d

### fail2Ban

Setup Denial Of Service Attack with fail2ban

```bash
sudo vim etc/fail2ban/jail.conf.local
```

```console
[sshd]
enabled = true
port    = 42
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 3
bantime = 600

#Add after HTTP servers:
[http-get-dos]
enabled = true
port = http,https
filter = http-get-dos
logpath = /var/log/apache2/access.log
maxretry = 300
findtime = 300
bantime = 600
action = iptables[name=HTTP, port=http, protocol=tcp]
```

Add http-get-dos filter

```bash
sudo cat /etc/fail2ban/filter.d/http-get-dos.conf
```

Output:

```console
[Definition]
failregex = ^<HOST> -.*"(GET|POST).*
ignoreregex =
```

### Protection against port scans

1. Config portsentry

First, we have to edit the `/etc/default/portsentry` file

```console
TCP_MODE="atcp"
UDP_MODE="audp"
```

After, edit the file `/etc/portsentry/portsentry.conf`

```console
BLOCK_UDP="1"
BLOCK_TCP="1"
```

Comment the current KILL_ROUTE and uncomment the following one:

```console
KILL_ROUTE="/sbin/iptables -I INPUT -s $TARGET$ -j DROP"
```

Comment the following line:

```console
KILL_HOSTS_DENY="ALL: $TARGET$ : DENY
```

2. We can now restart the service to make changes effectives

```bash
sudo service portsentry restart
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

- C programing language
- Makefile to genrate the executable

## Authors

- **Lamine kaba** - _Initial work_ - [kabascolby](https://github.com/kabascolby)

## License

open source

## Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- etc
