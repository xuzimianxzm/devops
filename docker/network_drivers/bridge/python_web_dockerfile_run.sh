#! /bin/bash

# Enter the current directory where the shell is located
cd `dirname $0`

# import common.sh 
source code/shell/common.sh

# excute function
runDockerFile python_web 8086