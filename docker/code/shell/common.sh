#! /bin/bash

function runDockerFile() {
    imageName=$1
    port=$2
    checkParameter "$imageName" "Please input image name in the first parameter"
    checkParameter "$port" "Please input web port in the second parameter"

    removedImage $imageName

    buildImage $imageName

    runImage $port
}

function removedImage() {
    checkImages=$(docker images $imageName)
    
    if [[ $checkImages =~ $imageName ]]; then
        echo "=> $imageName image existed then removed the image and rebuild it:"
        echo "=> removed the containers named  $imageName:" $(docker rm -f $imageName)
        echo "=> removed the images named $imageName:" $(docker rmi -f $imageName)
    else
        echo "=> $imageName image dose not existed then build the image:"
    fi
}

function buildImage() {
    echo $(docker build --force-rm -t $imageName -f docker_file/$imageName/Dockerfile .)

    checkImages=$(docker images $imageName)
    if [[ $checkImages =~ $imageName ]]; then
        echo "=> $imageName build succeed and then run the image:"
    else
        echo "=> $imageName build failed and then exit!"
        exit -1
    fi
}

function runImage() {
    echo "=>" $(docker run -it --name $imageName -p $port:8080/tcp -d $imageName)
}

function checkParameter() {
    if [[ -z $1 ]]; then
        echo 'error:' $2
        exit -1
    fi
}
