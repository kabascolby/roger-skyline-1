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

## Implementation

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

2. Create a new user account add to a sudoer groups and change current user
   to the new use.r<br>
   avoid running command with root accoutn it's a very bad practice

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
To make the documentation more readable, I wrote some scripts.
all the implementation details are inside those scripts.

### Install all the dependancy

```bash
sudo sh dependancy.sh
```

### Network interface

1. Calculate the Netmask base on Classless inter-domain routing (CIDR) `30`<br>
   the mask will be: 255.255.255.252/30 and default mask will be 255.255.255.0
2. Calculate the static ip address based on the netmask <br>
   based on my calulation only two Ip addresses can be used unless you configure
   a subnet addressing.
3. In virtualbox machine settings you have to change the default `NAT` Network Adapter by `Bridged Adapter`<br>
   I choose that configuration in purpose to be part of the cluster network so they can access to the my webserver
   and also test how robust is my firewall :)
4. Edit the newtowk interface file `/etc/network/interfaces`<br>

> Set the ip and the mask manually
> To edit the network interface I created a script in my repos `network.sh` > `this file has to be executed only once`.

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

### **Setup SSH**

1. First Generate a public/private rsa key pair, on the host machine.

   ```bash
   ssh-keygen -t rsa
   ```

   This command will generate the private key file and the public key file

   - Id_rsa: which is the file who contains the private key
   - Id_rsa.pub: which is the public key to send to the ssh server

2. Copy the SSH public key from the host machine to the server

   ```bash
   ssh-copy-id -i id_rsa.pub lamine@10.113.100.13 -p 1450
   ```

   Enter the user pasword<br>
   The key is automatically added in `~/.ssh/authorized_keys` on the server

   > If you no longer want to have type the key password you can setup a SSH Agent with `ssh-add`

3. Edit the `sshd_config` file `/etc/ssh/sshd.config` to remove root login permit, password authentification

   ```bash
   sudo vim /etc/ssh/sshd.conf
   ```

   > Remove **#** at the beginning of each line

   - Edit line 32 like: `PermitRootLogin no`
   - Edit line 56 like `PasswordAuthentication no`

4. We need to restart the SSH daemon service.

   ```bash
   sudo service sshd restart
   ```

### **iptables configuration**

I choose to use iptable intead of using ufw for this subject.It's better to understand iptables it's
will be usefull in the next project and the requirement for this project is pretty basic there is ton's of tutorials
on youtube who can help to make your hands dirty with iptables and it's worthed.
I've explain each line in the `firewall.sh` script.

1. remove all the firewall rules
2. Setup firewall rules

   > Don't forget to update the SSH port Number in the script in case you choose another port number

   ```bash
   sudo cp firewall.sh /etc/init.d/
   update-rc.d firewall.sh defaults
   ```

#### **Test**

### **Setup fail2Ban**

Setup Denial Of Service Attack with fail2ban.

1. Create a copy of the file `jail.conf` and rename it `jail.conf.local`. <br>
   This will make the ban rules persistent even when the package will be updated
   it will read by default the `jail.conf.local` file.

   ```bash
   sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.local
   sudo vim /etc/fail2ban/jail.conf.local
   ```

2. Edit all the line bellow to set to protect against

   - SSH ddos: this will prevent an attacker to bloc all the users to acces the server through ssh
   - Apache website admin attack: this will preventent a hacker to sniff the website in purpose to find the admin page
   - http-get-dos prevention: Denial of service attacks are meant to load a server to a level where it can't serve the intended users with the service.

   ```console
   #SSH servers
   [sshd]
   enabled = true
   port    = 1450
   logpath = %(sshd_log)s
   backend = %(sshd_backend)s
   maxretry = 3
   bantime = 600

   #Add after HTTP servers:
   [apache-404]
   enabled = true
   port = http
   filter = apache-404
   logpath = /var/log/apache*/error*.log
   maxretry = 5
   bantime = 600

   [http-get-dos]
   enabled = true
   port = http,https
   filter = http-get-dos
   logpath = /var/log/apache2/access.log
   maxretry = 300
   findtime = 300
   bantime = 600
   action = iptables[name=HTTP, port=http, protocol=tcp]

   #ACTIONS
   destemail = kabascolby@gmail.com
   sendername = Fail2BanAlerts
   ```

3. Set the filter

   the scripts bellow will create a \*.conf files wich will be used to check when a hacker try to compromise the server

   ```bash
   sudo sh http-get-dos.sh
   sudo sh apache-404.sh
   ```

### **Protection against port scans**

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

- **Lamine kaba** - _Initial works_ - [kabascolby](https://github.com/kabascolby)

## License

open source

## Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- etc
