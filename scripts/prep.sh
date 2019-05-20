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

echo "##########################################"
echo "1) make swap memory"
echo "##########################################"
sudo free -m
sudo fallocate -l 3G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s

isInFile=$(cat /etc/fstab | grep -c "swapfile")
if [ $isInFile -eq 0 ]; then
	sudo sh -c "echo '/swapfile    swap    swap    defaults    1 1' >> /etc/fstab"
fi

cat /proc/cpuinfo | grep processor | wc -l

echo "##########################################"
echo "2) install jhipster"
echo "##########################################"
apt-get -y update
apt-get -y upgrade
apt-get install curl -y
apt-get install openjdk-8-jdk -y
apt-get install maven -y

curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs
node -v
npm -v

npm install -g yo
npm install -g generator-jhipster

echo "##########################################"
echo "3) install docker"
echo "##########################################"
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
#sudo systemctl status docker

echo "##########################################"
echo "4) install docker-compose"
echo "##########################################"
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

exit 0
