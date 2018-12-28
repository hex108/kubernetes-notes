# Kubelet配置

默认情况下，kubelet监听的10250端口没有进行任何认证鉴权，导致通过这个端口可以对kubelet节点上运行的容器进行任何操作，如：`curl -k -XPOST "https://k8s-node-1:10250/run/demo-ns/demo-pod/demo" -d "cmd=ls -la /"`，因此需要配置一些参数防止这种情况发生。

Kubelet支持X509证书认证和API bearer token认证，我们暂且只配置X509证书认证：

* 给kubelet增加X509证书认证，且禁止匿名访问

  `--client-ca-file XXX --anonymous-auth=false`

* 给apiserver增加访问kubelet时的证书，否则apiserver将无法访问kubelet

  `--kubelet-client-certificate XXX --kubelet-client-key XXX`

## 参考资料

* kubelet-exploit: https://github.com/kayrus/kubelet-exploit
* Kubelet authentication/authorization: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet-authentication-authorization/
* Master-Node communication: https://kubernetes.io/docs/concepts/architecture/master-node-communication/
* TLS bootstrapping: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet-tls-bootstrapping/
* Kubernetes Security Best-Practices: https://dev.to/petermbenjamin/kubernetes-security-best-practices-hlk#network-policies