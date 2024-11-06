# 1. Create VM

console.cloud.google.com > Compute Engine > VM Instances > Create Instance
* name=[customer_id]
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
  * Name=[customer_id]-data
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
   Host [customer_id]
     User ubuntu
     HostName 34.154.17.64
     LocalForward 16449 127.0.0.1:16443
     ```
* ssh [customer_id]
  * setup max map file count
    * open file `/etc/sysctl.conf`
    * append line: `vm.max_map_count=1000000`
    * apply changes: `sudo sysctl -p`
  * setup max number of opened files
    * open file `/etc/security/limits.conf`
    * append line: `* soft nofile 524288`
    * append line: `* hard nofile 524288`
    * open file `/etc/pam.d/common-session`
    * append line `session required pam_limits.so`
    * apply changes: `sudo sysctl -p --system` or relogin
    * check result with `ulimit -n`
  * copy ZFS scripts to ~/zfs/
  * [setup ZFS](../zfs) (if zfs step skipped we have to create folder /data/[customer_id] manualy)
  * setup [instance] -> [backup server] authentication (optionaly)
    * sudo su
    * ssh-keygen
    * copy id_rsa.pub to [backup server]
  * sudo snap install microk8s --classic --channel=1.30
  * sudo usermod -a -G microk8s ubuntu
  * sudo chown -f -R ubuntu ~/.kube
  * newgrp microk8s
  * microk8s enable dns dashboard hostpath-storage
  * microk8s kubectl create ns [customer_id]
  * setup max number of opened files for microk8s pods
    * open /var/snap/microk8s/current/args/containerd-env
    * fix line `ulimit -n 65536` to `ulimit -n 524288`
  * setup max number of pods in cluster
    * open /var/snap/microk8s/current/args/kubelet
    * append line `--max-pods=200`
  * restart microk8s
    * `microk8s stop`
    * `microk8s start`
  * sudo apt install -y nginx apache2-utils
  * sudo systemctl start nginx
  * sudo snap install --classic certbot
  * sudo ln -s /snap/bin/certbot /usr/bin/certbot
  * fix /etc/nginx/sites-enabled/default
    * remove block like this (customer_port should be the same as in option proxy.port in helm chart ):
    ```
server {
  server_name [customer].goalprofit.com;
  location / {
    try_files /nonexistent @$http_upgrade;
  }
  location @ {
    proxy_pass http://localhost:[customer_port];
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_read_timeout 600;
  }
  location @websocket {
    proxy_pass http://localhost:[customer_port];
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_set_header Host $host;
    proxy_read_timeout 600;
  }
  client_max_body_size 200M;
  listen 80;
}
    ```
  * `sudo nginx -s reload`

* append record in DNS. For example on https://dash.cloudflare.com
* issue SSL certificate:
  * sudo certbot --nginx
  * enter email
* register instance in miracl (https://miracl.com/) and store [miracl_client_id] and [miracl_client_secret]
* create secrets:
  * secret for pulling from docker hub
    `microk8s kubectl --namespace [customer_id] create secret docker-registry regcred --docker-server=https://index.docker.io/v1/  --docker-username=dockerhub_user --docker-password=dockerhub_password`
  * secret for service principal with admin privelegies:
    `microk8s kubectl --namespace [customer_id] create secret generic secret-admin --from-literal=username=admin --from-literal=password=[admin_password]`
  * secret for service principal without admin privelegies:
    `microk8s kubectl --namespace [customer_id] create secret generic secret-service --from-literal=username=user --from-literal=password=[user_password]`
  * secret for miracl
    `microk8s kubectl --namespace [customer_id] create secret generic miracl-client --from-literal=id=[miracl_client_id] --from-literal=secret=[miracl_client_secret`
  * secret for session cookie:
    * create base64 string:
      `microk8s kubectl --namespace [customer_id] create secret generic cookie-session --from-literal=key=$(echo [random string]|base64)`
* install helm chart
* create default users in .htpasswd
    `cd /data/[customer_id]/data`
    `htpasswd -bB admin [admin_password]`
    `htpasswd -bB user [user_password]`



