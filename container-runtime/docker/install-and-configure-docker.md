# 安装配置Docker

## 1. 安装Docker

所有版本的安装文档在https://docs.docker.com/install/都可以找到。

以在ubuntu上安装docker为例：https://docs.docker.com/install/linux/docker-ce/ubuntu/，只需要执行两步即可安装成功：

```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```

如果想要让非root用户也能使用root，需要将该用户加到docker组：

```
$ sudo usermod -aG docker USER_NAME
```

## 2. 配置Docker

Docker daemon的配置文件为`/etc/docker/daemon.json`，修改它即可。

### 2.1 配置bridge

Docker daemon默认使用brdige docker0，它创建的bridge模式的container将会加入到该bridge上。如果想用别的bridge，增加下面选项即可。

```
{
  "bridge": "YOUR-BRIDGE"
}
```

### 2.2 配置fixed-cidr

fixed-cidr必须与bridge在同一个网段（因此要求bridge必须要有ip，否则配置的bridge将不起作用，docker依旧将使用bridge docker0）。

```
--fixed-cidr=CIDR and --fixed-cidr-v6=CIDRv6: restrict the IP range from the docker0 subnet, using standard CIDR notation. For example: 172.16.1.0/28. This range must be an IPv4 range for fixed IPs, and must be a subset of the bridge IP range (docker0 or set using --bridge or the bip key in the daemon.json file). For example, with --fixed-cidr=192.168.1.0/25, IPs for your containers will be chosen from the first half of addresses included in the 192.168.1.0/24 subnet.
```

```
{
    "fixed-cidr": "XXXXX/XX"    // e.g. "fixed-cidr": "192.168.1.5/25"
}
```

## 3. 参考资料

* Build your own bridge: https://docs.docker.com/v17.09/engine/userguide/networking/default_network/build-bridges/
* Customize the docker0 bridge: https://docs.docker.com/v17.09/engine/userguide/networking/default_network/custom-docker0/