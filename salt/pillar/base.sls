# -*- mode: yaml -*-

#apt:
#  configs:
#    02proxy:
#      content: |
#        Acquire::http { Proxy "http://10.0.3.2:3142"; };
#        
sshd_config:
  PermitRootLogin: 'yes'
  PermitEmptyPasswords: 'yes'
  

debootstrap:
  http_proxy: http://10.0.3.2:3142/
  basedir: /srv/chroots
  no_chroots:
    jessie:
      directory: /srv/chroots/jessie
      vendor: debian
      dist: jessie
      arch: amd64
      components:
        - main
        - contrib
        - non-free
    jessie32:
      directory: /srv/chroots/jessie32
      vendor: debian
      dist: jessie
      arch: i386
      components:
        - main
        - contrib
        - non-free

schroot:
  basedir: /srv/chroots
  schroot.conf:
    profile: default
    groups: staff
    root-groups: staff
    
                