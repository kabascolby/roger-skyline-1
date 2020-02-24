#!/bin/sh

sudo echo \
"# Fail2Ban configuration file
#
# Author: http://www.go2linux.org
#
[Definition]

# Option: failregex
# Note: This regex will match any GET entry in your logs, so basically all valid and not valid entries are a match.
# You should set up in the jail.conf file, the maxretry and findtime carefully in order to avoid false positives.

failregex = ^ -.*GET

# Option: ignoreregex
# Notes.: regex to ignore. If this regex matches, the line is ignored.
# Values: TEXT
#
ignoreregex =" > /etc/fail2ban/filter.d/http-get-dos.conf