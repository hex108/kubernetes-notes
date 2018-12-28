# 理解证书

## 1. 基本原理

A想要与B通信，A如何向B证明"我就是A"，B如何向A证明"我就是B"？证书正是解决这个问题的。

在[非对称加密算法](https://en.wikipedia.org/wiki/Public-key_cryptography)中，有一个public key和一个private key，这两个key是一一对应的，通过某一个key加密的数据只能由另一个key解出来。一般private key由用户私有保存，public key是公开的。

证书里包含了以下几项重要信息：

* CommonName（CN）：证书对应的人（或物），比如：用户A，用户B
* Public key：CN对应的public key，如果某个用户能解开用这个public key加密的数据，那说明该用户就是该证书对应的人。
* Signature Algorithm: 证书的签名加密算法，比如：sha256WithRSAEncryption。在后面会用到。
* 其他，如：证书的有效时间

这样通过证书把 public key和用户一一对应起来了。但如何证明这个证书是真的？这就是[CA(Certificate authority)](https://en.wikipedia.org/wiki/Certificate_authority)的作用了。CA是一个颁发证书的权威机构，它自己也有一个public key和private key，它会用private key + 签名算法对上面的证书内容进行加密，生成一个签名，附在证书末尾。例：如果签名算法为sha256WithRSAEncryption时，会先对内容进行sha256处理，再用private key进行加密。用户怎么确认这个证书是经该CA机构认证的证书？他对证书中除签名外的内容进行sha256处理得到内容c1，然后用CA机构公开的public key对签名进行解密得到内容c2，如果c1=c2，则证明该证书确实是该CA机构认证过的。

现在通过CA机构可以将证书与用户一一对应起来了，也就是说A拿着经过CA认证过的证书就可以证明“我确实是A”。但CA认证过的用户就是真实可靠的？这就需要用户对CA机构的认可，将该CA加入信任的证书机构列表里。在chrome浏览器里会内置一些可靠的CA机构，省去了这些操作。

## 2. 生成证书

可以通过Openssl生成，参考[How to setup your own CA with OpenSSL](https://gist.github.com/Soarez/9688998)（非常易懂）。

## 3. 简单应用

- Go和HTTPS: https://tonybai.com/2015/04/30/go-and-https/
- TLS with Go: https://ericchiang.github.io/post/go-tls/

## 4. Kubernetes相关的证书

- Kubernetes里用到的证书相关的参数

  https://github.com/kubernetes/kubernetes/issues/54665#issuecomment-340960398

  https://github.com/kubernetes-incubator/apiserver-builder/blob/master/docs/concepts/auth.md

- How Kubernetes certificate authorities work

  https://www.hnwatcher.com/r/5640735/How-Kubernetes-certificate-authorities-work

- 生成kubernetes证书

  Certificates: https://kubernetes.io/docs/concepts/cluster-administration/certificates/

  Provisioning a CA and Generating TLS Certificates: https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md

  Generating Kubernetes Configuration Files for Authentication: https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/05-kubernetes-configuration-files.md

* HPA证书相关参数

  https://kubernetes.io/docs/tasks/access-kubernetes-api/configure-aggregation-layer/#enable-apiserver-flags 

## 5. 参考资料

* Public-key cryptography: https://en.wikipedia.org/wiki/Public-key_cryptography

* CA(Certificate authority): https://en.wikipedia.org/wiki/Certificate_authority

* CSR(Certificate Signing Request)

  https://www.sslshopper.com/what-is-a-csr-certificate-signing-request.html

  https://en.wikipedia.org/wiki/Certificate_signing_request

* PKI(Public key infrastructure)

  https://en.wikipedia.org/wiki/Public_key_infrastructure

* Public key certificate

  https://en.wikipedia.org/wiki/Public_key_certificate

* PEM(Privacy-enhanced Electronic Mail)

  https://en.wikipedia.org/wiki/Privacy-enhanced_Electronic_Mail

* TLS(Transport Layer Security)

  - Wiki: https://en.wikipedia.org/wiki/Transport_Layer_Security
  - RFC5246: https://tools.ietf.org/html/rfc5246
  - The First Few Milliseconds of an HTTPS Connection: http://www.moserware.com/2009/06/first-few-milliseconds-of-https.html