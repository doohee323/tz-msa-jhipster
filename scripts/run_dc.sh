sudo su
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

cd /vagrant
mkdir -p wallet-app-compose
cd wallet-app-compose

# Fyi, you can follow these selections for jhipster Microservice app.
# $ jhipster docker-compose
#? Which *type* of application would you like to deploy? Microservice application
#? Which *type* of gateway would you like to use? JHipster gateway based on Netflix Zuul
#? Enter the root directory where your gateway(s) and microservices are located ../
#3 applications found at /vagrant/

#? Which applications do you want to include in your configuration? gateway, member, wallet
#? Do you want to setup monitoring for your applications ? Yes, for logs and metrics with the JHipster Console (based on ELK and Zipkin)
#? You have selected the JHipster Console which is based on the ELK stack and additional technologies, which one do you want to use ? Curat
#or, to help you curate and manage your Elasticsearch indices
#JHipster registry detected as the service discovery and configuration provider used by your apps
#? Enter the admin password used to secure the JHipster Registry admin

sed -i s/v5.0.0/v5.0.1/g jhipster-registry.yml

docker-compose up -d
docker images
docker ps

# docker container exec -u 0 -it wallet-app-compose_gateway-app_1_5e40fa42bfcf bash

exit 0
