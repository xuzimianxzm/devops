# MacOS Command

## networksetup Command

It is used to configure a client’s network settings.

###  networksetup -listallhardwareports

Display list of hardware ports with corresponding device name and ethernet address.

### networksetup -listnetworkserviceorder

Display services with corresponding port and device in order they are tried for connecting
to a network. An asterisk (*) denotes that a service is disabled

## brctl Command

## netstat command and lsof Command

difference
* netstat无权限控制，lsof有权限控制，只能看到本用户
* losf能看到pid和用户，可以找到哪个进程占用了这个端口

### netstat 

作用：显示各种网络相关信息

1. 其他用法：netstat -l
   作用：列出本机进行监听的端口

2. 其他用法：netstat -lt
   作用：只列出tcp的连接，同理在l后面跟上u的话，将会列出各种udp的监听端口
  
3. 其他用法：netstat -s
   作用：查看统计数据

4. 其他用法：netstat -p
   作用：列出进程信息，你可以了解是哪一个程序在哪一个端口上做些什么事情

5. 其他用法：netstat -pc
   作用：会显示出实时更新的进程信息

6. 其他用法：netstat -r
   作用：查看路由表

6. 其他用法：netstat -v
   作用：显示正在进行的工作

## MacOS Docker work on HyperKit,VPNKit and DataKit

* HyperKit：OSX上运行的轻量级虚拟化工具包
* DataKit：现代化分布式组件框架
* VPNKit：嵌入式虚拟网络库
  
more detail you can look the link reference: https://www.docker.com/blog/docker-unikernels-open-source/


![avatar](https://gitee.com/xuzimian/Image/raw/master/MacOS/docker_framwork_for_mac_os.jpg)

--------

> Mac 无法原生支持 Docker ，所以 Mac 下的 Docker 是运行在原生虚拟技术 HyperKit 之上的一台 Linux 系统。在一些特殊情况下，如果你想访问这台系统，可以使用以下方法：
````sh
screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty
````

## Docker on MacOS

more detail you can look the link reference: https://docs.docker.com/docker-for-mac/networking/


### Known limitations, use cases, and workarounds
Following is a summary of current limitations on the Docker Desktop for Mac networking *stack, along with some ideas for workarounds.

* There is no docker0 bridge on macOS
> Because of the way networking is implemented in Docker Desktop for Mac, you cannot see a docker0 interface on the host. This interface is actually within the virtual machine.

* I cannot ping my containers
> Docker Desktop for Mac can’t route traffic to containers.

* Per-container IP addressing is not possible
> The docker (Linux) bridge network is not reachable from the macOS host.