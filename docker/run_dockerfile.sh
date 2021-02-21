#! /bin/bash

# Enter the current directory where the shell is located
cd $(dirname $0)

# import common.sh
source code/shell/common.sh

imageName=$1
port=$2

if [[ -z $imageName ]]; then
    read  -p "pless typing you want run image name: " input
    imageName=$input
fi


if [[ -z $port ]]; then
    read  -p "pless typing you want run web port: " input
    port=$input
fi

# excute function
runDockerFile "$imageName" "$port"
