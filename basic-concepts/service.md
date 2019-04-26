# Service

### 1. Headless service

[Headless service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)的proposal在[Proposal: Headless services](https://github.com/kubernetes/kubernetes/issues/1607)，主要是为了提供服务发现的接口，通过DNS查询这个service时，可以获取其对应的pods的ip列表：

> The endpoints_controller already creates endpoint records in etcd for services, which are also made available via the API. Headless services would do the same, just without creating an IP and/or DNS name for the service. This would create an API that clients could use to watch the set of endpoints associated with the headless service, and which would take advantage of whatever UI, readiness probes, etc. we add for services more generally, and which would be available for Kubernetes applications without the need to run a separate discovery service.

后来对headless service的使用做了更多的扩展：

* 如果headless service指定了selector时，k8s不会为它分配cluster ip，但endpoint controller会为该service创建selector对应的pod的ip的endpoints。这些endpoints会被DNS（根据[Kubernetes DNS-Based Service Discovery](https://github.com/kubernetes/dns/blob/master/docs/specification.md)）用于创建A record，这样通过nslookup这个service时，可以查到对应的pod列表，并且，通过`podName.serviceName`可以访问到对应的pod ip。创建`statefulset`对象前就要创建这样一个headless service，用于pod间通信。
* 如果headless service没有指定selector，k8s不会为它分配cluster ip，endpoint controller也不会为它创建endpoint，但DNS会创建相应的CNAME records for [`ExternalName`](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)-type services或A records for any Endpoints that share a name with the service, for all other types.

## 2. 参考资料

* Headless service: [https://kubernetes.io/docs/concepts/services-networking/service/#headless-services](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)
* Proposal: Headless service: [https://github.com/kubernetes/kubernetes/issues/1607](https://github.com/kubernetes/kubernetes/issues/1607)