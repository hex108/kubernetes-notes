# CRI

CRI定义了pod、image相关的一系列[接口](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-node/container-runtime-interface.md)，如果要增加一个新的容器引擎，只需要新增一个相应的CRI实现即可。如果runtime是兼容OCI标准的，直接使用现有的[cri-o](https://github.com/cri-o/cri-o)或[cri-containerd](https://github.com/containerd/cri)即可。

通过[CRI-tools](https://github.com/kubernetes-sigs/cri-tools)工具可以很方便地与CRI接口通信，使用起来也很方便(和docker命令类似)，而且它提供了`crictl pods`（列出pods）之类的好用的命令。

## 参考资料

- Who Is Running My Kubernetes Pod? The Past, Present, and Future of Container Runtimes: https://www.infoq.com/articles/container-runtimes-kubernetes
- Kubernetes 容器运行时演进: https://feisky.xyz/posts/kubernetes-container-runtime/