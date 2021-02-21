#! /bin/bash

checkImages=$(docker images java_web)
if [[ $checkImages =~ 'java_web' ]]; then
    echo "=> java_web image existed then removed the image and rebuild it:"
    echo "=> removed the containers:" $(docker rm -f java_web)
    echo "=> removed the images:" $(docker rmi -f java_web)
else
    echo "=> java_web image dose not existed then build the image:"
fi

echo $(docker build --force-rm -t java_web -f docker_file/java_web/Dockerfile .)

if [[ $checkImages =~ 'java_web' ]]; then
    echo "=> java_web build succeed and then run the image:"
else
    echo "=> java_web build failed and then exit!"
    exit -1
fi

echo "=>" $(docker run -it --name java_web -p 8080:8080/tcp -d java_web)
