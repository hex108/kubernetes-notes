## 自动扩缩容(HPA)

## 1. 简介

HPA controller可以根据以下两种类型的metrics进行自动扩缩容：

* 通用的metrics

  比如：CPU、Memory的使用情况，这些metrics是通过kubelet上的cAdvisor收集，[metrics server](https://github.com/kubernetes-incubator/metrics-server)再聚合这些metrics，然后HPA controller根据metrics server提供的这些信息进行自动扩缩容。

* 用户自定义metrics(custom metrics)

  Pod可以通过http接口暴露一些自定义的metrics，比如：http请求数，然后通过custom metrics server把这些metrics提供给HPA controller。[Custom Metrics API](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/custom-metrics-api.md)定义了这些metrics相关的规范，custom metrics server也有一些[开源的实现](https://github.com/kubernetes/metrics/blob/master/IMPLEMENTATIONS.md)，例：我们可以通过promethus去收集pod暴露的metrics，然后通过[promethus adaptor](https://github.com/directxman12/k8s-prometheus-adapter)提供符合Custom Metrics API标准的接口，通常我们称这个adaptor为custom metrics server。

## 2. 实践

- [k8s-prom-hpa](https://github.com/stefanprodan/k8s-prom-hpa)

  通过k8s-prom-hpa很方便地熟悉HPA相关的知识和流程。

  注意：如果在本地运行这个例子的时候必须要改下kubelet node name(具体修改`hack/local-up-cluster.sh`，如下diff所示)，否则custom metrics没法拿到它的metrics。

  ```
  -HOSTNAME_OVERRIDE=${HOSTNAME_OVERRIDE:-"127.0.0.1"}
  +HOSTNAME_OVERRIDE=${HOSTNAME_OVERRIDE:-"10.0.2.15"}
  ...
  -KUBELET_HOST=${KUBELET_HOST:-"127.0.0.1"}
  +KUBELET_HOST=${KUBELET_HOST:-"10.0.2.15"}
  ```

- [k8s-podinfo](https://github.com/stefanprodan/k8s-podinfo)

  用stefanprodan/podinfo:0.2.0作为测试的image(用于暴露用户自定义metrics)即可：`docker run -it -p 8989:8989 stefanprodan/podinfo:0.2.0`。

## 3. CRD HPA

**HPA的是如何起作用的**：HPA通过resource的scale接口，设置该resource的replicas数。

因此，只要CRD定义了[scale subresource](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#scale-subresource)（**这个特性是在Kubernetes 1.10版本加入，如要启用，需给kube-apiserver加上参数`--feature-gates=CustomResourceSubresources=true`**，1.11版本后就不用加该参数了），并且实现了相应的接口(即：HPA通过scale接口设置replicas数后，CRD的controller会基于该replicas进行相应地扩缩容)，我们就可以通过HPA对该CRD对象进行自动扩缩容。s

**Scale subresource的实现**

`staging/src/k8s.io/apiextensions-apiserver/pkg/registry/customresource/etcd.go`

```
func (r *ScaleREST) Get(...)
获取scale相关的信息。根据r.specReplicasPath, r.statusReplicasPath, r.labelSelectorPath从custom resource里取值

func (r *ScaleREST) Update(...)
更新scale相关的信息
```

## 4. 注意事项

- 要指定requests资源，要不然不会收集资源信息

- 配置aggregation layer

  https://kubernetes.io/docs/tasks/access-kubernetes-api/configure-aggregation-layer/

  注意：If you are not running kube-proxy on a host running the API server, then you must make sure that the system is enabled with the following apiserver flag:  `--enable-aggregator-routing=true`。如果不配置这个，就需要启动一个kube-proxy。最好启动一个。

## 5. 参考资料

- Kubernetes autoscaling based on custom metrics without using a host port: https://medium.com/@marko.luksa/kubernetes-autoscaling-based-on-custom-metrics-without-using-a-host-port-b783ed6241ac
- k8s-prom-hpa: https://github.com/stefanprodan/k8s-prom-hpa
- Configure Kubernetes Autoscaling With Custom Metrics: https://docs.bitnami.com/kubernetes/how-to/configure-autoscaling-custom-metrics/
- Kubernetes 1.8: Now with 100% Daily Value of Custom Metrics: https://blog.openshift.com/kubernetes-1-8-now-custom-metrics/
- Kubernetes monitoring architecture: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/monitoring_architecture.md