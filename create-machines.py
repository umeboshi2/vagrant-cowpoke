#!/usr/bin/env python
import os, sys
import subprocess
import yaml
from mako.template import Template

config = yaml.load(file('config.yaml'))
if os.path.isfile('config.yaml.local'):
    lconfig = yaml.load(file('config.yaml.local'))
    config.update(lconfig)
    
basebox_repo_url = 'https://github.com/umeboshi2/vagrant-debian-jessie-64.git'

def list_vagrant_boxes():
    cmd = ['vagrant', 'box', 'list']
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    proc.wait()
    if proc.returncode:
        spcmd = ' '.join(cmd)
        msg = "%s returned %d" % (spcmd, proc.returncode)
        raise RuntimeError, msg
    boxes = [l.split()[0].strip() for l in proc.stdout \
             if 'virtualbox' in l.split()[1]]
    return boxes


def build_basebox():
    basedir = os.getcwd()
    if not os.path.isdir('basebox'):
        url = config['main']['basebox_repo_url']
        cmd = ['git', 'clone', url, 'basebox']
        subprocess.check_call(cmd)
    os.chdir('basebox')
    if not os.path.isfile('debian-jessie.box'):
        subprocess.check_call(['./build.sh']) 
        if not os.path.isfile('debian-jessie.box'):
            raise RuntimeError, "build.sh failed to create box"
    print "debian-jessie.box is present"
    cmd = ['vagrant', 'box', 'add', 'debian-jessie', 'debian-jessie.box']
    subprocess.check_call(cmd)

def create_base_builder():
    # make local config for pillar
    filename = 'salt/pillar/local-config.sls'
    cdump = yaml.dump(config, default_flow_style=False)
    with file(filename, 'w') as outfile:
        outfile.write('# -*- mode: yaml -*-\n')
        outfile.write(cdump)
    if os.path.isfile('package.box'):
        print "removing package.box"
        os.remove('package.box')
    template = Template(filename='vfile-buildbase.mako')
    filename = 'vagrantfile-buildbase'
    if os.path.isfile(filename):
        os.remove(filename)
    with file(filename, 'w') as outfile:
        outfile.write(template.render(config=config))
    os.environ['VAGRANT_VAGRANTFILE'] = filename
    cmd = ['vagrant', 'up']
    subprocess.check_call(cmd)
    cmd = ['vagrant', 'package']
    subprocess.check_call(cmd)
    cmd = ['vagrant', 'box', 'add', 'buildbase', 'package.box']
    subprocess.check_call(cmd)
    if os.path.isfile('package.box'):
        os.remove('package.box')
    if 'buildbase' not in list_vagrant_boxes():
        raise RuntimeError, "Buildbase not in vagrant boxes"
    cmd = ['vagrant', 'destroy', '-f']
    subprocess.check_call(cmd)
    if os.path.isfile(filename):
        os.remove(filename)
    del os.environ['VAGRANT_VAGRANTFILE']
    
        

    

    


if __name__ == '__main__':
    basebox = 'debian-jessie'
    buildbase = 'buildbase'
    if basebox not in list_vagrant_boxes():
        build_basebox()
    else:
        print "base box %s present." % basebox
    if buildbase not in list_vagrant_boxes():
        create_base_builder()
    else:
        print "base build box %s present." % buildbase

    
