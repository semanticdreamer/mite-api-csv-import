# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "debian-6.0.4-squeeze-server"

  config.vm.provision :puppet do |puppet|
    puppet.pp_path = "/tmp/vagrant-puppet"
    puppet.manifests_path = "vagrant-puppet/puppet/manifests"
    puppet.manifest_file  = "site.pp"
    puppet.module_path    = "vagrant-puppet/puppet/modules"    
  end

end
