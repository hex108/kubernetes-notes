# Flannel

## 1. 原理

Flannel的源码简洁明了，依次做了以下几件“大事”：

* 启动时使用[Leases and Reservations](https://github.com/coreos/flannel/blob/master/Documentation/reservations.md)里的机制从etcd/kubernetes租用一段ipv4网络地址空间，然后把它写入由参数`subnet-file`指定的配置文件（默认为`/run/flannel/subnet.env`），包含了以下几个环境变量：`FLANNEL_NETWORK`（所有flannel可供分配的网段）、`FLANNEL_SUBNET`（该flannel分配到的网段）、`FLANNEL_MTU`（MTU值）、`FLANNEL_IPMASQ`，这几个值除了flannel自己用，还可用于设置docker的启动参数（例：设置`--bip=FLANNEL_SUBNET`）。

* 如果指定了ip-masq（默认为false），则增加一些IP masquerade rule，供overlay network外面的节点访问。
* 如果指定了iptables-forward-rules（默认为true），则增加FORWARD规则，让发送到`FLANNEL_NETWORK`网段里的ip的包能forward到容器里。对于docker 1.13+，这个非常重要，主要原因是从1.13版本开始，docker把FORWARD的默认规则改为DROP了。
* 根据用户指定的backend type(支持的[backends](https://github.com/coreos/flannel/blob/master/Documentation/backends.md)有Vxlan、host-gw、UDP等)，创建一个backend。每个backend都需要实现`RegisterNetwork(...)`方法，用于创建一个实现了`Network`接口的实例。每个backend所做的事情就是监听各flannel分配/释放网络段的事件，然后进行相应的处理，比如：host-gw就是发现有新的flannel节点申请到网络段后，就会增加一些route规则，发现有网络段被释放后，就删除相应的route规则。相对来说host-gw相关的代码最简单，可以对照代码和文章[host-gw](./host-gw.md)理解。

Flannel有个非常好的[extension backend](https://github.com/coreos/flannel/blob/master/Documentation/extension.md)用来理解和测试各个backend的原理，理解`PreStartupCommand`、`PostStartupCommand`、`SubnetAddCommand`这几个命令，基本上就理解了相应backend的实现了。

## 2. 运行

[Running flannel](https://github.com/coreos/flannel/blob/master/Documentation/running.md)描述得很详细，文章[host-gw](./host-gw.md)里有具体的例子。

## 3. 参考资料

* Leases and Reservations: https://github.com/coreos/flannel/blob/master/Documentation/reservations.md

* Backends: https://github.com/coreos/flannel/blob/master/Documentation/backends.md
* Extension backend: https://github.com/coreos/flannel/blob/master/Documentation/extension.md
* Running flannel: https://github.com/coreos/flannel/blob/master/Documentation/running.md