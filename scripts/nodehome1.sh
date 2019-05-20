sudo su
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

cd /vagrant/scripts
bash prep.sh
bash run_ood.sh
bash run_dc.sh

exit 0
