#!/bin/sh

set -eu

username=$1
password=$2

echo "INFO: create user '$username'"
adduser --disabled-password --gecos "" $username

echo "INFO: set user password"
echo $username:$password | chpasswd

# Default groups for users are defined in different places:
#
# Defaults used by the debian installer:
# * https://salsa.debian.org/installer-team/user-setup/-/blob/master/debian/user-setup-udeb.templates
# * last modification: 2014, in commit bec0786b
# * -> audio cdrom dip floppy video plugdev netdev scanner bluetooth debian-tor lpadmin
#
# Defaults used by adduser (if option --add_extra_groups):
# * https://salsa.debian.org/debian/adduser/-/blob/master/adduser.conf
# * last modification: 2009, in commit bbc63fe0
# * -> dialout cdrom floppy audio video plugdev users
#
# We want to mimic the debian installer here, so be it.

default_groups="audio cdrom dip floppy video plugdev netdev scanner bluetooth debian-tor lpadmin"
echo "INFO: add user to default groups '$default_groups'"
for group in $default_groups; do
    adduser "$username" $group >/dev/null 2>&1 || :
done
