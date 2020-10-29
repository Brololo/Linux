🌞 Utilisez la ligne de commande pour sortir les infos suivantes :

- **|CLI|** afficher le nombre de _services systemd_ dispos sur la machine

```
systemctl -t service
```

- **|CLI|** afficher le nombre de _services systemd_ actifs _("running")_ sur la machine

```
systemctl -t service --state=active
```

- **|CLI|** afficher le nombre de _services systemd_ qui ont échoué _("failed")_ ou qui sont inactifs _("exited")_ sur la machine

```
systemctl -t service --state=failed,exited
```

- **|CLI|** afficher la liste des _services systemd_ qui démarrent automatiquement au boot _("enabled")_

```
systemctl list-unit-files | grep enabled

ou

systemctl list-unit-files --state=enabled
```

🌞 Etudiez le service `nginx.service`

- déterminer le path de l'unité `nginx.service`

```
/usr/lib/systemd/system/nginx.service
```

- afficher son contenu et expliquer les lignes qui comportent :

  - `ExecStart`

  ```
  ExecStart=/usr/sbin/nginx
  ```

  - `ExecStartPre`

  ```
  ExecStartPre=/usr/bin/rm -f /run/nginx.pid
  ExecStartPre=/usr/sbin/nginx -t
  ```

  - `PIDFile`

  ```
  PIDFile=/run/nginx.pid
  ```

  - `Type`

  ```
  Type=forking
  ```

  - `ExecReload`

  ```
  ExecReload=/bin/kill -s HUP $MAINPID
  ```

  - `Description`

  ```
  Description=The nginx HTTP and reverse proxy server
  ```

  - `After`

  ```
  After=network.target remote-fs.target nss-lookup.target
  ```

🌞 **|CLI|** Listez tous les services qui contiennent la ligne `WantedBy=multi-user.target`

```
grep -rnw '/usr/lib/systemd/system' -e 'WantedBy=multi-user.target'
```

🌞 Créez une unité de service qui lance un serveur web

- la commande pour lancer le serveur web est `python3 -m http.server <PORT>`
- quand le service se lance, le port doit s'ouvrir juste avant dans le firewall

```
ExecStartPre=+/usr/sbin/firewalld-cmd --add-port=${PORT}/tcp --permanent
```

- quand le service se termine, le port doit se fermer juste après dans le firewall

```
ExecStop=+/usr/sbin/firewalld-cmd --remove-port=${PORT}/tcp --permanent
```

- un utilisateur dédié doit lancer le service

```
User=nginx_user
```

- le service doit comporter une description

```
Description=Start web server Python3
```

- le port utilisé doit être défini dans une variable d'environnement (avec la clause `Environment=`)

```
Environment="PORT=19999"
```

```bash
[Unit]
Description=Start web server Python3

[Service]
User=nginx_user
Environment="PORT=19999"
ExecStartPre=+/usr/sbin/firewall-cmd --add-port=${PORT}/tcp --permanent
ExecStartPre=+/usr/sbin/firewall-cmd --reload
ExecStart=/usr/bin/python3 -m http.server ${PORT}
ExecStop=+/usr/sbin/firewall-cmd --remove-port=${PORT}/tcp --permanent
ExecStop=+/usr/sbin/firewall-cmd --reload

```

🌞 Lancer le service

- prouver qu'il est en cours de fonctionnement pour systemd

```
[root@nodeTP3 system]# systemctl status server.service
● server.service - Start web server Python3
   Loaded: loaded (/etc/systemd/system/server.service; static; vendor preset: disabled)
   Active: active (running) since Wed 2020-10-07 07:17:42 UTC; 28s ago
 Main PID: 1444 (python3)
   CGroup: /system.slice/server.service
           └─1444 /usr/bin/python3 -m http.server 19999
```

- faites en sorte que le service s'allume au démarrage de la machine

```
systemctl enable server.service

je rajoute aussi ses 2 lignes à la fin de mon fichier server.service

[Install]
WantedBy=multi-user.target
```

- prouver que le serveur web est bien fonctionnel

```
[root@nodeTP3 system]# curl 127.0.0.1:19999
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href="bin/">bin@</a></li>
<li><a href="boot/">boot/</a></li>
<li><a href="dev/">dev/</a></li>
<li><a href="etc/">etc/</a></li>
<li><a href="home/">home/</a></li>
<li><a href="lib/">lib@</a></li>
<li><a href="lib64/">lib64@</a></li>
<li><a href="media/">media/</a></li>
<li><a href="mnt/">mnt/</a></li>
<li><a href="opt/">opt/</a></li>
<li><a href="proc/">proc/</a></li>
<li><a href="root/">root/</a></li>
<li><a href="run/">run/</a></li>
<li><a href="sbin/">sbin@</a></li>
<li><a href="srv/">srv/</a></li>
<li><a href="swapfile">swapfile</a></li>
<li><a href="sys/">sys/</a></li>
<li><a href="tmp/">tmp/</a></li>
<li><a href="usr/">usr/</a></li>
<li><a href="var/">var/</a></li>
</ul>
<hr>
</body>
</html>
```

### B. Sauvegarde

🌞 Créez une unité de service qui déclenche une sauvegarde avec votre script

- le script doit se lancer sous l'identité d'un utilisateur dédié
- le service doit utiliser un PID file
- le service doit posséder une description
- vous éclaterez votre script en trois scripts :
  - un script qui se lance AVANT la sauvegarde, qui effectue les tests
  - script de sauvegarde
  - un script qui s'exécute APRES la sauvegarde, et qui effectue la rotation (ne garder que les 7 sauvegardes les plus récentes)
  - une fois fait, utilisez les clauses `ExecStartPre`, `ExecStart` et `ExecStartPost` pour les lancer au bon moment

🌞 Ecrire un fichier `.timer` systemd

- lance la backup toutes les heues

🐙 Améliorer la sécurité du service de sauvegarde

## 1. Gestion de boot

🌞 Utilisez `systemd-analyze plot` pour récupérer une diagramme du boot, au format SVG

- il est possible de rediriger l'output de cette commande pour créer un fichier `.svg`
  - un `.svg` ça peut se lire avec un navigateur
  ```
  systemd-analyze plot > plot.svg
  ```
- déterminer les 3 **services** les plus lents à démarrer

```
sssd.service (4.156s)
tuned.service (7.936s)
NetworkManager-wait-online.service (30.453s)
```

## 2. Gestion de l'heure

🌞 Utilisez la commande `timedatectl`

```
[root@localhost ssh]# timedatectl
               Local time: Wed 2020-10-07 09:32:32 UTC
           Universal time: Wed 2020-10-07 09:32:32 UTC
                 RTC time: Wed 2020-10-07 09:32:30
                Time zone: UTC (UTC, +0000)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

- déterminer votre fuseau horaire

```
Local time: Wed 2020-10-07 09:32:32 UTC
```

- déterminer si vous êtes synchronisés avec un serveur NTP

```
System clock synchronized: yes
NTP service: active
```

- changer le fuseau horaire

```
timedatectl set-timezone Europe/Paris
```

## 3. Gestion des noms et de la résolution de noms

🌞 Utilisez `hostnamectl`

- déterminer votre hostname actuel

```
[root@localhost ssh]# hostname
localhost.localdomain
```

- changer votre hostname

```
sudo vi /etc/hostname
sudo vi /etc/hosts
sudo reboot
```
