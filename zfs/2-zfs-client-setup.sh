disk_id=$1

disks_ext="$(lsblk --paths --list --output name,fstype,fssize,size|grep -v 'squashfs\|ext4')"
disks=$(echo "$disks_ext"|tail -n +2|cut -d' ' -f1)

if [[ -z $disk_id ]]; then
  echo disk id should be specified like
  echo "  2-zfs-client-setup.sh [disk_id]"
  echo available disks:
  echo "$disks_ext"
  exit 1
fi

result=($(echo "$disks"|grep "^$disk_id$"))
disks_found=${#result[@]}

echo $disks_found

if [[ $disks_found -lt 1 ]]; then
  echo no ne disk match to the specified disk \($disk_id\)
  echo available disks:
  echo "$disks_ext"
  exit 1
fi

sudo -s <<EOF
zpool create data $disk_id

(crontab -l; echo "*,30 * * * * /usr/bin/flock -n /var/run/syncoid-data.lock /usr/sbin/syncoid --recursive --skip-parent data root@zh1520b.rsync.net:data1")|crontab -

bash -c "echo '
[template_production]
  frequently = 100
  hourly = 100
  daily = 7
  monthly = 0
  yearly = 0
  autosnap = yes
  autoprune = yes
  frequent_period = 15
' >> /etc/sanoid/sanoid.conf"

systemctl enable sanoid.timer
systemctl start sanoid.timer
EOF
