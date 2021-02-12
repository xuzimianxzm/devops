# docker command
Note:
> docker network for Mac:https://docs.docker.com/docker-for-mac/networking/

## build docker image
````shell
# run command in the directory of docker/network_drivers/bridgels
docker build -t python_web -f docker_file/python_web/Dockerfile .    
````

## run docker image
````shell
docker run -it --name python_web  -p 8086:8090/tcp  -d python_web

# other directly test examples
docker run -it --rm -p 8888:8080 -d tomcat:9.0
docker run --name mynginx1 -p 80:80 -d nginx
````

## Enter the docker container
````shell
docker exec -it <containerId> /bin/bash 
````
or
````shell
docker exec -it <containerId> /bin/sh 
````

## Get the metadata of the container/image. 
````shell
docker inspect <containerId> | grep "IPAddress"
````
## docker history show specified image create list
docker history [OPTIONS] IMAGE