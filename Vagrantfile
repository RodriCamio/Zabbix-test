Vagrant.configure("2") do |config|
  #
  # Descomentar si estamos destras de un proxy
  #
  #if Vagrant.has_plugin?("vagrant-proxyconf")
  #  config.proxy.http     = "http://192.168.150.17:8080"
  #  config.proxy.https    = "http://192.168.150.17:8080"
  #  config.proxy.no_proxy = "localhost,127.0.0.1"
  #end
  config.vm.define "zbxsrv01" do |h|
    h.vm.box = "centos/7"
    h.vm.hostname = "zbxsrv01"
    h.vm.network "private_network", ip: "10.0.100.100"
    h.vm.provision "shell", path: "provisioning_server.sh"
    h.vm.provider "virtualbox" do |vb|
      vb.name = "zbxsrv01"
      vb.memory = "2048"
      vb.cpus = 2
    end    
  end
  # config.vm.define "zbxclient01" do |h|
  #   h.vm.box = "centos/7"
  #   h.vm.hostname = "zbxclient01"
  #   h.vm.network "private_network", ip: "10.0.100.101"
  #   h.vm.provision "shell", path: "provisioning.sh"
  #   h.vm.provider "virtualbox" do |vb|
  #     vb.name = "zbxclient01"
  #     vb.memory = "1024"
  #     vb.cpus = 2
  #   end
  # end
  # config.vm.define "zbxprxy01" do |h|
  #   h.vm.box = "centos/7"
  #   h.vm.hostname = "zbxprxy01"
  #   h.vm.network "private_network", ip: "10.0.100.102"
  #   h.vm.provision "shell", path: "provisioning.sh"
  #   h.vm.provider "virtualbox" do |vb|
  #     vb.name = "zbxprxy01"
  #     vb.memory = "1024"
  #     vb.cpus = 2
  #   end
  # end
end
