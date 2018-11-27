# [Kubernetes Notes](https://hex108.gitbook.io/kubernetes-notes/)

* [搭建本地开发测试环境](build-develop-env.md)
* 容器运行时(Container Runtime)
  * CRI
  * Docker
  * Containerd
* 资源隔离与限制
  - 基础知识
    - Cgroup
    - [Namespaces](resource-isolation/namespace.md)
  - CPU
  - Memory
  - 网络出/入带宽
  - 磁盘空间
  - 磁盘IO
* 网络
  * 基础知识
    * [Iptables](network/iptables.md)
    * [Overlay network](network/overlay_network.md)
  * CNI
  * Flannel
  * Calico

* Service Mesh
  * Istio
* 扩展Kubernetes
  * [CustomResourceDefinition(CRD)](extending-kubernetes/crd.md)
  * [Scheduler extender](extending-kubernetes/scheduler_extender.md)
* 性能调优
  * [参数调优](performance-tunning/parameters-tunning.md)
* 现网问题
  * [Kubernetes](bugs-in-production/kubernetes.md)
  * [ETCD](bugs-in-production/etcd.md)
  * [Docker](bugs-in-production/docker.md)
* [各组件推荐参数配置](components_configure.md)
* [各大公司生产环境实践](usecases-in-production.md)

