# Kubectl plugin

使用kubectl plugin可以很方便地扩展kubectl命令，比如：可以加一个kubectl set-ns命令用于设置当前的namespace。关于plugin的介绍可见[Extend kubectl with plugins](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/)。

如果你要使用很多个plugin，这时候就可以使用plugin管理工具[krew](https://github.com/GoogleContainerTools/krew)了。

```
kubectl krew search               # show all plugins
kubectl krew install view-secret  # install a plugin named "view-secret"
kubectl view-secret               # use the plugin
kubectl krew upgrade              # upgrade installed plugins
kubectl krew remove view-secret   # uninstall a plugin
```