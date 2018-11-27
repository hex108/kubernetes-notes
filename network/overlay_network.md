# Overlay network

## 网络设备

### Tunnel

```
TUN/TAP provides packet reception and transmission for user space programs. 
It can be seen as a simple Point-to-Point or Ethernet device, which,
instead of receiving packets from physical media, receives them from 
user space program and instead of sending packets via physical media 
writes them to the user space program. 
```



## 参考资料

* TUN/TAP内核文档：https://www.kernel.org/doc/Documentation/networking/tuntap.txt
* Network Tunnels with Linux: https://www.jumpingbean.co.za/blogs/mark/linux-network-tunnels
* IP over UDP tunnel with socat: https://www.gabriel.urdhr.fr/2016/01/12/ip-over-udp-with-socat/
* Foo over UDP: https://lwn.net/Articles/614348/
* Vxlan内核文档：https://www.kernel.org/doc/Documentation/networking/vxlan.txt
* Multi-Host Networking Overlay with Flannel: https://docker-k8s-lab.readthedocs.io/en/latest/docker/docker-flannel.html（这网站里有很多docker网络相关的动手小实验）