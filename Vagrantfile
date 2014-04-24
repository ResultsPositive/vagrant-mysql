# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-64-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.define "client" do |client|
    config.vm.box = "centos-64-x64-vbox4210"
    config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    config.vm.hostname = "mysql01.ghostlab.net"
    config.vm.provider "virtualbox" do |vm|
      vm.name = "mysql01"
      vm.memory = 1024
    end
    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.module_path = "modules"
      config.vm.network "private_network", ip: "192.168.65.11"
      puppet.facter = {
        "vagrant" => "1"
      }    
    end
    config.vm.synced_folder "data", "/vagrant_data"
  end
end
