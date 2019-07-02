# 如何打造一个Kubernetes平台

Kubernetes的生态异常繁荣，其landscape见https://landscape.cncf.io/。我们可以使用这些开源软件打造一个Kubernetes平台。下面将列出一些可能有用的开源工具。

## 集群部署和安装

[cluster-api](https://github.com/kubernetes-sigs/cluster-api)支持在各种环境部署和安装集群，它和k8s类似，使用声明式api实现。

## 用户认证

[Dex](https://github.com/dexidp/dex)支持OpenID Connect Identity (OIDC) and OAuth 2.0。

## 用户鉴权

[Casbin](https://github.com/casbin/casbin)支持各种用户权限策略（ACL, RBAC, ABAC等）。

## 镜像仓库

使用[harbor](https://github.com/goharbor/harbor)搭建镜像仓库。如果需要使用p2p传输镜像，可以考虑[Dragonfly](https://github.com/dragonflyoss/Dragonfly)或[kraken](https://github.com/uber/kraken)。kraken自身就包含了镜像仓库的功能，不能和harbor等搭配使用。