# [Kubernetes Notes](https://hex108.gitbook.io/kubernetes-notes/)

* 搭建开发环境
  * [搭建本地开发测试环境](install-kubernetes/install-local-k8s.md)
  * 搭建多机开发测试环境
* 基本概念
  * Workloads
    * [StatefulSet](basic-concepts/workloads/statefulset.md)
  * 认证鉴权
    * [理解证书](basic-concepts/authentication-authorization/certificate.md)
    * [Kubelet配置](basic-concepts/authentication-authorization/kubelet.md)
  * [垃圾回收](basic-concepts/garbage-collection.md)
  * [Service](basic-concepts/service.md)
* 基础组件
  * [Scheduler](basic-components/scheduler.md)
* 容器运行时(Container Runtime)
  * [CRI](container-runtime/cri.md)
  * Docker
    * [安装配置Docker](container-runtime/docker/install-and-configure-docker.md)
    * [Docker FAQ](container-runtime/docker/docker-faq.md)
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
    * [Linux network interfaces](network/linux-network-interfaces.md)
    * [Iptables](network/iptables.md)
    * [Overlay network](network/overlay-network.md)
  * [CNI](network/cni.md)
  * Flannel
    * [Flannel原理](network/flannel/flannel.md)
    * [host-gw](network/flannel/host-gw.md)
    * [vxlan](network/flannel/vxlan.md)
    * [ipip](network/flannel/ipip.md)
  * Calico
  * Cilium
* Service Mesh
  * Istio
* 扩展Kubernetes
  * [Admission controller](extending-kubernetes/admission-controller.md)
  * [Custom resource definition(CRD)](extending-kubernetes/crd.md)
  * [Scheduler extender](extending-kubernetes/scheduler-extender.md)
  * [扩展资源维度](extending-kubernetes/extending-resource.md)
  * [Kubectl plugin](extending-kubernetes/kubectl-plugin.md)
  * Device plugin
* 性能调优
  * [参数调优](performance-tunning/parameters-tunning.md)
* 现网问题
  * [Kubernetes](bugs-in-production/kubernetes.md)
  * [ETCD](bugs-in-production/etcd.md)
  * [Docker](bugs-in-production/docker.md)
* [各组件推荐参数配置](components_configure.md)
* [各大公司生产环境实践](usecases-in-production.md)
* [社区贡献](how-to-contribute.md)
* [学习资料](learning-materials.md)
* 附录：RTFSC

  * [Informer](RTFSC/informer.md)
  * [Pod deletion](RTFSC/pod-deletion.md)