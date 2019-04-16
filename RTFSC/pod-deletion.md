# Pod deletion

## 1. 代码

所有的rest请求都会转到api server，由apiserver处理。

`staging/src/k8s.io/apiserver/pkg/registry/generic/registry/store.go`（其他接口也在这，比如: `GET`）

```
// Delete removes the item from storage.
func (e *Store) Delete(ctx genericapirequest.Context, name string, options *metav1.DeleteOptions) (runtime.Object, bool, error)
```

参数里有个`DeleteOptions`，是为了实现graceful shutdown。

`staging/src/k8s.io/apiserver/pkg/endpoints/installer.go`在install rest api handler时会对这种支持`DeleteOptions`的handler进行特殊处理，从http body里取出delete options相关的参数。

```
func (a *APIInstaller) registerResourceHandlers(path string, storage rest.Storage, ws *restful.WebService, proxyHandler http.Handler) (*metav1.APIResource, error) {
    ...
	gracefulDeleter, isGracefulDeleter := storage.(rest.GracefulDeleter)
	...
	switch {
	case isGracefulDeleter:
		versionedDeleteOptions, err = a.group.Creater.New(optionsExternalVersion.WithKind("DeleteOptions"))
		if err != nil {
			return nil, err
		}
		versionedDeleterObject = indirectArbitraryPointer(versionedDeleteOptions)
		isDeleter = true
	case isDeleter:
		gracefulDeleter = rest.GracefulDeleteAdapter{Deleter: deleter}
	}
    ...
    		case "DELETE": // Delete a resource.
			article := getArticleForNoun(kind, " ")
			doc := "delete" + article + kind
			if hasSubresource {
				doc = "delete " + subresource + " of" + article + kind
			}
			handler := metrics.InstrumentRouteFunc(action.Verb, resource, subresource, requestScope, restfulDeleteResource(gracefulDeleter, isGracefulDeleter, reqScope, admit))
			route := ws.DELETE(action.Path).To(handler).
				Doc(doc).
				Param(ws.QueryParameter("pretty", "If 'true', then the output is pretty printed.")).
				Operation("delete"+namespaced+kind+strings.Title(subresource)+operationSuffix).
				Produces(append(storageMeta.ProducesMIMETypes(action.Verb), mediaTypes...)...).
				Writes(versionedStatus).
				Returns(http.StatusOK, "OK", versionedStatus)
			if isGracefulDeleter {
				route.Reads(versionedDeleterObject)
				if err := addObjectParams(ws, route, versionedDeleteOptions); err != nil {
					return nil, err
				}
			}
			addParams(route, action.Params)
			routes = append(routes, route)
}
```

注意：如果是`gracefulDeleter`，则最终传给`store.go#Delete`函数的options参数一定不为nil。

删除pod的接口如下：

```·
Delete(name string, options *meta_v1.DeleteOptions)
```

`options`为`nil`时，将会使用default graceful period(默认为30s)。如果要强制直接从etcd上把pod删除，可以指定graceful period为0（`metav1.NewDeleteOptions(0)`）。具体的例子可见https://github.com/coreos/etcd-operator/pull/273。

最后，Pod etcd strategy在文件夹`pkg/registry/core/pod`下。

## 2. Issue

- Proposal - Pod safety and termination guarantees: https://github.com/kubernetes/kubernetes/pull/34160

- Make StatefulSets safe during cluster failure: https://github.com/kubernetes/features/issues/119

- Node status down -> pod status unknown -> pod cant be deleted, cordon doesnt finish.: https://github.com/kubernetes/kubernetes/issues/51333

- Graceful delete

  - Consistently support graceful and immediate termination for all objects: https://github.com/kubernetes/kubernetes/issues/1535
  - Deleting pods and other resources with graceful shutdown: https://github.com/kubernetes/kubernetes/issues/2789

- 具体的应用，怎么删除一个pod

  k8s: delete pod with 0 grace period: https://github.com/coreos/etcd-operator/pull/273

## 3. 参考资料

- Pod Safety, Consistency Guarantees, and Storage Implications: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/storage/pod-safety.md

  保证at most on instance，避免多实例，对statefulset格外重要

- Termination of Pods: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods