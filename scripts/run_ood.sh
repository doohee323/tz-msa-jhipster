sudo su
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

echo "##########################################"
echo "1) make gateway with jhipster"
echo "##########################################"
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

echo "##########################################"
echo "2) make jhipster-registry"
echo "##########################################"
cd /vagrant/gateway
docker-compose -f src/main/docker/jhipster-registry.yml up -d
echo registry: curl http://192.168.82.170:8761
# admin / admin

echo "##########################################"
echo "3) test to run this gateway app"
echo "##########################################"
cd /vagrant/gateway
pcnt=`ps -ef | grep -v grep | grep "vagrant/gateway" | wc -l | awk '{print $2}'`
if [[ $pcnt > 0 ]]; then
	pid=`ps -ef | grep -v grep | grep "vagrant/gateway" | awk '{print $2}'`
	kill -9 ${pid} 
fi
nohup ./mvnw -Pdev -DskipTests >/dev/null 2>&1 &
echo "making gateway's docker image"
./mvnw package -Pdev -DskipTests verify jib:dockerBuild &

echo "##########################################"
echo "4) make member apps with jhipster"
echo "##########################################"
cd /vagrant
mkdir -p member
cd /vagrant/member
npm install

# Fyi, you can follow these selections for jhipster Microservice app.
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

pcnt=`ps -ef | grep -v grep | grep "vagrant/member" | wc -l | awk '{print $2}'`
if [[ $pcnt > 0 ]]; then
	pid=`ps -ef | grep -v grep | grep "vagrant/member" | awk '{print $2}'`
	kill -9 ${pid} 
fi
nohup ./mvnw -Pdev -DskipTests >/dev/null 2>&1 &
echo "making member docker image"
./mvnw package -Pdev -DskipTests verify jib:dockerBuild &

echo "##########################################"
echo "5) make wallet apps with jhipster"
echo "##########################################"
cd /vagrant
mkdir -p wallet
cd /vagrant/wallet
npm install
pcnt=`ps -ef | grep -v grep | grep "vagrant/wallet" | wc -l | awk '{print $2}'`
if [[ $pcnt > 0 ]]; then
	pid=`ps -ef | grep -v grep | grep "vagrant/wallet" | awk '{print $2}'`
	kill -9 ${pid} 
fi
nohup ./mvnw -Pdev -DskipTests >/dev/null 2>&1 &
echo "making wallet docker image"
./mvnw package -Pdev -DskipTests verify jib:dockerBuild &

echo "##########################################"
echo "5) make jhipster-uaa with jhipster"
echo "##########################################"
cd /vagrant
mkdir -p jhuaa
cd /vagrant/jhuaa
npm install

# Fyi, you can follow these selections for jhipster Microservice app.
#root@nodehome1:/vagrant/jhuaa# jhipster
#? Which *type* of application would you like to create? JHipster UAA server (for microservice OAuth2 authentication)
#? What is the base name of your application? jhuaa
#? As you are running in a microservice architecture, on which port would like your server to run? It should be unique to avoid port conflicts. 9999
#? What is your default Java package name? com.mycompany.myapp
#? Which service discovery server do you want to use? JHipster Registry (uses Eureka, provides Spring Cloud Config support and monitoring dashboards)
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

pcnt=`ps -ef | grep -v grep | grep "vagrant/jhuaa" | wc -l | awk '{print $2}'`
if [[ $pcnt > 0 ]]; then
	pid=`ps -ef | grep -v grep | grep "vagrant/jhuaa" | awk '{print $2}'`
	kill -9 ${pid} 
fi
nohup ./mvnw -Pdev -DskipTests >/dev/null 2>&1 &
echo "making wallet docker image"
./mvnw package -Pdev -DskipTests verify jib:dockerBuild &

echo "##########################################"
echo "6) check all services"
echo "##########################################"
sleep 300
echo registry: curl http://192.168.82.170:8761
echo gateway: curl http://192.168.82.170:8080/admin/gateway
# admin / admin
echo member: curl http://192.168.82.170:8081
echo wallet: curl http://192.168.82.170:8082

echo "##########################################"
echo "7) kill all process"
echo "##########################################"
sleep 300
pid=`ps -ef | grep -v grep | grep "vagrant/gateway" | awk '{print $2}'`
kill -9 ${pid} 

pid=`ps -ef | grep -v grep | grep "vagrant/member" | awk '{print $2}'`
kill -9 ${pid} 

pid=`ps -ef | grep -v grep | grep "vagrant/wallet" | awk '{print $2}'`
kill -9 ${pid} 

pid=`docker ps | grep "jhipster-registry" | awk '{print $1}'`
docker stop ${pid}

#mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_ori
#cp /vagrant/etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg

#sed -i "s/NODE1/$cfg_ip_node1/g" /etc/haproxy/haproxy.cfg
#sed -i "s/NODE2/$cfg_ip_node2/g" /etc/haproxy/haproxy.cfg

exit 0
