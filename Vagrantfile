Vagrant.configure("2") do |config|
  config.vm.define "zbxsrv01" do |h|
    h.vm.box = "ubuntu/focal64"
    h.vm.hostname = "zbxsrv01"
    h.vm.network "private_network", ip: "10.0.100.100"
    h.vm.provision "shell", path: "provisioning.sh"
    h.vm.provider "virtualbox" do |vb|
      vb.name = "zbxsrv01"
      vb.memory = "2048"
      vb.cpus = 2
    end    
  end
end
