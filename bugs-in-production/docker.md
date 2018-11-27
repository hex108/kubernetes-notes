# Docker相关问题

## Storage driver

Docker storage driver的选择问题：https://docs.docker.com/storage/storagedriver/

* Devicemapper

  * 使用devicemapper时，很容易卡住

  * 每个容器默认只能使用10G空间（可配置）

* Overlay

  - 不支持文件mv操作

  - 执行crontab时会有问题

    解决方法：容器启动时执行命令`touch /etc/crontab /etc/cron.*/*`，见https://stackoverflow.com/questions/34962020/cron-and-crontab-files-not-executed-in-docker。

## Docker image

如果使用的镜像tag不是latest，且pull policy不是always，那么有可能你更新的镜像在pod运行时不是最新的。

## Container stdout/stderr文件太大

给docker daemon配置参数控制每个container的stdout和stderr文件的大小：`--log-opt max-size=XXX --log-opt max-file=XXX`，例：`--log-opt max-size=10M --log-opt max-file=3`，每个stdout/stderr最多只有10M，最多保存3个（文件会回滚）。

