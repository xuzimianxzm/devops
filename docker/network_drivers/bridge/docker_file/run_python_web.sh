#! /bin/bash

checkImages=$(docker images python_web)
if [[ $checkImages =~ 'python_web' ]]; then
    echo "=> python_web image existed then removed the image and rebuild it:"
    echo "=> removed the containers:"  $(docker rm -f python_web)
    echo "=> removed the images:"  $(docker rmi -f python_web)
else
    echo "=> python_web image dose not existed then build the image:"
fi

echo  $(docker build --force-rm -t python_web -f docker_file/python_web/Dockerfile .)

if [[ $checkImages =~ 'python_web' ]]; then
    echo "=> python_web build succeed and then run the image:"
else
    echo "=> python_web build failed and then exit!"
    exit -1
fi

echo "=>" $(docker run -it --name python_web  -p 8086:8080/tcp  -d python_web)