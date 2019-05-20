microservice example with jhipster on vagrant.
==========================================================================

# Features
```
	1. run apps out of docker
	    1) make gateway with jhipster
	    2) make jhipster-registry
	    3) test to run this gateway app.
	    4) make member apps with jhipster
	    5) make wallet apps with jhipster
	    6) check all services
	    7) kill all process
	2. run apps with docker-compose
```

# Execution
```
	vagrant up
	#vagrant destroy -f && vagrant up
	vagrant ssh
```

# Check services
```
	registry: curl http://192.168.82.170:8761
	gateway: curl http://192.168.82.170:8080/admin/gateway
	# admin / admin
	member: curl http://192.168.82.170:8081
	wallet: curl http://192.168.82.170:8082

	# when running with docker
	elasticsearch: http://192.168.82.170:5601
```




