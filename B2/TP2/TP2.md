# I. Déploiement simple

🌞 Créer un `Vagrantfile` qui :

- utilise la box `centos/7`
- crée une seule VM

  - 1Go RAM
  - ajout d'une IP statique `192.168.2.11/24`
  - définition d'un nom (interne à Vagrant)
  - définition d'un hostname

```ruby
config.vm.hostname = "node"

config.vm.define "tp2" do |tp2|
    tp2.vm.network "private_network", ip: "192.168.2.11", netmask:"255.255.255.0"
    tp2.vm.provider "virtualbox" do |vb|
        vb.name = "TP2 VM"
        vb.memory = "1024"
    end
end
```

🌞 Modifier le `Vagrantfile`

- la machine exécute un script shell au démarrage qui install le paquet `vim`
- ajout d'un deuxième disque de 5Go à la VM

```ruby
disk = './secondDisk.vdi'

Vagrant.configure("2")do|config|
  config.vm.box="centos/7"

  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false

  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false

  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.hostname = "node"
  config.vm.provision :shell, path: "script.sh"

  config.vm.define "tp2" do |tp2|
    tp2.vm.network "private_network", ip: "192.168.2.11", netmask:"255.255.255.0"
    tp2.vm.provider "virtualbox" do |vb|
      vb.name = "TP2 VM"
      vb.memory = "1024"
      unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 5120]
      end

      vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
    end
  end
end
```

# II. Re-package

🌞 Repackager une box, **que vous appelerez `b2-tp2-centos`** en partant de la box `centos/7`, qui comprend :

- une mise à jour système
  - `yum update`
- l'installation de paquets additionels
  - `vim`

```

Déjà fait

```

- `epel-release`

```

sudo yum install epel-release -y

```

- `nginx`

```

sudo yum install nginx -y

```

- désactivation de SELinux

```

vim /etc/sysconfig/selinux
SELINUX=disabled

```

- firewall (avec `firewalld`, en utilisant la commande `firewall-cmd`)

  - activé au boot de la VM
  - ne laisse passser que le strict nécessaire (SSH)

```
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=22/tcp --permanent
sudo firewall-cmd --reload

```

# III. Multi-node deployment

🌞 Créer un `Vagrantfile` qui lance deux machines virtuelles, **les VMs DOIVENT utiliser votre box repackagée comme base** :

| x           | `node1.tp2.b2` | `node2.tp2.b2` |
| ----------- | -------------- | -------------- |
| IP locale   | `192.168.2.21` | `192.168.2.22` |
| Hostname    | `node1.tp2.b2` | `node1.tp2.b2` |
| Nom Vagrant | `node1`        | `node2`        |
| RAM         | 1Go            | 512Mo          |

```ruby
Vagrant.configure("2")do|config|
  config.vm.box="b2-tp2-centos"

  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false

  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false

  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "node1" do |node1|
      node1.vm.hostname = "node1.tp2.b2"
      node1.vm.network "private_network", ip: "192.168.2.21", netmask:"255.255.255.0"
      node1.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
  end

  config.vm.define "node2" do |node2|
    node2.vm.hostname = "node2.tp2.b2"
    node2.vm.network "private_network", ip: "192.168.2.22", netmask:"255.255.255.0"
    node2.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
    end
  end
end
```

# IV. Automation here we (slowly) come

🌞 Créer un `Vagrantfile` qui automatise la résolution du TP1
