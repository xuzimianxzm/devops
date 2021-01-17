## 简介
Linux Namespace提供了一种内核级别隔离系统资源的方法，通过将系统的全局资源放在不同的Namespace中，来实现资源隔离的目的。不同Namespace的程序，可以享有一份独立的系统资源。目前Linux中提供了六类系统资源的隔离机制，分别是：

* Mount: 隔离文件系统挂载点
* UTS: 隔离主机名和域名信息
* IPC: 隔离进程间通信
* PID: 隔离进程的ID
* Network: 隔离网络资源
* User: 隔离用户和用户组的ID

## 使用
涉及到Namespace的操作接口包括clone()、setns()、unshare()以及还有/proc下的部分文件。为了使用特定的Namespace，在使用这些接口的时候需要指定以下一个或多个参数：

* CLONE_NEWNS: 用于指定Mount Namespace
* CLONE_NEWUTS: 用于指定UTS Namespace
* CLONE_NEWIPC: 用于指定IPC Namespace
* CLONE_NEWPID: 用于指定PID Namespace
* CLONE_NEWNET: 用于指定Network Namespace
* CLONE_NEWUSER: 用于指定User Namespace

### clone系统调用
可以通过clone系统调用来创建一个独立Namespace的进程，它的函数描述如下：
````C
int clone(int (*child_func)(void *), void *child_stack, int flags, void *arg);
````

> 它通过flags参数来控制创建进程时的特性，比如新创建的进程是否与父进程共享虚拟内存等。比如可以传入CLONE_NEWNS标志使得新创建的进程拥有独立的Mount Namespace，也可以传入多个flags使得新创建的进程拥有多种特性，比如：

````C
flags = CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC;
````
> 传入这个flags那么新创建的进程将同时拥有独立的Mount Namespace、UTS Namespace和IPC Namespace


## 通过/proc文件查看已存在的Namespace
在3.8内核开始，用户可以在/proc/$pid/ns文件下看到本进程所属的Namespace的文件信息。例如PID为2704进程的情况如下图所示：


其中4026531839是Namespace的ID，如果两个进程的Namespace ID相同表明进程同处于一个命名空间中。

这里需要注意的是：只/proc/$pid/ns/对应的Namespace文件被打开，并且该文件描述符存在，即使该PID所属的进程被销毁，这个Namespace会依然存在。可以通过挂载的方式打开文件描述符：
````
touch ~/mnt
mount --bind /proc/2704/mnt ~/mnt
````

## setns加入已存在的Namepspace
setns()函数可以把进程加入到指定的Namespace中，它的函数描述如下：
````c
int setns(int fd, int nstype);
````
它的参数描述如下：

* fd参数：表示文件描述符，前面提到可以通过打开/proc/$pid/ns/的方式将指定的Namespace保留下来，也就是说可以通过文件描述符的方式来索引到某个Namespace。
* nstype参数：用来检查fd关联Namespace是否与nstype表明的Namespace一致，如果填0的话表示不进行该项检查。
通过在程序中调用setns来将进程加入到指定的Namespace中。

## unshare脱离到新的Namespace
unshare()系统调用用于将当前进程和所在的Namespace分离，并加入到一个新的Namespace中，相对于setns()系统调用来说，unshare()不用关联之前存在的Namespace，只需要指定需要分离的Namespace就行，该调用会自动创建一个新的Namespace。

unshare()的函数描述如下：
````C
int unshare(int flags);
````
其中flags用于指明要分离的资源类别，它支持的flags与clone系统调用支持的flags类似，这里简要的叙述一下几种标志：

* CLONE_FILES: 子进程一般会共享父进程的文件描述符，如果子进程不想共享父进程的文件描述符了，可以通过这个* flag来取消共享。
* CLONE_FS: 使当前进程不再与其他进程共享文件系统信息。
* CLONE_SYSVSEM: 取消与其他进程共享SYS V信号量。
* CLONE_NEWIPC: 创建新的IPC Namespace，并将该进程加入进来。


## Mount Namespace
Mount namespace通过隔离文件系统挂载点对隔离文件系统提供支持，它是历史上第一个Linux namespace，所以它的标识位比较特殊，就是CLONE_NEWNS。隔离后，不同mount namespace中的文件结构发生变化也互不影响。你可以通过/proc/[pid]/mounts查看到所有挂载在当前namespace中的文件系统，还可以通过/proc/[pid]/mountstats看到mount namespace中文件设备的统计信息，包括挂载文件的名字、文件系统类型、挂载位置等等。

进程在创建mount namespace时，会把当前的文件结构复制给新的namespace。新namespace中的所有mount操作都只影响自身的文件系统，而对外界不会产生任何影响。这样做非常严格地实现了隔离，但是某些情况可能并不适用。比如父节点namespace中的进程挂载了一张CD-ROM，这时子节点namespace拷贝的目录结构就无法自动挂载上这张CD-ROM，因为这种操作会影响到父节点的文件系统。

2006 年引入的挂载传播（mount propagation）解决了这个问题，挂载传播定义了挂载对象（mount object）之间的关系，系统用这些关系决定任何挂载对象中的挂载事件如何传播到其他挂载对象{![参考自：http://www.ibm.com/developerworks/library/l-mount-namespaces/]}。所谓传播事件，是指由一个挂载对象的状态变化导致的其它挂载对象的挂载与解除挂载动作的事件。

> 共享关系（share relationship）。如果两个挂载对象具有共享关系，那么一个挂载对象中的挂载事件会传播到另一个挂载对象，反之亦然。

> 从属关系（slave relationship）。如果两个挂载对象形成从属关系，那么一个挂载对象中的挂载事件会传播到另一个挂载对象，但是反过来不行；在这种关系中，从属对象是事件的接收者。

一个挂载状态可能为如下的其中一种：
* 共享挂载（shared）
* 从属挂载（slave）
* 共享/从属挂载（shared and slave）
* 私有挂载（private）
* 不可绑定挂载（unbindable）

传播事件的挂载对象称为共享挂载（shared mount）；接收传播事件的挂载对象称为从属挂载（slave mount）。既不传播也不接收传播事件的挂载对象称为私有挂载（private mount）。另一种特殊的挂载对象称为不可绑定的挂载（unbindable mount），它们与私有挂载相似，但是不允许执行绑定挂载，即创建mount namespace时这块文件对象不可被复制。

![avatar](https://gitee.com/xuzimian/Image/raw/master/Linux/linu_mount_namespace.png)

### 挂载的概念
挂载的过程是通过mount系统调用完成的，它有两个参数：一个是已存在的普通文件名，一个是可以直接访问的特殊文件，一个是特殊文件的名字。这个特殊文件一般用来关联一些存储卷，这个存储卷可以包含自己的目录层级和文件系统结构。

mount所达到的效果是：像访问一个普通的文件一样访问位于其他设备上文件系统的根目录，也就是将该设备上目录的根节点挂到了另外一个文件系统的页节点上，达到给这个文件系统扩充容量的目的。

可以通过/proc文件系统查看一个进程的挂载信息，具体做法如下：
````
cat /proc/$pid/mountinfo
````

## Network namespace
Network namespace主要提供了关于网络资源的隔离，包括网络设备、IPv4和IPv6协议栈、IP路由表、防火墙、/proc/net目录、/sys/class/net目录、端口（socket）等等。一个物理的网络设备最多存在在一个network namespace中，你可以通过创建veth pair（虚拟网络设备对：有两端，类似管道，如果数据从一端传入另一端也能接收到，反之亦然）在不同的network namespace间创建通道，以此达到通信的目的。

> 一般情况下，物理网络设备都分配在最初的root namespace（表示系统默认的namespace，在PID namespace中已经提及）中。但是如果你有多块物理网卡，也可以把其中一块或多块分配给新创建的network namespace。需要注意的是，当新创建的network namespace被释放时（所有内部的进程都终止并且namespace文件没有被挂载或打开），在这个namespace中的物理网卡会返回到root namespace而非创建该进程的父进程所在的network namespace。       

> 当我们说到network namespace时，其实我们指的未必是真正的网络隔离，而是把网络独立出来，给外部用户一种透明的感觉，仿佛跟另外一个网络实体在进行通信。为了达到这个目的，容器的经典做法就是创建一个veth pair，一端放置在新的namespace中，通常命名为eth0，一端放在原先的namespace中连接物理网络设备，再通过网桥把别的设备连接进来或者进行路由转发，以此网络实现通信的目的。     

> 也许有读者会好奇，在建立起veth pair之前，新旧namespace该如何通信呢？答案是pipe（管道）。我们以Docker Daemon在启动容器dockerinit的过程为例。Docker Daemon在宿主机上负责创建这个veth pair，通过netlink调用，把一端绑定到docker0网桥上，一端连进新建的network namespace进程中。建立的过程中，Docker Daemon和dockerinit就通过pipe进行通信，当Docker Daemon完成veth-pair的创建之前，dockerinit在管道的另一端循环等待，直到管道另一端传来Docker Daemon关于veth设备的信息，并关闭管道。dockerinit才结束等待的过程，并把它的“eth0”启动起来。整个效果类似下图所示。
![avatar](https://gitee.com/xuzimian/Image/raw/master/Linux/network_namespace.png)


跟其他namespace类似，对network namespace的使用其实就是在创建的时候添加CLONE_NEWNET标识位。也可以通过命令行工具ip创建network namespace。在代码中建立和测试network namespace较为复杂，所以下文主要通过ip命令直观的感受整个network namespace网络建立和配置的过程。

首先我们可以创建一个命名为test_ns的network namespace。
````shell
ip netns add test_ns
````
当ip命令工具创建一个network namespace时，会默认创建一个回环设备（loopback interface：lo），并在/var/run/netns目录下绑定一个挂载点，这就保证了就算network namespace中没有进程在运行也不会被释放，也给系统管理员对新创建的network namespace进行配置提供了充足的时间。

通过ip netns exec命令可以在新创建的network namespace下运行网络管理命令。
````shell
ip netns exec test_ns ip link list
3: lo: <LOOPBACK> mtu 16436 qdisc noop state DOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
````
上面的命令为我们展示了新建的namespace下可见的网络链接，可以看到状态是DOWN,需要再通过命令去启动。可以看到，此时执行ping命令是无效的。
````shell
ip netns exec test_ns ping 127.0.0.1
connect: Network is unreachable
````
启动命令如下，可以看到启动后再测试就可以ping通。
````shell
ip link add veth0 type veth peer name veth1
ip link set veth1 netns test_ns
ip netns exec test_ns ifconfig veth1 10.1.1.1/24 up
ifconfig veth0 10.1.1.2/24 up
````
* 第一条命令创建了一个网络设备对，所有发送到veth0的包veth1也能接收到，反之亦然。
* 第二条命令则是把veth1这一端分配到test_ns这个network namespace。
* 第三、第四条命令分别给test_ns内部和外部的网络设备配置IP，veth1的IP为10.1.1.1，veth0的IP为10.1.1.2。

可以通过下面的命令查看，新的test_ns有着自己独立的路由和iptables。
````shell
ip netns exec test_ns route
ip netns exec test_ns iptables -L
````
路由表中只有一条通向10.1.1.2的规则，此时如果要连接外网肯定是不可能的，你可以通过建立网桥或者NAT映射来决定这个问题。

可以通过下面的命令删除这个network namespace:
````shell
ip netns delete netns1
````
这条命令会移除之前的挂载，但是如果namespace本身还有进程运行，namespace还会存在下去，直到进程运行结束。

通过network namespace我们可以了解到，实际上内核创建了network namespace以后，真的是得到了一个被隔离的网络。但是我们实际上需要的不是这种完全的隔离，而是一个对用户来说透明独立的网络实体，我们需要与这个实体通信。所以Docker的网络在起步阶段给人一种非常难用的感觉，因为一切都要自己去实现、去配置。你需要一个网桥或者NAT连接广域网，你需要配置路由规则与宿主机中其他容器进行必要的隔离，你甚至还需要配置防火墙以保证安全等等。所幸这一切已经有了较为成熟的方案，我们会在Docker网络部分进行详细的讲解。


