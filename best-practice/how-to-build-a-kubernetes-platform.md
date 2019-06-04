# 如何打造一个Kubernetes平台

Kubernetes的生态异常繁荣，其landscape见https://landscape.cncf.io/。我们可以使用这些开源软件打造一个Kubernetes平台。下面将列出一些可能有用的开源工具。

## 用户认证

[Dex](https://github.com/dexidp/dex)支持OpenID Connect Identity (OIDC) and OAuth 2.0。

## 用户鉴权

[Casbin](https://github.com/casbin/casbin)支持各种用户权限策略（ACL, RBAC, ABAC等）。