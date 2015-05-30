# -*- mode: yaml -*-

pbuilder-packages:
  pkg.installed:
    - pkgs:
      - pbuilder
      - git-buildpackage
      

pbuilder-main-config:
  file.managed:
    - name: /etc/pbuilderrc
    - source: salt://pbuilder/pbuilderrc
    - template: jinja


