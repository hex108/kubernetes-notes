# Linux network interfaces

## Bridge

```
Linux bridge is a layer 2 virtual device that on its own cannot receive or transmit anything unless you bind one or more real devices to it. 

It forwards packets between interfaces that are connected to it. It’s usually used for forwarding packets on routers, on gateways, or between VMs and network namespaces on a host. It also supports STP, VLAN filter, and multicast snooping.
```

在bridge中，有一个组件叫**MAC learning database**(也叫FDB)，当一个网络包经过bridge的时候，它会做两件事：1. 将这个网络包的mac地址和bridge端口的对应关系记录到FDB里（如果不存在）2.从FDB里查找目的mac地址对应的bridge端口，如果找到了，则从那个端口将包转发出去，如果没有，则向除源端口外的其他端口都发送这个网络包。

查看FDB表的内容的命令为：`bridge fdb show`（e.g. `bridge fdb show br0`）或`brctl showmacs`(e.g. `brctl showmacs br0`)

创建bridge相关的命令：

```
# ip link add br0 type bridge
# ip link set eth0 master br0  //将eth0绑定到br0上
```

### Tunnel

```
TUN/TAP provides packet reception and transmission for user space programs. 
It can be seen as a simple Point-to-Point or Ethernet device, which,
instead of receiving packets from physical media, receives them from 
user space program and instead of sending packets via physical media 
writes them to the user space program. 
```

## 参考资料

- Introduction to Linux interfaces for virtual networking: https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking
- Understanding Linux Internet working: https://www.actualtechmedia.com/wp-content/uploads/2018/01/CUMULUS-Understanding-Linux-Internetworking.pdf

  Bridge:

* Linux Bridge - how it works: https://goyalankit.com/blog/linux-bridge

  TUN/TAP:

- TUN/TAP内核文档：https://www.kernel.org/doc/Documentation/networking/tuntap.txt
- Network Tunnels with Linux: https://www.jumpingbean.co.za/blogs/mark/linux-network-tunnels