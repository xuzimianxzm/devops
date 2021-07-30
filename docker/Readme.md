# docker command
Note:
> docker network for Mac:https://docs.docker.com/docker-for-mac/networking/

## build docker image
````shell
# run command in the directory of docker/network_drivers/bridge
docker build --force-rm  -t python_web -f docker_file/python_web/Dockerfile .    
````

## run docker image

````shell
docker run -it --name python_web  -p 8086:8090/tcp  -d python_web
# other directly test examples
docker run -it --rm -p 8888:8080 -d tomcat:9.0
docker run --name mynginx1 -p 80:80 -d nginx
````

### Capabilities
> If you want have iptables access within your containers, you need to enable specific capabilities via the --cap-add=NET_ADMIN switch when running the container initially.

#### Example
````shell
$ docker run --cap-add=NET_ADMIN -it ubuntu:16.04
````
### --privileged 

Give extended privileges to this container

````shell
$ docker run --privileged  -it ubuntu:16.04
````

## Enter the docker container
````shell
docker exec -it <containerId> /bin/bash 
````
or
````shell
docker exec -it <containerId> /bin/sh 
````

* if an image fails TO run or build,you can run the following command to enter the system of container
````sh
docker run -it a94f06af6e4c /bin/sh
````
## Get the metadata of the container/image. 
````shell
docker inspect <containerId> | grep "IPAddress"
````
## docker history show specified image create list
docker history [OPTIONS] IMAGE

## You can quickly do that (in your DEVELOPMENT environment) using
docker stop $(docker ps -a -q) #stop ALL containers

## To now remove all containers, run
docker rm -f $(docker ps -a -q) # remove ALL containers