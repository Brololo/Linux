```ruby
Vagrant.configure("2")do|config|
  config.vm.box="centos7-base"

  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM
  config.vbguest.auto_update = false

  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false

  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "gitea" do |gitea|
      gitea.vm.hostname = "gitea.tp4.b2"
      gitea.vm.network "private_network", ip: "192.168.1.12", netmask:"255.255.255.0"
      gitea.vm.provision :shell, path: "scriptPrGithéa.sh"
      gitea.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
  end
  config.vm.define "mariadb" do |mariadb|
      mariadb.vm.hostname = "mariadb.tp4.b2"
      mariadb.vm.network "private_network", ip: "192.168.1.13", netmask:"255.255.255.0"
      mariadb.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
  end
  config.vm.define "nginx" do |nginx|
      nginx.vm.hostname = "nginx.tp4.b2"
      nginx.vm.network "private_network", ip: "192.168.1.14", netmask:"255.255.255.0"
      nginx.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
  end
  config.vm.define "nfs" do |nfs|
      nfs.vm.hostname = "nfs.tp4.b2"
      nfs.vm.network "private_network", ip: "192.168.1.15", netmask:"255.255.255.0"
      nfs.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
  end
end
```
