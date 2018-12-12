# [Kubernetes Notes](https://hex108.gitbook.io/kubernetes-notes/)

* 搭建开发环境
  * [搭建本地开发测试环境](install-kubernetes/install-local-k8s.md)
  * 搭建多机开发测试环境
* 容器运行时(Container Runtime)
  * CRI
  * Docker
  * Containerd
* 资源隔离与限制
  - 基础知识
    - [Cgroup](resource-isolation/cgroup.md)
    - [Namespaces](resource-isolation/namespace.md)
  - [CPU](resource-isolation/cpu.md)
  - [Memory](resource-isolation/memory.md)
  - 网络出/入带宽
  - [Container](resource-isolation/container.md)
* 网络
  * 基础知识
    * [Iptables](network/iptables.md)
    * [Overlay network](network/overlay_network.md)
  * CNI
  * Flannel
  * Calico
* Service Mesh
  * Istio
* 神奇的Kubernetes特性
  * [Admission controller](amazing-features/admission-controller.md)
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

