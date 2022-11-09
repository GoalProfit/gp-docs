instance_id=$1

if [[ -z $instance_id ]]; then
  echo instance id should be specified like
  echo "  3-zfs-instance-append.sh [instance_id]"
  exit 1
fi

sudo -s <<EOF

zfs create data/$instance_id
chown -R ubuntu:ubuntu /data/$instance_id
echo "
[data/$instance_id]
  use_template = production" >> /etc/sanoid/sanoid.conf

EOF