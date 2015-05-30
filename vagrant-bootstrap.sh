#!/bin/bash

if [ -x /usr/bin/salt-minion ]; then
    echo "Salt Minion already installed, skipping....."
    exit 0
fi


key_url=http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key
key_fingerprint="102E 2FE7 D514 1DBD 12B2  60FC B09E 40B0 F2AE 6AB9"

if ! apt-key --keyring /etc/apt/trusted.gpg finger | grep "$key_fingerprint"; then
    wget -O - $key_url | apt-key add -
fi

if ! [ -f /etc/apt/sources.list.d/salt.list ]; then
    echo "adding sources list for salt"
    echo "deb http://debian.saltstack.com/debian wheezy-saltstack main" \
	> /etc/apt/sources.list.d/salt.list
fi

apt-get -y update
apt-get -y install salt-minion

if [ -d /etc/salt ]; then
    if [ -d /etc/salt.orig ]; then
	echo "removing /etc/salt"
	rm -rf /etc/salt
    else
	echo "moving config to /etc/salt.orig"
	mv /etc/salt /etc/salt.orig
    fi
fi


echo "Finished with vagrant bootstrap."

echo "Starting to do it"
dpkg-reconfigure salt-common salt-minion

echo "make-salt-minion-config.sh started"
pwd
echo "====================================="
ls /etc/salt
ls /etc/salt
mkdir /etc/salt


cat /etc/hostname
echo "hostname should be above"
whoami
echo whoami
sync
echo "sync one finished"

cat <<EOF > /etc/salt/minion
# -*- mode: yaml -*-
# Paella masterless salt minion set-up
master: localhost
id: builder
renderer: yaml_jinja

file_client: local
fileserver_backend:
  - roots
  
file_roots:
  base:
    - /vagrant/repos/formulae
    - /vagrant/repos/paella-states
    - /vagrant/salt/states

pillar_roots:
  base:
    - /vagrant/salt/pillar


EOF

sync
echo "sync two finished"

echo salt/minion setup
echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


sudo service salt-minion restart

sudo salt-call test.ping
echo "pinged"
sudo salt-call state.highstate -l debug 2>&1 | tee /vagrant/plog
