# Vxlan

## 1. 原理

Vxlan的目的是：creating vritual L2 network over physical L3 network。这也间接说明了VTEP的ip必须是一个网段的。

Vxlan报文如下所示：

![Vxlan报文](./vnet-vxlan.png)

## 2. 实验

**实验环境**：Mac, [Vagrant](https://www.vagrantup.com/intro/index.html) 

从内核3.12版本开始对vxlan的支持才比较完整，下面的实验选择了新版本的内核ubuntu16（ubuntu 14的ip link命令不支持dstport）

```
When VXLAN was first implemented in Linux 3.7, the UDP port to use was not defined. Several vendors were using 8472 and Linux took the same value. To avoid breaking existing deployments, this is still the default value. Therefore, if you want to use the IANA-assigned port, you need to explicitely set it with dstport 4789.
```

通过这个[Vagrantfile](https://gist.githubusercontent.com/hex108/758140f784182286f4527566073bd5f9/raw/9898be998d82e4a4297fef477427e8de3972d2f2/vagrantfile-for-vxlan-test-env)创建有三个节点(安装vagrant，创建一个目录，将该Vagrant文件放进去，然后执行vagrant up即可)，下面的实验都将使用这三个节点。

### 2.1 点对点的 vxlan 

![vxlan1](https://ws1.sinaimg.cn/large/006tKfTcgy1fjy54027bgj31hc0u0tde.jpg)

分别在node0和node1创建点对点的vxlan设备（VTEP）

```no
root@node0# ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    remote 192.168.8.101 \
    local 192.168.8.100 \
    dev enp0s8
root@node0# ip addr add 10.20.1.2/24 dev vxlan0
root@node0# ip link set vxlan0 up
```

```
root@node1# ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    remote 192.168.8.100 \
    local 192.168.8.101 \
    dev enp0s8 
root@node1# ip addr add 10.20.1.3/24 dev vxlan0
root@node1# ip link set vxlan0 up
```

enp0s8为local后面那个ip所对应的网卡？想知道enp0s8为什么这么命名，可以看看[Understanding systemd’s predictable network device names](https://major.io/2015/08/21/understanding-systemds-predictable-network-device-names/)。

现在我们可以在node0上ping 10.20.1.3这个ip了：

```
root@node0:~# ping 10.20.1.3
PING 10.20.1.3 (10.20.1.3) 56(84) bytes of data.
64 bytes from 10.20.1.3: icmp_seq=1 ttl=64 time=0.675 ms
64 bytes from 10.20.1.3: icmp_seq=2 ttl=64 time=0.719 ms
```

同时，我们可以通过`tcpdump -i enp0s8`查看vxlan包：

```
root@node0:~# tcpdump -i enp0s8
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
15:04:03.200902 IP 172.28.128.3.51042 > 172.28.128.4.4789: VXLAN, flags [I] (0x08), vni 42
ARP, Request who-has 10.20.1.3 tell 10.20.1.2, length 28
15:04:03.201379 IP 172.28.128.4.43593 > 172.28.128.3.4789: VXLAN, flags [I] (0x08), vni 42
ARP, Reply 10.20.1.3 is-at c6:3d:f6:4d:16:2d (oui Unknown), length 28
15:04:03.201503 IP 172.28.128.3.53381 > 172.28.128.4.4789: VXLAN, flags [I] (0x08), vni 42
IP 10.20.1.2 > 10.20.1.3: ICMP echo request, id 2098, seq 1, length 64
```

如果要更详细地过滤，可以使用下面的命令(见：https://github.com/the-tcpdump-group/tcpdump/issues/611，https://www.wains.be/pub/networking/tcpdump_advanced_filters.txt)：

`tcpdump -l -n -i <if> 'port 4789 and udp[8:2] = 0x0800 & 0x0800 and udp[11:4] = <vni> & 0x00FFFFFF'`

该命令的的几个参数解释：udp[8:2]表示udp包的第8字节（字节数从0开始）开始的2个字节，即第8字节和第9字节，这正是VXLAN flags，根据[RFC7348](https://tools.ietf.org/html/rfc7348)可知，该值为0x0800；udp[11:4]表示udp包的第11字节开始的4个字节，正是VNI的值。

## 2.2 多播模式的 vxlan

![multicast-vlan](https://ws1.sinaimg.cn/large/006tKfTcgy1fjy54jqv9xj31hc0u0n2d.jpg)

分别在node0、node1、node2创建多播的vxlan设备（VTEP）

```
root@node0# ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    group 239.1.1.1 \
    dev enp0s8 
root@node0# ip addr add 10.20.1.2/24 dev vxlan0
root@node0# ip link set vxlan0 up
```

在node1和node2上执行类似的命令，将第二条中的`ip addr add`里的ip地址改为`10.20.1.3/24`(node2)和`10.20.1.4/24`。

现在我们可以在node0上ping 10.20.1.3和10.20.1.4这两个ip了。

### 2.3 ToAdd 

-------------

**注**：本文主要参考https://cizixs.com/2017/09/28/linux-vxlan/。

## 3. 参考资料

- Vxlan内核文档：https://www.kernel.org/doc/Documentation/networking/vxlan.txt
- VXLAN Series: https://blogs.vmware.com/vsphere/2013/04/vxlan-series-different-components-part-1.html
- vxlan 协议原理简介: http://cizixs.com/2017/09/25/vxlan-protocol-introduction/
- linux 上实现 vxlan 网络: https://cizixs.com/2017/09/28/linux-vxlan/
- VXLAN & Linux: https://vincent.bernat.ch/en/blog/2017-vxlan-linux
- Flannel对vxlan的支持：https://github.com/coreos/flannel/blob/master/backend/vxlan/vxlan.go
- RFC7348 for vxlan: https://tools.ietf.org/html/rfc7348
- tcpdump advanced filters: https://www.wains.be/pub/networking/tcpdump_advanced_filters.txt
- What are the ARP and FDB tables?: https://blog.michaelfmcnamara.com/2008/02/what-are-the-arp-and-fdb-tables/