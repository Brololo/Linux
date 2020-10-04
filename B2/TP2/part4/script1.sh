site1_path="/srv/site1"
site2_path="/srv/site2"
nginxUser="nginx_user"
nginxGroup="nginx_user_group"
backupUser="backup_user"
backupGroup="backup_group"
backupPath="/srv/backup"
link="https://discordapp.com/api/webhooks/760087143312916530/jmO-ZcG0KIOlk9CSQQA1W3Tzzvd7ChWAzCNrTXQk_gJqg4QfzHUxuCPc5XZC4XvXB1M1"
discordDefaultChannel="ndata_alertes"

mkdir ${site1_path}
mkdir ${site2_path}
echo "SITE 1" > ${site1_path}/index.html
echo "SITE 2" > ${site2_path}/index.html

chmod 400 ${site1_path}/index.html
chmod 400 ${site2_path}/index.html

chmod 500 ${site1_path}
chmod 500 ${site2_path}

adduser ${nginxUser}
groupadd ${nginxGroup}
gpasswd -a ${nginxUser} ${nginxGroup}

chown ${nginxUser}:${nginxGroup} ${site1_path}
chown ${nginxUser}:${nginxGroup} ${site2_path}
chown ${nginxUser}:${nginxGroup} ${site1_path}/index.html
chown ${nginxUser}:${nginxGroup} ${site2_path}/index.html

firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=19999/tcp --permanent
firewall-cmd --reload

echo "-----BEGIN CERTIFICATE-----
MIIDATCCAemgAwIBAgIJAOSe/OBi5TdRMA0GCSqGSIb3DQEBCwUAMBcxFTATBgNV
BAMMDG5vZGUxLnRwMi5iMjAeFw0yMDA5MzAxNDQyNTRaFw0yMTA5MzAxNDQyNTRa
MBcxFTATBgNVBAMMDG5vZGUxLnRwMi5iMjCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAL368ZScDkqrmyaMZICN7sdCBSMr9BTiBKEQCz9vGdefb9WiicPC
nD4N7c0ubrK0X2mdXh0t/74o2VyYTEt5b1qi8l2LmNev+Tgh/WlYDcqXerqDkm76
zOGmCzn8QS2fwoQ7MzwCYo/ZTfzgLNx05YUIbL2LroZ8ilf8ugzQzZXvAJRmZpuu
Cwo72BSNg1wUrBeWctAnRtuPjIvt1T48YELxTpJtJCBJyZcyHqpxdYsOm+8DDZ05
0qocDEFxl0kJs/N0C9cJHW/op1M6iBEs66bgZqMjNJLSxbgldVBwluuQvz1qO9kK
evG7iUhPueNa7soa4hwstmrDAD/Ic2mSGykCAwEAAaNQME4wHQYDVR0OBBYEFA9o
E8WczL9YKXAsbWWUzF2bkl/+MB8GA1UdIwQYMBaAFA9oE8WczL9YKXAsbWWUzF2b
kl/+MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBADIylVOKf8Vn6KZv
C2PMLCdyb3zIOdFaZb2FwQQbQjP8a5wGjTk48+g0+yJ4JeJqRKQocC/x7czJdkz6
Xg8Sk6KR742kvQZU3xtJSohFiUHjscaDWEbGSJEt9fjuo97x+frXhHhmB40zaOvu
kldTYMrbnyOMadZSKafv0Vc98fainsnclZcTv3YCeimFFcNlYrsLRSzaU39pjSht
ZqoDtFDjbkaAEoaoXtl7MzC5q0BPs3Md/2KH+CF4QArspqvoShw11OaLw1DE66ZS
h6RQsFqcuLMh3dM2C8WgivFWehRyfYGl587ZJzUn95eUOFuMKGjRUHJVfkJI1i4i
IkDgY9M=
-----END CERTIFICATE-----" > /etc/pki/tls/certs/node1.tp2.b2.crt

echo "-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9+vGUnA5Kq5sm
jGSAje7HQgUjK/QU4gShEAs/bxnXn2/VoonDwpw+De3NLm6ytF9pnV4dLf++KNlc
mExLeW9aovJdi5jXr/k4If1pWA3Kl3q6g5Ju+szhpgs5/EEtn8KEOzM8AmKP2U38
4CzcdOWFCGy9i66GfIpX/LoM0M2V7wCUZmabrgsKO9gUjYNcFKwXlnLQJ0bbj4yL
7dU+PGBC8U6SbSQgScmXMh6qcXWLDpvvAw2dOdKqHAxBcZdJCbPzdAvXCR1v6KdT
OogRLOum4GajIzSS0sW4JXVQcJbrkL89ajvZCnrxu4lIT7njWu7KGuIcLLZqwwA/
yHNpkhspAgMBAAECggEBAIDchyKbG6KQdeOW1NDR9QWZBW0O8jd7+1HYVRjI3kmA
btYEstdi2KHKxuMmvJVgfVthD6ZRPigZAx6oew+ypdJftm+3MYwTY8MsYvwiavBh
ATEj755xZakk/HZvYTJ2K/WPRjhNEdequRhuYl+CtvAef8utxEqajSgTV4s70kcA
scsz7SewkCA70aubiFMzeC9BzR0XUJUb5CzcHXWCEEcZi4W296VhnQkcHPo6ijwK
4JHCxuWAOfRP8AJ20E3QWfB2j/DQYjlB3PyDbzYEfyQs9ZVFu6ITz5JZBmXqFFDW
vB9gR9wWIVT4JWbFGT8ronngiAULgPDR8GGvHL9AqYECgYEA+rdSDV0WCnqf4PGU
L1qstDzkKyyBL5i9eUlgkdEPgPFbKCe7Z+Rca1bZa/6fKryQHbb0o/xePDJxu+LQ
kxvMVoYe9+EaGbw1cAW0X1LCgj4AkVqAbGr7yopH87vITOAw5hb6vjnkAPiQFemT
YVvH7KXnBitQTR72Ovxv8GwJoFECgYEAwfvv7t5Uarow2EQ5f/by/FAwe9sR5Lfy
rjFfEcl4U5nuRN/CGZhhBA0qlgNRrpZrTQdSk6qqGVdFq3G3BzPIpqKa3h5e51vX
h7q10Mkg/xo4BTseMI9FzTGJNvl/osoXYOpVWYjLWeJbI03/XKg7zbKwY9d0m30d
LM9jO3UCr1kCgYAQcy7DCbSEg38x9yfN45kpSkV+P7FKOi9UYeggKSNnRm7At7qo
Gmel81DYsSAoYa7jBDoQ+GIGeRjVRxCAVnaVxr8JbI+V2K945ibrijaQ7RiEcPe0
JWDX7TLDXzLJOHx83E0fZhT7q1No3KZ64NbBRDFgSj8+kCV/wUhm8e+/wQKBgB4m
VDJiJ+i2q6TRZcZ30WhZ5k85y1wrIvLkBYy0LZmA0UGvLXHg9yM0EKxkM6vZATBl
tPXyjqGFqPRupi3eZI9RspRXUBTRd3xHDr82o4RCxPY7LAQMIKM10cfTm3znwB52
DXHvCvwbbGLeWpRCKZlc7oF2GU+ZcJFoYln5Y8NxAoGAIBAjiqtgtVXjGGiHIeq6
Z6gHcLJxz0R6u00kvqX2TeDpncJXR9O2YVMS1LlSDSJ/cv26SFSjI0Jym6xENvoF
nocTn8IXtWhvE3wnsNWjSQ+slRtgXhYeNDnoTyqGonufN3NiV42FcLD6qghd7o6r
ANNR7JGyFy45x2cizkUS3a0=
-----END PRIVATE KEY-----" > /etc/pki/tls/private/node1.tp2.b2.key

echo '
    user nginx_user;

    worker_processes 1;
    error_log nginx_error.log;
    pid /run/nginx.pid;

    events {
            worker_connections 1024;
    }

    http {
        upstream netdata {
                server 127.0.0.1:19999;
                keepalive 64;
        }
        server {
                listen 80;

            server_name node1.tp2.b2;

            location / {
                    return 301 /site1;
            }

            location /site1 {
                    alias /srv/site1;
            }
            location /site2 {
                    alias /srv/site2;
            }
            location = /netdata {
            return 301 /netdata/;
                }
                location ~ /netdata/(?<ndpath>.*) {
                        proxy_redirect off;
                        proxy_set_header Host \$host;
                        proxy_set_header X-Forwarded-Host \$host;
                        proxy_set_header X-Forwarded-Server \$host;
                        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                        proxy_http_version 1.1;
                        proxy_pass_request_headers on;
                        proxy_set_header Connection \"keep-alive\";
                        proxy_store off;
                        proxy_pass http://netdata/\$ndpath\$is_args\$args;
                        gzip on;
                        gzip_proxied any;
                        gzip_types *;
                }
        }
        
        server {
            listen 443 ssl;

            server_name node1.tp2.b2;
            ssl_certificate /etc/pki/tls/certs/node1.tp2.b2.crt;
            ssl_certificate_key /etc/pki/tls/private/node1.tp2.b2.key;

            location / {
                    return 301 /site1;
            }

            location /site1 {
                    alias /srv/site1;
            }
            location /site2 {
                    alias /srv/site2;
            }
            location = /netdata {
            return 301 /netdata/;
            }
                    location ~ /netdata/(?<ndpath>.*) {
            proxy_redirect off;
            proxy_set_header Host \$host;
            proxy_set_header X-Forwarded-Host \$host;
            proxy_set_header X-Forwarded-Server \$host;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_http_version 1.1;
            proxy_pass_request_headers on;
            proxy_set_header Connection \"keep-alive\";
            proxy_store off;
            proxy_pass http://netdata/\$ndpath\$is_args\$args;
            gzip on;
            gzip_proxied any;
            gzip_types *;
            }
        }
    }
' > /etc/nginx/nginx.conf

systemctl start nginx


useradd ${backupUser} -M -s /sbin/nologin
groupadd "${backupGroup}"
gpasswd -a "${backupUser}" "${backupGroup}"

gpasswd -a ${backupUser} ${nginxGroup}
mkdir "${backupPath}"
chown ${backupUser}:${backupGroup} "${backupPath}"
chmod 750 "${backupPath}"
touch /var/log/backup.logs
chown ${backupUser}:${backupGroup} /var/log/backup.logs
chmod 600 /var/log/backup.logs

chmod 750 "${site1Path}" "${site2Path}"
chmod 440 "${site1Path}/index.html" "${site2Path}/index.html"

gpasswd -a ${nginxUser} ${backupGroup}

echo "[Unit]
Description=Start backup every hours

[Service]
User=backup
Restart=always
RestartSec=3600s
ExecStart=/bin/bash /srv/tp1_backup.sh all
" > /etc/systemd/system/backup.service
systemctl enable backup
systemctl start backup

bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait

/etc/netdata/edit-config health_alarm_notify.conf
rm -rf /etc/netdata/.health_alarm_notify.conf.swp

sed -i "s/DISCORD_WEBHOOK_URL=\"\"/DISCORD_WEBHOOK_URL=\"${link}\"/" /etc/netdata/health_alarm_notify.conf
sed -i "s/DEFAULT_RECIPIENT_DISCORD=\"\"/DEFAULT_RECIPIENT_DISCORD=\"${discordDefaultChannel}\"/" /etc/netdata/health_alarm_notify.conf