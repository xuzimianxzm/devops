
## build Image
docker build -t java_web  .  

## run java_web
docker run -it --name java_web  -p 8080:8080/tcp  -d java_web