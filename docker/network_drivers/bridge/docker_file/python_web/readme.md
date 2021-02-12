## build docker image
````shell
# run command in the directory of docker/network_drivers/bridgels
docker build -t python_web -f docker_file/python_web/Dockerfile .    
````

## run docker image
````shell
docker run -it --name python_web  -p 8086:8090/tcp  -d python_web