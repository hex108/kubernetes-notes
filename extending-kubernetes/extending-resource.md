# 扩展资源维度

通常情况下，如果想给k8s多增加下一些资源维度，需要改kubelet、kube-scheduler代码，kubelet需要通过心跳上报这个资源的信息(capacity、allocable等)，kube-scheduler调度时需要对这个资源进行predicate，判断node上是否有合适的资源。

k8s提供了一种有效的扩展方式，用于增加如inode、egress(网络出带宽)等这种类似于CPU、memory的简单的数值型的资源维度：

1. 根据[Advertise Extended Resources for a Node](https://kubernetes.io/docs/tasks/administer-cluster/extended-resource-node/)里提到的方法，将node上相应的资源PATCH到nodeinfo中
2. 根据[Assign Extended Resources to a Container](https://kubernetes.io/docs/tasks/configure-pod-container/extended-resource/)，在pod里申请相应的资源
3. Kube-scheduler会根据pod里的request和limit，进行相应的predicate

## 参考资料

* Advertise Extended Resources for a Node: https://kubernetes.io/docs/tasks/administer-cluster/extended-resource-node/
* Assign Extended Resources to a Container: https://kubernetes.io/docs/tasks/configure-pod-container/extended-resource/