# Kubernetes相关问题

## Kubelet

* mount volume超时

  volume下有大量的未删除文件，导致mount volume操作过了很久才生效。最终发现是升级golang版本编译kubernetes导致的，golang lib改了remove的行为。

## Network

* iptables太多，导致网络性能差

  在系统中创建了一些service，kube-proxy会创建相应的iptables，iptables多了会影响网络性能。新版本的kubernetes会使用ipvs替换iptables，性能会好很多，参见[[IPVS-Based In-Cluster Load Balancing Deep Dive](https://kubernetes.io/blog/2018/07/09/ipvs-based-in-cluster-load-balancing-deep-dive/)。