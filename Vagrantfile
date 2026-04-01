Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.define "web" do |web|
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.56.10"
    web.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
    web.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "/vagrant/ansible/playbook.yml"
      ansible.inventory_path = "/vagrant/ansible/inventory/hosts.ini"
      ansible.limit = "web"
    end
  end
end
