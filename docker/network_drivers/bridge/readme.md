# docker command
Note:
> docker network for Mac:https://docs.docker.com/docker-for-mac/networking/

Note for Mac:
> Docker 在 Mac 中的实现是通过 Hypervisor 创建一个轻量级的虚拟机，然后 将 docker 放入到虚拟机中实现。Mac OS 宿主机和 Docker 中的容器通过 /var/run/docker.sock 这种 socket 文件来通信，所以在 Mac OS 中 ping 容器的 IP，在容器中 ping 宿主机的 IP 就不通。

Mac 宿主机 和 容器互通 的解决方案
> 容器内访问宿主机，在 Docker 18.03 过后推荐使用 特殊的 DNS 记录 host.docker.internal 访问宿主机。但是注意，这个只是在 Docker Desktop for Mac 中作为开发时有效。 网关的 DNS 记录: gateway.docker.internal。


## build docker image
````shell
docker build -t python_web -f docker_file/Dockerfile .    
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