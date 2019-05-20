sudo su
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

##########################################
echo 1) make gateway with jhipster
##########################################
cd /vagrant
mkdir -p gateway
cd /vagrant/gateway
echo "It's already made with jhipster cli, I'll just run npm install for here."
npm install

# fyi, you can follow these selections for jhipster gateway app.
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

##########################################
echo 1) make jhipster-registry
##########################################
cd /vagrant/gateway
docker-compose -f src/main/docker/jhipster-registry.yml up -d
curl http://192.168.82.170:8761
# admin / admin

##########################################
echo 1) test to run this gateway app.
##########################################
cd /vagrant/gateway
nohup ./mvnw -Pdev -DskipTests >/dev/null 2>&1 &
#sleep 60
#pid=`ps -ef | grep -v grep | grep "gateway/.mvn" | awk '{print $2}'`
#kill -9 ${pid} 

curl http://192.168.82.170:8080/admin/gateway
# admin / admin

##########################################
echo 2) make two apps with jhipster
##########################################
cd /vagrant
mkdir -p member
mkdir -p wallet
cd /vagrant/member

# fyi, you can follow these selections for jhipster Microservice app.
# member: 8081, wallet: 8082
#root@nodehome1:/vagrant/member# jhipster
#? Which *type* of application would you like to create? Microservice application
#? What is the base name of your application? member
#? As you are running in a microservice architecture, on which port would like your server to run? It should be unique to avoid port conflicts. 8081
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
#? Would you like to enable internationalization support? No
#? Besides JUnit and Jest, which testing frameworks would you like to use? (Press <space> to select, <a> to toggle all, <i> to invert selection)
#? Would you like to install other generators from the JHipster Marketplace? No

nohup ./mvnw -Pdev -DskipTests >/dev/null 2>&1 &
sleep 60
#pid=`ps -ef | grep -v grep | grep "member/.mvn" | awk '{print $2}'`
#kill -9 ${pid} 

mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_ori
cp /vagrant/etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg 

sed -i "s/NODE1/$cfg_ip_node1/g" /etc/haproxy/haproxy.cfg
sed -i "s/NODE2/$cfg_ip_node2/g" /etc/haproxy/haproxy.cfg

##########################################
# restart services
##########################################
service rsyslog restart

exit 0
