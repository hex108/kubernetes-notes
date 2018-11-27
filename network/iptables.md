# Iptables

通过[An In-Depth Guide to iptables, the Linux Firewall](https://www.booleanworld.com/depth-guide-iptables-linux-firewall/)了解iptables的基本概念（table, chain, target, module）和原理，掌握一些常用使用方法。以后遇到不懂的基本可以通过`iptables -h`或`man iptables`解决。

下面的图对于理解iptables有一些帮助。

![Packet flow in Netfilter and General Networking](http://inai.de/images/nf-packet-flow.svg)

Prerouting -> routing(路由)  -> |--> input -> 进程处理 -> output -> postrouting

​                                                      |--> forward

## Target

LOG和TRACE target可以用来debug。

## Iptables modules

`-m`后面接的是module name，列出所有的modules的命令：`cat /proc/net/ip_tables_matches`，关于各个module的详细使用见[iptables-extensions](http://ipset.netfilter.org/iptables-extensions.man.html)。

## 参考资料

* An In-Depth Guide to iptables, the Linux Firewall: https://www.booleanworld.com/depth-guide-iptables-linux-firewall/
* iptables-extensions: http://ipset.netfilter.org/iptables-extensions.man.html
* A Deep Dive into Iptables and Netfilter Architecture: https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture
* Iptables Tutorial 1.2.2: https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html