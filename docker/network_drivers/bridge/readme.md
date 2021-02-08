# docker command

## build docker image
````shell
docker build -t python_web -f docker_file/Dockerfile .    
````

## run docker image
````shell
docker run -itd --name python_web -p 8080:80/tcp python_web
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