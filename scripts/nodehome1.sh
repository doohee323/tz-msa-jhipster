sudo su
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

cd /vagrant/scripts
bash prep.sh
bash run_ood.sh
bash run_dc.sh

#mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_ori
#cp /vagrant/etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg

#sed -i "s/NODE1/$cfg_ip_node1/g" /etc/haproxy/haproxy.cfg
#sed -i "s/NODE2/$cfg_ip_node2/g" /etc/haproxy/haproxy.cfg

exit 0
