# Linux abstract network Device Introduction 
和磁盘设备类似，Linux 用户想要使用网络功能，不能通过直接操作硬件完成，而需要直接或间接的操作一个 Linux 为我们抽象出来的设备，既通用的 Linux 网络设备来完成。一个常见的情况是，系统里装有一个硬件网卡，Linux 会在系统里为其生成一个网络设备实例，如 eth0，用户需要对 eth0 发出命令以配置或使用它了。更多的硬件会带来更多的设备实例，虚拟的硬件也会带来更多的设备实例。随着网络技术，虚拟化技术的发展，更多的高级网络设备被加入了到了 Linux 中，使得情况变得更加复杂。

* Reference Link :https://www.ibm.com/developerworks/cn/linux/1310_xiawc_networkdevice/


## veth pair
veth 是虚拟以太网卡((Virtual Ethernet)的缩写。veth 设备总是成对的，所以称之为veth pair。顾名思义，veth-pair 就是一对的虚拟设备接口，和 tap/tun 设备不同的是，它都是成对出现的。一端连着协议栈，一端彼此相连着。veth pair 一端发送的数据会再另外一段接收。
![avatar](https://gitee.com/xuzimian/Image/raw/master/Linux/linux_veth_pair.png)
仅有veth pair设备,容器是无法访问外部网络的。因为从容器发出的数据包，实际上是进入了veth pair设备的协议栈。如果容器需要访问外部网络，需要使用网桥等技术将veth pair接受的数据包转发出去。
I

## Linux Bridge
Bridge（桥）是 Linux 上用来做 TCP/IP 二层协议交换的设备，与现实世界中的交换机功能相似。Bridge 设备实例可以和 Linux 上其他网络设备实例连接，既 attach 一个从设备，类似于在现实世界中的交换机和一个用户终端之间连接一根网线。当有数据到达时，Bridge 会根据报文中的 MAC 信息进行广播、转发、丢弃处理。

Linux bridge 与Linux上其他网络设备的区在于，普通的网络设备只有两端，从一端进来的数据会从另一端出去。Linux Bridge 则有多个端口数据可以从任何端口进来，进来之后从哪口出去取决于目的Mac地址，原理和物理交换机差不多。

Bridge 的这个特性让它可以接入其他的网络设备，比如物理设备、虚拟设备、VLAN 设备等。Bridge 通常充当主设备，其他设备为从设备，这样的效果就等同于物理交换机的端口连接了一根网线。比如下面这幅图通过 Bridge 连接两个 VM 的 tap 虚拟网卡和物理网卡 eth0。

![avatar](https://gitee.com/xuzimian/Image/raw/master/Linux/linux_bridge.png)

* 使用iproute2软件包的ip命令创建一个bridge
````sh
ip link add name br0 type bridge
ip link set br0 up
````

* 或使用bridge-utils 软件包里的brctl工具管理网络桥：
````sh
brctl addbr br0
````

刚创建的一个bridge时，它是一个独立的网络设备，只有一个端口连接着协议栈，其他端口什么都连接，这样的bridge其实没有任何实际功能。
````sh
+----------------------------------------------------------------+
|                                                                |
|       +------------------------------------------------+       |
|       |             Newwork Protocol Stack             |       |
|       +------------------------------------------------+       |
|              ↑                                ↑                |
|..............|................................|................|
|              ↓                                ↓                |
|        +----------+                     +------------+         |
|        |   eth0   |                     |     br0    |         |
|        +----------+                     +------------+         |
| 192.168.3.21 ↑                                                 |
|              |                                                 |
|              |                                                 |
+--------------|-------------------------------------------------+
               ↓
         Physical Network
````
> 这里假设eth0是我们的物理网卡，IP地址是192.168.3.21，网关是192.168.3.1  


创建一对veth设备，并配置上IP
````sh
sudo ip link add veth0 type veth peer name veth1
sudo ip addr add 192.168.3.101/24 dev veth0
sudo ip addr add 192.168.3.102/24 dev veth1
sudo ip link set veth0 up
sudo ip link set veth1 up
````
将veth0连上br0
````sh
sudo ip link set dev veth0 master br0
#通过bridge link命令可以看到br0上连接了哪些设备
sudo bridge link
6: veth0 state UP : <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2
````
这时候，网络就变成了这个样子:
````sh
+----------------------------------------------------------------+
|                                                                |
|       +------------------------------------------------+       |
|       |             Newwork Protocol Stack             |       |
|       +------------------------------------------------+       |
|            ↑            ↑              |            ↑          |
|............|............|..............|............|..........|
|            ↓            ↓              ↓            ↓          |
|        +------+     +--------+     +-------+    +-------+      |
|        | .3.21|     |        |     | .3.101|    | .3.102|      |
|        +------+     +--------+     +-------+    +-------+      |
|        | eth0 |     |   br0  |<--->| veth0 |    | veth1 |      |
|        +------+     +--------+     +-------+    +-------+      |
|            ↑                           ↑            ↑          |
|            |                           |            |          |
|            |                           +------------+          |
|            |                                                   |
+------------|---------------------------------------------------+
             ↓
     Physical Network
````
这里为了画图方便，省略了IP地址前面的192.168，比如.3.21就表示192.168.3.21

br0和veth0相连之后，发生了几个变化：

br0和veth0之间连接起来了，并且是双向的通道

协议栈和veth0之间变成了单通道，协议栈能发数据给veth0，但veth0从外面收到的数据不会转发给协议栈

br0的mac地址变成了veth0的mac地址

> 通过veth0 ping veth1失败：为什么veth0加入了bridge之后，就ping不通veth2了呢？问题就出在veth0收到应答包后没有给协议栈，而是给了br0，于是协议栈得不到veth1的mac地址，从而通信失败。给veth0配置IP没有意义，因为就算协议栈传数据包给veth0，应答包也回不来。这里我们就将veth0的IP让给bridge。

详细内容参考：https://segmentfault.com/a/1190000009491002

