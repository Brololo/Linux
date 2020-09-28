# 0. Prérequis

🌞 **Setup de deux machines CentOS7 configurée de façon basique.**

- partitionnement

  - ajouter un deuxième disque de 5Go à la machine

    [Fait directement à partir de Virtual Box.
    Dans la patie : Settings > Storage > Controller : SATA]

  - partitionner le nouveau disque avec LVM

    - deux partitions, une de 2Go, une de 3Go
    - la partition de 2Go sera montée sur `/srv/site1`
    - la partition de 3Go sera montée sur `/srv/site2`

            pvcreate /dev/sdb
            vgcreate data /dev/sdb
            lvcreate -L 12G data
            lvcreate -l +100%FREE data
            mkfs.ext4 /dev/data/lvol0
            mkfs.ext4 /dev/data/lvol1
            mount /dev/data/lvol0 /srv/site1
            mount /dev/data/lvol1 /srv/site2

  - les partitions doivent être montées automatiquement au démarrage (fichier `/etc/fstab`)

        nano /etc/fstab :
        /dev/data/lvol0 /srv/data1 ext4 defaults 0 0
        /dev/data/lvol1 /srv/data2 ext4 defaults 0 0

- un accès internet

  - carte réseau dédiée

        Carte enp0s3 dédié à internet :

        ip a :

        2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 08:00:27:7d:8d:2f brd ff:ff:ff:ff:ff:ff
        inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic enp0s3
        valid_lft 84664sec preferred_lft 84664sec
        inet6 fe80::3163:1ba3:4f06:8227/64 scope link noprefixroute
        valid_lft forever preferred_lft forever

  - route par défaut

        J'utilise ip n s pour regarder les routes par défaut :

        ip n s :

            10.0.2.2 dev enp0s3 lladdr 52:54:00:12:35:02 STALE : Route par  défaut pour la connexion internet.
            192.168.1.1 dev enp0s8 lladdr 0a:00:27:00:00:0f DELAY
            192.168.1.12 dev enp0s8 lladdr 08:00:27:8b:35:a8 STALE

- un accès à un réseau local (les deux machines peuvent se `ping`)

        [root@node1 ~]# ping node2 -c3
        PING node2 (192.168.1.12) 56(84) bytes of data.
        64 bytes from node2 (192.168.1.12): icmp_seq=1 ttl=64 time=0.598 ms
        64 bytes from node2 (192.168.1.12): icmp_seq=2 ttl=64 time=0.746 ms
        64 bytes from node2 (192.168.1.12): icmp_seq=3 ttl=64 time=0.837 ms

        --- node2 ping statistics ---
        3 packets transmitted, 3 received, 0% packet loss, time 2004ms
        rtt min/avg/max/mdev = 0.598/0.727/0.837/0.098 ms

- carte réseau dédiée

      Carte enp0s8 dédié :

      ip a :

        3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 08:00:27:ca:0f:0a brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.11/24 brd 192.168.1.255 scope global noprefixroute enp0s8
        valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:feca:f0a/64 scope link
        valid_lft forever preferred_lft forever

- route locale

        ip n s :

        10.0.2.2 dev enp0s3 lladdr 52:54:00:12:35:02 STALE : Route par défaut pour la connexion internet.
        192.168.1.1 dev enp0s8 lladdr 0a:00:27:00:00:0f DELAY
        192.168.1.12 dev enp0s8 lladdr 08:00:27:8b:35:a8 STALE]

- les machines doivent avoir un nom

  - `/etc/hostname`
  - commande `hostname`)

        Sur node1.tp1.b2 : nano /etc/hostname > node1.tp1.b2
        Sur node2.tp1.b2 : nano /stc/hostname > node2.tp1.b2

- les machines doivent pouvoir se joindre par leurs noms respectifs

  - fichier `/etc/hosts`

        Sur node1.tp1.b2 : nano /etc/hosts > 192.168.1.12 node2
        Sur node2.tp1.b2 : nano /stc/hosts > 192.168.1.11 node1

- un utilisateur administrateur est créé sur les deux machines (il peut exécuter des commandes `sudo` en tant que `root`)

  - création d'un user

        J'utilise adduser pour créer l'user admin.

  - modification de la conf sudo

        [root@node1 ~]# usermod -aG wheel admin

- vous n'utilisez QUE `ssh` pour administrer les machines

  - création d'une paire de clés (sur VOTRE PC)
  - déposer la clé publique sur l'utilisateur de destination

        J'ai généré une clé ssh sur la vm avec ssh-keygen.
        j'ai switch de user à admin et j'ai créé le fichier
        .ssh/authorized_keys
        dans leuqel j'ai entré la clé ssh publique de mon pc (is_rsa.pub).

- le pare-feu est configuré pour bloquer toutes les connexions exceptées celles qui sont nécessaires

  - commande `firewall-cmd` ou `iptables`

            J'ai supprimé les ports 5555 6666 1025 80 ouverts qui sont en trop avec la commande :

            firewall-cmd --remove-port=80/tcp --permanent

            J'ai ouvert le port 22 (port de connexion ssh) avec la commande

            firewall-cmd --add-port=22/tcp --permanent

            Ainsi le seul port ouvert est le port 22



            J'ai mis les ip correspondant en changeant le fichier :

            nano /etc/sysconfig/network-script/ifcfg-enp0s8 et en changeant
            l'ip.
            Puis j'ai ifdown enp0s8 et ifup enp0s8 et voilà.

I. Setup serveur Web

- Installer le serveur web NGINX sur node1.tp1.b2 (avec une commande yum install).

                [root@node1 ~]# yum install -y epel-release
                [root@node1 ~]# yum –y install nginx

- Faites en sorte que :

  - NGINX servent deux sites web, chacun possède un fichier unique index.html

                [root@node1 ~]# touch /srv/site1/index.html
                [root@node1 ~]# touch /srv/site2/index.html

- Les permissions sur ces dossiers doivent être le plus restrictif possible

                chmod 500 site1
                chmod 500 site2

- Ces dossiers doivent appartenir à un utilisateur et un groupe spécifique

                Je crée nginx_user et je lui attribue "root" comme mdp.

                adduser nginx_user
                passwd nginx_user

                Je crée le groupe nginx_user_groop et j'ajoute  nginx_user dedans

                groupadd nginx_user_group

                gpasswd -a nginx_user nginx_user_group

                Je défini l'utilisateur nginx_user et nginx_user_group comme utilisateur des dossiers

                chown nginx_user:nginx_user_group /srv/site1
                chown nginx_user:nginx_user_group /srv/site2
                chown nginx_user:nginx_user_group /srv/site1/index.html
                chown nginx_user:nginx_user_group /srv/site2/index.html

- les sites doivent être servis en HTTPS sur le port 443 et en HTTP sur le port 80

                listen 80; / listen 443;

- n'oubliez pas d'ouvrir les ports firewall

                firewall-cmd --add-port=443/tcp --permanent
                firewall-cmd --add-port=80/tcp --permanent
                firewall-cmd --reload

- Création de la clé de certificat

                openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt

                mv server.crt /etc/pki/tls/certs/node1.b2.tp1.crt
                mv server.key /etc/pki/tls/private/node1.b2.tp1.key

- configuration nginx

            user nginx_user;

            worker_processes 1;
            error_log nginx_error.log;
            pid /run/nginx.pid;

            events {
                  worker_connections 1024;
            }

            http {
                  server {
                        listen 80;

                        server_name node1.tp1.b2;

                        location / {
                              return 301 /site1;
                        }

                        location /site1 {
                              alias /srv/site1;
                        }
                        location /site2 {
                              alias /srv/site2;
                        }

                  }
                  server {
                        listen 443 ssl;

                        server_name node1.tp1.b2;
                        ssl_certificate /etc/pki/tls/certs/node1.tp1.b2.crt;
                        ssl_certificate_key /etc/pki/tls/private/node1.tp1.b2.key;

                        location / {
                              return 301 /site1;
                        }

                        location /site1 {
                              alias /srv/site1;
                        }
                        location /site2 {
                              alias /srv/site2;
                        }
                  }
            }

- Prouver que la machine node2 peut joindre les deux sites web

      Prouver que la machine node2 peut joindre les deux sites web

      [root@node2 ~]# curl -kL https://node1.tp1.b2/site1
      SITE 1
      [root@node2 ~]# curl -kL https://node1.tp1.b2/site2
      SITE 2

II. Script de sauvegarde

- Ecrire un script

- Caractéristiques du script

  - s'appelle tp1_backup.sh

  - sauvegarde les deux sites web

    - c'est à dire qu'il crée une archive compressée pour chacun des sites

    - les noms des archives contiennent le nom du site sauvegardé ainsi que la date et heure de la sauvegarde

  - Les archives se mettent dans /srv/backup/
  - Garde que 7 exemplaires de sauvegardes
  - à la huitième sauvegarde réalisée, la plus ancienne est supprimée
  - Le script sauvegarde un seul site à la fois en passant le dossier par argument
  - on peut donc appeler le script en faisant tp1_backup.sh /srv/site1 afin de déclencher une sauvegarde de /srv/site1
  - Le script peut sauvegarder tous les sites en passant all comme argument
  - Le script écrit les logs dans le fichier /var/log/backup.log

  - NB : votre script

    - doit s'exécuter sous l'identité d'un utilisateur dédié appelé backup

Je crée le user backup_user

            adduser backup_user
            passwd backup_user

Je le met dans le groupe nginx_user pour qu'il puisse intéragir avec les fichiers du site

            gpasswd -a backup_user nginx_user_group

Je crée un dossier backup où seront stocké les .tar et .gz

            mkdir /srv/backup
            chown backup_user:backup_user /srv/backup
            chmod 700 /srv/backup

            Je me suis rendu compte plus tard que j'ai appelé l'utilisateur et le groupe pareil mais ça fonctionne donc je n'y touche pas.

Je crée un fichier de log où les logs du script seront stockés

            touch /var/log/backup.logs
            chown backup:backup /var/log/backup.logs
            chmod 700 /var/log/backup.logs

Je modifie les droits des fichiers pour les adapter à user_backup qui fait parti du groupe nginx_user_group

            chmod 750 backup/
            touch tp1_backup.sh
            chmod 700 tp1_backup.sh
            chmod 750 site1
            chmod 750 site2
            chmod 650 index.html
            chmod 650 lost+found/

🌞 Utiliser la crontab pour que le script s'exécute automatiquement toutes les heures.

            crontab -u backup -e
            0 * * * * sh /srv/tp1_backup.sh all

j'ajoute nginx_user au groupe backup_user

      gpasswd -a nginx_user backup_user

Pour restaurer le site il faut extraire l'extraire avec cette commande avec l'utilisateur nginx_user

      tar -xzvf /srv/backup/Name.tar.gz

- Créer une unité systemd qui permet de déclencher le script de backup

      [Unit]
      Description=Execute backup every hours

      [Service]
      User=backup_user
      Restart=always
      RestartSec=3600s
      ExecStart=/bin/bash /srv/tp1_backup.sh all

      [root@node1 srv]# systemctl status backup
      ● backup.service - Execute backup every hours
      Loaded: loaded (/etc/systemd/system/backup.service; static; vendor preset: disabled)
      Active: activating (auto-restart) since Mon 2020-09-28 11:16:35 CEST; 6s ago
      Process: 1499 ExecStart=/bin/bash /srv/tp1_backup.sh all (code=exited, status=0/SUCCESS)
      Main PID: 1499 (code=exited, status=0/SUCCESS)

Le script

            #!/bin/bash

            PATH_SITE1="/srv/site1"
            PATH_SITE2="/srv/site2"

            PATH_BACKUP="/srv/backup/"

            LOG_FILE="/var/log/backup.log"

            PATH_ARG=$1

            function compress {
            SITE=$( echo $1 | cut -d'/' -f3)
            {
                  tar -zcvpf ${PATH_BACKUP}${SITE}_$(date "+%Y%m%d_%H%M").tar.gz -P /srv/${SITE} 2>> ${LOG_FILE} 1>/dev/null
                  delete_oldest ${SITE}
                  echo $'\t' "${SITE} was compressed on $(date "+%b %m, %Y at %Hh%M")" >> ${LOG_FILE}
            } || {
                  echo "/!\ - ERROR WHILE COMPRESS"
            }

            }
            function compress_all {
            compress ${PATH_SITE1}
            compress ${PATH_SITE2}
            }
            function delete_oldest {
            OLDEST_FILES=$(ls -1t ${PATH_BACKUP}$1* | grep .tar.gz | tail -n +8)
            for file in ${OLDEST_FILES}; do
                  rm -f ${file}
                  echo $'\t' "$(echo ${file} | cut -d'/' -f4) was deleted" >> ${LOG_FILE}
            done;
            }


            echo $'\n' "---- BACKUP SCRIPT START ----" >> ${LOG_FILE}

            if [ ! -z ${PATH_ARG} ] && ([ ${PATH_ARG} == ${PATH_SITE1} ] || [ ${PATH_ARG} == ${PATH_SITE2} ]); then
            compress ${PATH_ARG}
            elif [ ! -z ${PATH_ARG} ] && [ ${PATH_ARG} == "all" ]; then
            compress_all
            else
            echo "Bad argument, use ${PATH_SITE1} | ${PATH_SITE1} | all"
            echo "---- BAD ARGUMENT | BACKUP SCRIPT END ----" >> ${LOG_FILE}
            exit 1
            fi

            echo "---- BACKUP SCRIPT END ----" >> ${LOG_FILE}
            exit 0

III. Monitoring, alerting

🌞 Mettre en place l'outil Netdata en suivant les instructions officielles et s'assurer de son bon fonctionnement.

      j'installe netdata

      bash <(curl -Ss https://my-netdata.io/kickstart.sh)

      j'ouvre le port 19999

      firewall-cmd --add-port=19999/tcp --permanent

🌞 Configurer Netdata pour qu'ils vous envoient des alertes dans un salon Discord dédié

      je m'aide de se site https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks

Je configure netdata pour qu'il fonctionne avec discord

      /etc/netdata/edit-config health_alarm_notify.conf

je modifie la ligne avec DISCORD_WEBHOOK_URL="" et mets le lien du webhook créé

      https://discordapp.com/api/webhooks/760087143312916530/jmO-ZcG0KIOlk9CSQQA1W3Tzzvd7ChWAzCNrTXQk_gJqg4QfzHUxuCPc5XZC4XvXB1M1

je modifie la ligne avec DEFAULT_RECIPIENT_DISCORD="alarms" et mets le channel que le webhook utilise

      DEFAULT_RECIPIENT_DISCORD="ndata_alertes"

Je test pour voir si tout fonctionne

      su -s /bin/bash netdata
      export NETDATA_ALARM_NOTIFY_DEBUG=1
      /usr/libexec/netdata/plugins.d/alarm-notify.sh test

Je reçois bien les messages sur mon serveur discord.

La config serveur

            user nginx_user;

            worker_processes 1;
            error_log nginx_error.log;
            pid /run/nginx.pid;

            events {
                  worker_connections 1024;
            }

            upstream netdata {
            server 127.0.0.1:19999;
            keepalive 64;
            }

            http {
                  server {
                        listen 80;

                        server_name node1.tp1.b2;

                        location / {
                              return 301 /site1;
                        }

                        location /site1 {
                              alias /srv/site1;
                        }
                        location /site2 {
                              alias /srv/site2;
                        }

                        location ~ /netdata/(?<ndpath>.*) {
                              proxy_redirect off;
                              proxy_set_header Host $host;

                              proxy_set_header X-Forwarded-Host $host;
                              proxy_set_header X-Forwarded-Server $host;
                              proxy_set_header X-Forwarded-For
                              $proxy_add_x_forwarded_for;
                              proxy_http_version 1.1;
                              proxy_pass_request_headers on;
                              proxy_set_header Connection "keep-alive";
                              proxy_store off;
                              proxy_pass http://netdata/$ndpath$is_args$args;

                              gzip on;
                              gzip_proxied any;
                              gzip_types *;
                        }
                  }

                  server {
                        listen 443 ssl;

                        server_name node1.tp1.b2;
                        ssl_certificate /etc/pki/tls/certs/node1.tp1.b2.crt;
                        ssl_certificate_key /etc/pki/tls/private/node1.tp1.b2.key;

                        location / {
                              return 301 /site1;
                        }

                        location /site1 {
                              alias /srv/site1;
                        }
                        location /site2 {
                              alias /srv/site2;
                        }

                        location ~ /netdata/(?<ndpath>.*) {
                              proxy_redirect off;
                              proxy_set_header Host $host;

                              proxy_set_header X-Forwarded-Host $host;
                              proxy_set_header X-Forwarded-Server $host;
                              proxy_set_header X-Forwarded-For
                              $proxy_add_x_forwarded_for;
                              proxy_http_version 1.1;
                              proxy_pass_request_headers on;
                              proxy_set_header Connection "keep-alive";
                              proxy_store off;
                              proxy_pass http://netdata/$ndpath$is_args$args;

                              gzip on;
                              gzip_proxied any;
                              gzip_types *;
                        }
                  }
            }
