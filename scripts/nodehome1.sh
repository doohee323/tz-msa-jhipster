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
echo 1) install jhipster
##########################################
apt-get -y update
apt-get -y upgrade
apt-get install curl -y

curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install -y nodejs
node -v
npm -v

npm install -g yo
npm install -g generator-jhipster

cd /vagrant
##########################################
echo 2) make a gateway with jhipster
##########################################
mkdir -p gateway
cd gateway
echo "It's already made with jhipster cli, I'll just run npm install for here."
npm install

#root@nodehome1:/vagrant/gateway# jhipster
#? May JHipster anonymously report usage statistics to improve the tool over time? Yes
#? Which *type* of application would you like to create? Microservice gateway
#? What is the base name of your application? gateway
#? As you are running in a microservice architecture, on which port would like your server to run? It should be unique to avoid port conflicts. 8080
#? What is your default Java package name? com.mycompany.myapp
#? Which service discovery server do you want to use? JHipster Registry (uses Eureka, provides Spring Cloud Config support and monitoring dashboards)
#? Which *type* of authentication would you like to use? JWT authentication (stateless, with a token)
#? Which *type* of database would you like to use? SQL (H2, MySQL, MariaDB, PostgreSQL, Oracle, MSSQL)
#? Which *production* database would you like to use? MySQL
#? Which *development* database would you like to use? H2 with disk-based persistence
#? Do you want to use the Spring cache abstraction? Yes, with the Ehcache implementation (local cache, for a single node)
#? Do you want to use Hibernate 2nd level cache? Yes
#? Would you like to use Maven or Gradle for building the backend? Maven
#? Which other technologies would you like to use? Search engine using Elasticsearch
#? Which *Framework* would you like to use for the client? Angular
#? Would you like to use a Bootswatch theme (https://bootswatch.com/)? Default JHipster
#? Would you like to enable internationalization support? No
#? Besides JUnit and Jest, which testing frameworks would you like to use? (Press <space> to select, <a> to toggle all, <i> to invert selection)
#? Would you like to install other generators from the JHipster Marketplace? No




mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_ori
cp /vagrant/etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg 

sed -i "s/NODE1/$cfg_ip_node1/g" /etc/haproxy/haproxy.cfg
sed -i "s/NODE2/$cfg_ip_node2/g" /etc/haproxy/haproxy.cfg

##########################################
# restart services
##########################################
service rsyslog restart

exit 0
