#!/bin/bash
echo "make-salt-minion-config.sh started"
echo pwd
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
