# Une VM Debian 13 prête pour rootcamp.
#
#   vagrant up      # crée et configure la VM (la première fois : quelques minutes)
#   vagrant ssh     # se connecter à la VM
#   vagrant destroy # tout supprimer pour repartir de zéro

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-13"
  config.vm.hostname = "rootcamp"

  # Mac (Intel ou Apple Silicon) et Windows
  config.vm.provider "vmware_desktop" do |v|
    v.gui = false
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
  end

  # Windows et Mac Intel uniquement
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Le dépôt est partagé dans la VM sous /vagrant : rootcamp l'utilise directement.
  config.vm.provision "shell", inline: "RC_SOURCE=/vagrant bash /vagrant/install.sh"
end
