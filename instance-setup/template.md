# 1. Create VM

console.cloud.google.com > Compute Engine > VM Instances > Create Instance
* name=[customer name]
* region=[customer region]
* Series=N2
* Machine type=n2-standard-8
* Boot disk > Change
  * Operation System=Ubuntu
  * Version=Ubuntu 22.04 LTS
  * Size=30GB
  * [Select]
* Access scopes=Allow full access to all Cloud APIs
* Allow HTTP traffic=On
* Allow HTTPS traffic=On
* Advanced Options > Disks > Add New Disk
  * Name=[customer]-data
  * Disk Source Type=Blank Disk
  * Disk Type=Balanced Persistent Disk
  * Size=100GB
  * Deletion rule=Delete disk
  * [Create]
* [SSH]
  * ```sudo su - ubuntu```
  * copy ssh key on VM
  * ```exit```
* Click on VM > [EDIT] > Network Interface > click on "Network interface is permanent" down arrow > External IPv4 address > Create IP address
  * Name=static
  * [RESERVE]
* [SAVE]

# 2. Setup VM
* Copy public IP
* Create block in ~/.ssh/config like this:
    ```
   Host [customer]
     User ubuntu
     HostName 34.154.17.64
     LocalForward 16449 127.0.0.1:16443
     ```
* ssh [customer]
  * copy ZFS scripts to ~/zfs/
  * setup ZFS
  * setup [instance] -> [backup server] authentication
    * sudo su
    * ssh-keygen
    * copy id_rsa.pub to [backup server]
  * sudo snap install microk8s --classic
  * sudo usermod -a -G microk8s ubuntu
  * sudo chown -f -R ubuntu ~/.kube
  * newgrp microk8s
  * microk8s enable dns dashboard
  * microk8s kubectl create ns [customer]
  * microk8s kubectl create secret docker-registry regcred -n [customer] --docker-server=https://index.docker.io/v1/  --docker-username=osidorkin --docker-password=[password]
  * sudo apt install nginx
  * sudo systemctl start nginx
  * sudo snap install --classic certbot
  * sudo ln -s /snap/bin/certbot /usr/bin/certbot
  * copy instance like this
    * rsync --archive --recursive --links --perms --times --human-readable --progress [customer] [customer]/data/
  * fix /data/[customer]/olap-rust/site.yml
  ```
  - prefix: /
    scheme: http
    authority: localhost:9090 => authority: server:9090
    ```
  * fix /etc/nginx/sites-enabled/default
    * remove block like this:
    ```
      listen 443 ssl; # managed by Certbot
      ssl_certificate /etc/letsencrypt/live/kesko.goalprofit.com/fullchain.pem; # managed by Certbot
      ssl_certificate_key /etc/letsencrypt/live/kesko.goalprofit.com/privkey.pem; # managed by Certbot
      include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbo
      ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    ```

  * replace it by this:
  ```
    listen 80;
  ```
* append record in DNS https://dash.cloudflare.com
* issue SSL certificate:
  * sudo certbot --nginx
  * enter email
* install helm chart



