# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # This box is built from:
  # https://github.com/umeboshi2/vagrant-debian-jessie-64
  config.vm.box = "${config['basebox_name']}"

  config.vm.hostname = "${config['basebuilder_name']}"
  
  config.vm.network :public_network, :bridge => "maintap"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "${config['vm']['num_cpus']}"]
    vb.customize ["modifyvm", :id, "--memory", "${config['vm']['memory']}"]
  end
  config.vm.
    provision :shell,
              inline:
                "echo 'Acquire::http { Proxy \"${config['http_proxy']}\"; };' > /etc/apt/apt.conf.d/02proxy"
  config.vm.provision :shell, inline: "sudo apt-get -y install python-git"
  config.vm.provision :shell, path: "salt/prepare-salt-roots.sh"
  config.vm.provision :shell, path: "vagrant-bootstrap.sh"
  config.vm.provision :shell, path: "make-salt-minion-config.sh"
  #config.vm.provision :salt do |salt|
  #  salt.minion_config = 'salt/minion'
  #  salt.run_highstate = true
  #  salt.verbose = true
  #  #salt.no_minion = true
  #end
  #config.proxy.http = "http://10.0.2.101:3142"
  #
  # View the documentation for the provider you're using for more
  # information on available options.
  
end
