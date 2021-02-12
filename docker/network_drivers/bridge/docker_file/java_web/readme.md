
## build Image

````sh
# run command in the directory of docker/network_drivers/bridge
docker build -t java_web  -f docker_file/java_web/Dockerfile .     
````
## run java_web
docker run -it --name java_web  -p 8080:8080/tcp  -d java_web
