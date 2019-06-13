# Aggregator

除了通过[CRD](./crd.md)对Kubernetes API进行扩展外，我们还可以自建一个addon API Server，然后通过`apiregistration.k8s.io/APIService`向kube-apiserver注册，kube-apiserver里的aggregator会对addon API Server提供的服务进行转发。

## 参考资料

* Aggregation: https://github.com/kubernetes-incubator/apiserver-builder-alpha/blob/master/docs/concepts/aggregation.md
* Extending the Kubernetes API with the aggregation layer: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/