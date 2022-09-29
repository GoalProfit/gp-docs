sudo -s <<EOF
cd /tmp
apt update
apt install zfsutils-linux debhelper libcapture-tiny-perl libconfig-inifiles-perl pv lzop mbuffer build-essential -y
git clone https://github.com/jimsalterjrs/sanoid.git
cd sanoid
git checkout $(git tag | grep "^v" | tail -n 1)
ln -s packages/debian .
dpkg-buildpackage -uc -us
apt install ../sanoid_*_all.deb
EOF
