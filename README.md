# vagrant-cowpoke




requires:

host support:

Use debian/jessie amd64 desktop. Install and configure:

- bind9
- isc-dhcp-server
- apt-cacher-ng
- uml-utilities


for building basebox:

- virtualbox
- vagrant
- genisoimage
- p7zip-full

for these scripts:

- python-yaml
- python-mako



Install uml-utilities and add user to uml-net group.

Create a tap interface named maintap
```
auto maintap
iface maintap inet static
    address 10.0.4.1
    netmask 255.255.255.0
	tunctl_user uml-net
```


Use vagrant, apt-cacher-ng, and pbuilder to create debian packages

vagrantfile sets natnet to 10.0.3.0/24
vm ip is 10.0.3.15
vm gw is 10.0.3.2
acng proxy is http://10.0.3.2:3142/

build base box from https://github.com/umeboshi2/vagrant-debian-jessie-64

create buildbase box


use vagrant-vbox-snapshot

apt-get instal zlib1g-dev

vagrant plugin install vagrant-vbox-snapshot




