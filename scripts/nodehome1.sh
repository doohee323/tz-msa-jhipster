sudo su
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

export DEBIAN_FRONTEND=noninteractive

export USER=vagrant  # for vagrant
export HOME_DIR=/home/$USER
export PROJ_DIR=/vagrant

sudo sh -c "echo '' >> $HOME_DIR/.bashrc"
sudo sh -c "echo 'export PATH=$PATH:.' >> $HOME_DIR/.bashrc"
sudo sh -c "echo 'export HOME_DIR='$HOME_DIR >> $HOME_DIR/.bashrc"
source $HOME_DIR/.bashrc

##########################################
# install jhipster
##########################################
apt-get -y update
apt-get -y upgrade
apt-get install  -y

mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_ori
cp /vagrant/etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg 

sed -i "s/NODE1/$cfg_ip_node1/g" /etc/haproxy/haproxy.cfg
sed -i "s/NODE2/$cfg_ip_node2/g" /etc/haproxy/haproxy.cfg

##########################################
# restart services
##########################################
service rsyslog restart

exit 0
