# docker-jboss-eap

The `docker-jboss-eap` image provides a Docker container for running JBoss EAP server 
based on [jboss/base-jdk](https://hub.docker.com/r/jboss/base-jdk/) official image.

This container is provided with a full JBoss EAP installation.

## Usage

Start a JBoss EAP instance as follows (using docker-compose.yml file):

	# My docker-compose.yml file
	
	# JBoss EAP 5.2
	jbosseap:
	  image: jmmoreno/jboss-eap:5.2
	  container_name: jboss-eap-myconf
	  #network_mode: default
	  command: jboss-eap myconf
	  extra_hosts:
	  - my_database:192.168.0.4
	  #hostname: mypersodomain.com
	  #volumes:
	  #- 
	  environment:
	  - JAVA_OPTS_MEM=-Xms1024m -Xmx2048m -XX:MaxPermSize=256m
	  - JAVA_OPTS_EXTRA=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8787 -Dfile.encoding=UTF-8
	  - JAVA_OPTS_BIND_ADD=0.0.0.0
	  #- JAVA_OPTS_PORTS=-Djboss.service.binding.set=ports-01
	  ports:
	  - 1098:1098
	  - 1099:1099
	  - 3873:3873
	  - 4446:4446
	  - 4444:4444
	  - 4445:4445
	  - 4712:4712
	  - 4713:4713
	  - 8009:8009
	  - 8080:8080
	  - 8083:8083
	  - 8787:8787

## Configuration (environment variables)

When you start the JBoss EAP image, you can adjust the configuration of the instance by 
passing one or more environment variables on the docker run command line. 

	JAVA_OPTS_MEM

Variable to	define the memory allowed to use the server.

	JAVA_OPTS_EXTRA
	
Variable to define all extra configuration for JVM.
	
	JAVA_OPTS_BIND_ADD
	
Binds the ServerSocket to a specific address (IP address).
	
	JAVA_OPTS_PORTS
	
Start JBoss with the VM parameter jboss.service.binding.set set to either 
ports-default, ports-01, ports-02 etc

## Start an specific server configuration

The entrypoint of this image is a script that require one parameter used to define 
the server configuration to be launched.
When you start the container, you need to specify the **configuration name**

In the previous example, the configuration used is called **myconf**. 
You can use JBoss specific configurations like **defaul**, **test**, **production**, ...

## Data persistence

If you want to make your data persistent, you need to mount a volume.
The first start of this container, could be a clean JBoss configuration using **myconf**.

When the server is started (watching logs...):

	docker logs -t --tail=100 jboss-eap-myconf
	
`jboss-eap-myconf | 11:48:53,346 INFO  [Http11Protocol] Starting Coyote HTTP/1.1 on http-0.0.0.0-8080`

`jboss-eap-myconf | 11:48:53,365 INFO  [AjpProtocol] Starting Coyote AJP/1.3 on ajp-0.0.0.0-8009`

`jboss-eap-myconf | 11:48:53,374 INFO  [ServerImpl] JBoss (Microcontainer) [5.2.0 (build: SVNTag=JBPAPP_5_2_0 date=201211232041)] Started in 14s:768ms`


the server configuration folder could be copied from container to host and
then could be used as a **volume**. To do these:

	docker cp jboss-eap-myconf:/opt/jboss/eap-5.2/jboss-as/server/myconf/ <PATH_INTO_HOST>
	
When the folder is copied, you only need to mount the volume, adding the following lines
to the docker-compose.yml file used previously:

	volumes:
	  - <PATH_INTO_HOST>/myconf:/opt/jboss/eap-5.2/jboss-as/server/myconf
	  
After that, recreate the container using your own and persisted data!


