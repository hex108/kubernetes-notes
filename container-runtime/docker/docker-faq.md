# Docker FAQ

* Docker image expose了一些端口，docker run --net=host时，如何不暴露这些端口？

  方法一：docker run时加上-p选项，指定要暴露哪些端口

  方法二：重新做镜像，docker export然后docker import即可删除这些expose端口信息，不过像CMD、Entrypoint等信息也没有了。注：使用Dockerfile做镜像时无法清除base image已经expose的端口。