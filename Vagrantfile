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
  config.vm.box = "debian-jessie"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  #pref_interface = ['en2: USB Ethernet', 'en0: Wi-Fi (AirPort)']
  #pref_interface = ['maintap']
  #vm_interfaces = %x( VBoxManage list bridgedifs | grep ^Name ).gsub(/Name:\s+/, '').split("\n")
  #pref_interface = pref_interface.map {|n| n if vm_interfaces.include?(n)}.compact
  #$network_interface = pref_interface[0]  
  config.vm.network :public_network, :bridge => "maintap"
  config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    #vb.customize ["modifyvm", :id, "--memory", "512"]
    #vb.customize ["modifyvm", :id, "--natnet1", "10.0.3.0/24"]
    # a secondary bridged network is used for apt-cacher-ng
    # virtualbox nat has problems here
    #vb.customize ["modifyvm", :id, "--nic2", "bridged"]
    #vb.customize ["modifyvm", :id, "--bridgeadapter2", "maintap"]
    #vb.customize ["modifyvm", :id, "--nic1", "bridged"]
    #vb.customize ["modifyvm", :id, "--bridgeadapter1", "maintap"]
  end
  config.vm.
    provision :shell,
              inline:
                "echo 'Acquire::http { Proxy \"http://10.0.4.1:3142\"; };' > /etc/apt/apt.conf.d/02proxy"
  config.vm.provision :shell, inline: "sudo apt-get -y install python-git"
  config.vm.provision :shell, path: "salt/prepare-salt-roots.sh"
  config.vm.provision :shell, path: "vagrant-bootstrap.sh"
  #config.vm.provision :shell, path: "make-salt-minion-config.sh"
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
