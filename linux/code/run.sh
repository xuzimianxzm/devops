#! /bin/bash
cd $(dirname $0)
chmod +x ./

imageName=ubuntu-system

echo "=> removed the containers named  $imageName:" $(docker rm -f $imageName)

echo "=> $imageName image existed then removed the image and rebuild it:"


docker build --force-rm  -t $imageName .

docker run --privileged --cap-add=NET_ADMIN -it --name $imageName -d $imageName ./veth_pair.sh

sleep 2

docker exec  -it $imageName /bin/sh