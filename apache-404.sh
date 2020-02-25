#!/bin/sh

sudo echo "# Fail2Ban configuration file
#
# Author: Cyril Jaquier
#
#

[Definition]

# Option: failregex
# Notes.: regex to match the password failure messages in the logfile. The
# host must be matched by a group named "host". The tag "" can
# be used for standard IP/hostname matching.
# Values: TEXT
# [client x.x.x.x] File does not exist: /home/www/admin/admin,
failregex = [[]client []] File does not exist: .*
#
# Option: ignoreregex
# Notes.: regex to ignore. If this regex matches, the line is ignored.
# Values: TEXT
#
ignoreregex =" > /etc/fail2ban/filter.d/apache-404.conf