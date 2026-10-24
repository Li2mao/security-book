# Day4

# IPSEC

## 散列函数

散列函数也叫做Hash函数，主流的算法有md5和sha1，一般可以用散列函数计算一串数据的散列值，散列值和这串数据对应，就像你的指纹对应你的人，所以散列值一般称为数据指纹。

- linux的计算方式

```C
==========计算文件的md5值=================
[root@localhost ~]# md5sum ToDesk_Lite.exe 
260e028912ce07b274bc5ee9c8a512b0  ToDesk_Lite.exe

=========-计算文件的sha256值===============
[root@localhost ~]# sha256sum ToDesk_Lite.exe 
4335beaae050195cabca011aa6a0221c0a2205086c0660fb27eb648e7dad2cc5  ToDesk_Lite.exe
```

- windows的计算方式（通过解压缩软件）

![image\.png](图片和附件/image%208.png)

- 散列值具备和文件对应的唯一性

散列函数有以下4个特点：

- 固定大小

    - 无论数据有多大，最终计算的散列值大小是固定的

    - md5有16位和32位

- 雪崩效应

    - 即使是一个很大的数据，你修改了微不足道的一小部分，都会导致散列值完全不一样

- 单向

    - 只可能从原始数据计算得到散列值，不可能从散列值恢复哪怕一个bit的原始数据

- 冲突避免

    - 几乎不能够找到另外一个数据和当前数据的散列值完全相同

    - 散列值可以确保数据的唯一性

## HMAC\(完整性\)

HMAC（Hash\-based Message Authentication Code，哈希消息认证码）是一种基于哈希函数和密钥的消息认证技术，用于验证数据的完整性和真实性。以下是其核心要点：

- HMAC值是将原数据\+预先共享的密钥等信息通过散列函数产生的

    - 预先共享的密钥是不公开，所以中途即使被截获，数据修改后，也无法重新生成HMAC值

    - 预先共享的密钥往往是通过周期性DH算法碰撞出来的，是无法被第三方获知的\(DH算法扩展知识\)

- 完整性验证​：通过对比发送方与接收方计算的HMAC值，检测数据是否被篡改。

- 身份认证​：只有持有共享密钥的双方能生成有效认证码，防止伪造。

- 抗重放攻击​：每次通信可结合随机数（如挑战/响应机制），确保认证码的唯一性。

# 非对称加密算法

## 对称加密算法

- 加密和解密使用的key是一样的

- 在没有key的情况下，几乎无法解开

- 在key足够复杂的情况下，暴力破解是没有意义

- 常见的对称加密算法

    - DES\(由于加密程度不够，现在的计算机暴力破解不需要多久，所以DES并不安全\)

    - 3DES，其实就是DES来3遍，相比较DES安全的多的过渡方案

    - AES，AES支持128位、192位和256位密钥长度。以AES\-256为例，其密钥组合数量为2256（约1\.15×1077），远超宇宙原子总数（约1080）。即使使用当前最快的超级计算机暴力破解，也需要数万亿年。

- 可以在线aes加解密https://the\-x\.cn/cryptography/Aes\.aspx

- Key如果被截获，就完全没有安全可言

## 非对称加密算法

- 主要的应用领域

    - 加密数据

    - 数字签名

- 非对称加密算法在产生密钥的时候，是成对出现的

    - 密钥生成器先生成私钥\(需要本地保护，不能出现任何的互联网上\)

    - 基于私钥生成公钥\(公钥可以公开\)

- 私钥加密的文件，只能由对应的公钥解开

    - 其实获取私钥后也可以解开对应内容，只需要用私钥重新生成对应的公钥

- 公钥加密的文件，只能由对应的私钥解开

- 常见算法

    - RSA

- 非对称密钥生成器

    - https://puttygen\.com/download\.php?val=46

![image\.png](图片和附件/image%2017.png)

- 点击Generate就可以生成密钥

    - 为了每次生成都是独一无二的，在生成的过程中，需要鼠标不停的滑动，会记录鼠标的坐标作为随机值

![image\.png](图片和附件/image%2010.png)

### 加密文件

- 可以使用在线加密网站体验：https://tool\.ip138\.com/rsa/

- 非对称加密算法加密和解密的过程速度很慢

    - 加解密速度比对称加密慢100\-1000倍

- 加密之后，数据会变得很长

    - 如RSA\-1024为2\.56倍

- 使用非对称加密去加密对称加密的Key

![image\.png](图片和附件/image%209.png)

### 数字签名

- 用于在通信的过程中，为了证明我是我，不是别人伪造的，需要提供数字签名

- 发送者使用私钥，加密一些信息，比如包含文件的校验值，接受者可以从权威机构获得发送的公钥，解密数字签名之后，可以确认发送者是谁。

![image\.png](图片和附件/image%2019.png)

#### 举例：

- 如何确认百度就是官方的百度

![image\.png](图片和附件/image%202.png)

- 按图示点击，可以查看百度对应的证书

![image\.png](图片和附件/image%2011.png)

- 此时可以查看到baidu由权威机构颁发的官方证书，并且权威机构的加密更加严格

- 通过权威机构的认可，可以知道这里的百度是真实的百度

![image\.png](图片和附件/image%2012.png)

# SSH证书登录

- ssh是一种网络协议

    - 可以使用加密的方式登录到支持命令行管理的服务器。比如：Linux、路由器、交换机等等

    - 传输文件

    ### 开通隧道代理

    - 通过隧道连接，可以转换自己的IP地址。

    - 开启隧道

![image\.png](图片和附件/image%201.png)

    - 操作完成后可以打开命令行查询是否开启对应端口`netstat -ano | findstr :10086`

    - 打开浏览器，下载插件`zero omega`，启动对应隧道设置

![image\.png](图片和附件/image%2020.png)

    - 选择好对应国外服务器可以达到访问外网的目的，但是速度极其缓慢

## ssh提供两种认证方式

### 密码

- 密码需要足够的复杂，不然公网服务器特别容易被爆破

- 这里检测用的是yakit，选择`安全工具`里面的`弱口令爆破`选择`ssh`输入对应的参数，可以爆破本地虚拟机查看。

![image\.png](图片和附件/image%2021.png)

- 可以爆破出简单账户密码


![image\.png](图片和附件/image.png)

    - 这里爆破的内容会被放在/var/log/messages的文件中

### 密钥

- 使用数字签名，安全性非常高

- 往服务器上传公钥，然后在连接时候，本机使用私钥加密一些信息，比如时间等，如果服务器能用公钥解开，就证明你是拥有私钥的用户

- 本地生成密钥对

```C
==========此演示在windows的cmd中进行==========
C:\Users\simid>ssh-keygen
Generating public/private ed25519 key pair.
Enter file in which to save the key (C:\Users\simid/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in C:\Users\simid/.ssh/id_ed25519    # 私钥位置
Your public key has been saved in C:\Users\simid/.ssh/id_ed25519.pub    # 公钥位置
The key fingerprint is:
SHA256:/JgYKxJdJz72CA0wITY4dpDGV8Q6KfwY/PypJ79H/sg simid@MIBOOK
The key's randomart image is:
+--[ED25519 256]--+
|++*.+o           |
|+*.= .           |
|=.o + o .        |
| = = = +         |
|  O + * S        |
| . = o O +       |
|  . o B + .      |
|   o =.o.        |
|   .=ooE..       |
+----[SHA256]-----+
```

- 服务器开启证书登录功能

    - 如果存在编辑后不能证书登录的情况，删除原本密钥并重新生成一份

```C
[root@localhost ~]# vim /etc/ssh/sshd_config    # 编辑ssh的配置文件
.......
PubkeyAuthentication yes            # 允许使用公钥登录
AuthorizedKeysFile      .ssh/authorized_keys        # 公钥存放的位置
.............
[root@localhost ~]# systemctl restart sshd        # 重启ssh服务
```

- 公钥保存在用户家目录的`.ssh/authorized_keys`文件中，你想登录什么用户，这个文件就放在什么用户家目录

```C
[root@localhost ~]# vim .ssh/authorized_keys
把之前本地产生的公钥，复制过来，注意按i进入插入模式
```

- 在xshell上，可以将证书文件导入

    - 选择连接的属性，点击用户身份验证，用户密钥，浏览，导入私钥

![image\.png](图片和附件/image%2013.png)

- 为了安全，可以禁止使用密码登录

```C
[root@localhost ~]# vim /etc/ssh/sshd_config        # 进入ssh的配置文件
.......
PasswordAuthentication no
.......

[root@localhost ~]# systemctl restart sshd        # 重启sshd服务
```

- 如果使用公钥登录其他用户，比如登录user01

    - 将公钥放入到对应的用户家目录下

    - 登录时使用对应的用户名，就不需要密码了

```C
[root@localhost ~]# useradd user01
[root@localhost ~]# cd /home/user01/
[root@localhost user01]# mkdir .ssh
[root@localhost user01]# mv ~/.ssh/authorized_keys .ssh/    # 将公钥放入到用户的家目录下
```

# samba文件服务器

- 传统远程管理Linux文件

    - xshell等工具，ssh登录之后，进行文件操作

    - 通过`lrzsz` 这样的工具，上传下载文件

        - `yum -y install lrzsz`

        - `rz` 上传文件到当前目录

        - `sz 文件名` 下载文件到本机

- 通过scp命令，可以上传下载文件

    - `scp <本地文件> root@192.168.173.128:/root/` 表示将本地文件，传到服务器的/root/目录下

    - 如果scp操作是整个文件夹，需要加上`-r` 

    - `scp` 命令常用于服务器文件备份，加入到任务计划周期性执行

```C
=====在windows上传文件到服务器======
C:\Users\simid\Desktop>scp ToDesk_Lite.exe root@192.168.173.128:/root
root@192.168.173.128's password:
ToDesk_Lite.exe                                                                       100%   25MB  46.3MB/s   00:00

=====在windows上下载服务器上的文件=====
C:\Users\simid\Desktop>scp root@192.168.173.128:/root/anaconda-ks.cfg .
root@192.168.173.128's password:
anaconda-ks.cfg                                                                       100%  907   126.5KB/s   00:00
```

## 文件共享服务器

- 将服务器打造为文件共享服务器，就需要samba这样的服务，而不是scp之类的工具

```C
[root@localhost ~]# yum -y install samba samba-client        # 安装samba服务端和客户端，服务器安装服务端即可，windows自带客户端
[root@localhost ~]# systemctl enable --now smb            # 启动smb服务
[root@localhost ~]# useradd -s /sbin/nologin smbuser01    # 创建一个无法登录系统的用户，-s即-shell指定用户登录默认的shell
[root@localhost ~]# passwd smbuser01                    # 设置一个密码
[root@localhost ~]# smbpasswd -a smbuser01            # 设置一个smb专用密码,-a即-add
New SMB password:
Retype new SMB password:
Added user smbuser01.
[root@localhost ~]# smbpasswd -e smbuser01            # 启用此用户,-e即-enable启用
Enabled user smbuser01.
[root@localhost ~]# groupadd smbgroup                    # 创建smbgroup组，为了方便多用户公用一个文件夹
# usermod修改用户属性，-a=append追加，-G=groups设置附加组
[root@localhost ~]# usermod -aG smbgroup smbuser01
[root@localhost ~]# smbpasswd smbuser01            # 修改已存在的用户密码
[root@localhost ~]# pdbedit -L -v            # 查看已经添加的smb用户列表


[root@localhost ~]# mkdir -p /data/samba                    # 新建一个目录，用于共享文件
# chown修改文件/目录的属主和属组,-R=recursive递归，对目录下所有子文件一起修改
[root@localhost ~]# chown -R smbuser01:smbgroup /data/samba/    # 设置用户和组的权限

[root@localhost ~]# vim /etc/samba/smb.conf            # 修改smb配置文件
.......
[shared]
       comment = Inmind NAS        # 描述信息
       path = /data/samba            # 访问的目录
       browseable = yes                # 是否可浏览
       writable = yes                # 是否可以写
       valid users = @smbgroup        # 有效的用户
       create mask = 0660            # 创建文件的默认权限
       directory mask = 0775        # 目录的默认权限
[root@localhost ~]# systemctl disable --now firewalld.service        # 关闭防火墙
[root@localhost ~]# setenforce 0            # 关闭selinux
[root@localhost ~]# systemctl restart smb
[root@localhost ~]# systemctl restart nmb
```

- 在windows上尝试连接

![image\.png](图片和附件/image%2018.png)

![image\.png](图片和附件/image%204.png)

- 在shared中创建的文件，会在`/data/samba`目录下，在smbuser01中创建的文件，会出现在smbuser01的家目录下

- 可以长期挂载到windows，对此电脑右键，映射网络驱动器

![image\.png](图片和附件/image%206.png)

![image\.png](图片和附件/image%207.png)

![image\.png](图片和附件/image%2015.png)

# HTTP协议

- HTTP超文本传输协议，是用于在客户端\(浏览器，各种小程序，各种手机APP\)和服务器之间传输超文本\(如HTML\)的应用层协议

    - 无状态

        - 每次发送HTTP都和上次发送接收无关

    - 基于TCP传输，使用端口号80

- HTTP版本

    - 0\.9：只支持GET方法，只能访问HTML资源

    - 1\.0：支持POST和GET方法，支持MIME多种格式，支持缓存，只支持TCP短连接\(数据发送结束，就断开\)

    - 1\.1：支持持久连接\(长连接\)，一个TCP连接允许支持多个请求，新增PUT，PATCH方法

    - 2\.0：提升性能，新的二进制格式，支持多路复用，Header压缩，服务端推送\(ws\)

        - 举例：https://eaglercraft\.ir/zh/

## URL

- 统一资源定位符，用于描述资源地址

    - 获取对应的url可以右键点击`在新标签页中打开`

```Python
https://iproute.cn/medias/logo.png
协议://域名或IP地址/资源路径/文件名
```

## HTTP消息结构

![image\.png](图片和附件/image%2022.png)

### 请求头部

![image\.png](图片和附件/image%2016.png)

![image\.png](图片和附件/image%205.png)

- GET请求案例

    - 右键网页点击检查，切换到网络部分，即可查询到标头等信息

![image\.png](图片和附件/image%2023.png)

    - 主要用于向服务器获取资源

```Bash
GET / HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
Cache-Control: max-age=0
Host: book.inmind-lab.com
Proxy-Connection: keep-alive
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36
```

- Host: book\.inmind\-lab\.com

    - 标识请求的主机名是什么

- User\-Agent: Mozilla/5\.0 \(Windows NT 10\.0; Win64; x64\) AppleWebKit/537\.36 \(KHTML, like Gecko\) Chrome/138\.0\.0\.0 Safari/537\.36

    - 标识当前发起请求的客户端信息，包含操作系统和浏览器内核

        - 浏览器通过这里的信息查看你是否是机器人，使用windows的命令行curl访问网站会被拦截，但是如果使用curl的同时携带UA就会避免

    - 点击左上角图标，还可以切换手机仿真

![image\.png](图片和附件/image%2024.png)

- 请求头部属性大全：[http://tools\.jb51\.net/table/http\_header](http://tools.jb51.net/table/http_header)

- POST请求案例

    - 主要用于向服务器提交数据，不仅限于文本

```Bash
POST /login.php HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
Cache-Control: max-age=0
Content-Length: 34
Content-Type: application/x-www-form-urlencoded
Host: ctf.iproute.cn:41170
Origin: http://ctf.iproute.cn:41170
Proxy-Connection: keep-alive
Referer: http://ctf.iproute.cn:41170/
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36

username=miao&password=miaomiao%7E
```

### 响应头部

![image\.png](图片和附件/image%2014.png)

![image\.png](图片和附件/image%203.png)

- 案例

```Bash
HTTP/1.1 200 OK
Connection: close
Transfer-Encoding: chunked
Content-Encoding: gzip
Content-Type: text/html; charset=UTF-8
Date: Wed, 23 Jul 2025 03:30:56 GMT
Server: nginx/1.18.0 (Ubuntu)
```

- 状态码用于表示此次请求响应的结果

    - 100\-199：指示信息，请求已经收到，正在处理，别着急

    - 200\-299：成功

    - 300\-399：重定向，请求必须要访问另外一个地方的资源才可以完成

    - 400\-499：客户端错误，请求无法实现

    - 500\-599：服务器错误，服务器内部无法实现

- 常见状态码

    - 200：请求成功

    - 400：客户端访问错误，但是不告诉你具体是什么

    - 401：请求未经授权，登录失败，仅限使用web服务器提供的认证功能

    - 403：服务器收到请求，但是拒绝提供服务，往往是没权限访问这个资源

    - 404：服务器收到请求，但是请求的资源不存在

    - 500：服务器内部错误，但是不告诉你具体是什么

    - 503：服务器发生了内部错误，一般是后端代码出问题了

- 状态码大全：[http://tools\.jb51\.net/table/http\_status\_code](http://tools.jb51.net/table/http_status_code)

