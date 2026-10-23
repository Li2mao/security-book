# Day3

# 虚拟机网络介绍

![image\.png](图片和附件/image%208.png)

## 虚拟机与网关

- 虚拟机可以存在windows登录不上去但是正常联网的情况

- 此时需要查看win\+r输入ncpa\.cpl查看网口，是否存在VMNET8，并且查看是否有IP地址

![image\.png](图片和附件/image%205.png)

## 虚拟机DHCP续租时间延长

1. 点击编辑，虚拟网络编辑器，点击更改设置

![image\.png](图片和附件/image%2016.png)

2. 点击VMNET8，点击DHCP设置，修改最长租用时间

![image\.png](图片和附件/image%202.png)

## 虚拟机常用模式

### 一句话对比

- 桥接：虚拟机和宿主机**同网段，局域网里一台独立电脑**

- NAT：虚拟机借宿主机 IP 上网，**宿主机当路由器**，外面找不到它

- 仅主机：只能虚拟机 ↔ 宿主机，**不能上外网**

![image\.png](图片和附件/image%2020.png)

### 仅主机模式

此时虚拟机通过虚拟网卡VMNET1和主机相连，没有网关，不可进行上网

### 桥接模式

虚拟机直接与WLAN相连，此时连接虚拟网卡VMNET0，

![image\.png](图片和附件/image%2011.png)

此时可以通过编辑虚拟网络编辑器，选择桥接的网卡，选择用哪个部分来连接WLAN

![image\.png](图片和附件/image%2013.png)

### NAT模式

**NAT = Network Address Translation 网络地址转换**

> 虚拟机通过**宿主机**上网，虚拟机藏在宿主机 IP 后面。
> 
> 

1. 虚拟机和宿主机在**独立内网网段**（VMware 虚拟子网，比如`192.168.x.x`）

2. 虚拟机**可以访问外网**（上网、ping 公网）

3. 虚拟机**能 ping 通宿主机**，宿主机也能访问虚拟机

4. **外部其他物理电脑默认不能主动访问虚拟机**（虚拟机被 NAT 隐藏）

5. 虚拟机之间互相连通

如果不想选择桥接模式，同时还想让外部访问你的WLAN，可以选择配置DNAT

![image\.png](图片和附件/image%2012.png)

## 修改VMNET虚拟机网段

- 如果修改乱了可以点击左下角的还原默认设置

![image\.png](图片和附件/image%2010.png)

# DNS

- 从域名到IP的映射协议

- 早期网络都用IP地址来远程访问，但是IP地址不好记忆，所以就把IP地址和网站名对应关系记录到一个地方

    - 早期用来记录IP地址和域名文件存放位置

        - `C:\Windows\System32\drivers\etc\hosts`

        - 每次上网前，先统一到一个地方下载这个hosts文件，更新最新的网站

        - 到目前为止，所有的系统都会优先处理hosts中的条目，`IP地址    域名` 格式来追加，一行一个

- 全球设立了公共DNS域名服务，每个域名解析到IP地址的记录都会存着，并且提供查询

    - 全球共有13个根DNS服务器，编号为A到M，分布在不同国家和地区，主要由美国、欧洲和亚洲的部分机构管理。

    - 中国有自己的根DNS服务器，国内常用的DNS地址

        - 114\.114\.114\.114  114\.114\.115\.115

        - 223\.5\.5\.5  223\.6\.6\.6

## 用途

在`C:\Windows\System32\drivers\etc\hosts`文件中进行修改

- 广告屏蔽

    - 将广告的网站绑定到127\.0\.0\.1可以不被访问

- 软件破解

    - 正规软件访问公司官网来查询是否到期，可以将公司网址绑定到127\.0\.0\.1从而失去对官网的访问，可以离线使用

- 黑客攻击

    - 将自己的网站和官方域名绑定在一起，从而使用户访问自己的钓鱼网站

## 递归DNS服务器

- 查询网址的时候会优先从递归DNS查询，如果有直接返回内容并附带缓存，短期内再次访问会直接访问成功，递归DNS查询不到，会查询上一级DNS服务器，直到查到为止。如果查询不到，则会返回查询失败。

- 目前由于国内封锁的问题，如果使用国内DNS服务器（例如：阿里云`223.5.5.5`），可能会导致查到CN根服务器之后无法再继续向上查询。如果想再进一步向上查询，可以把DNS解析地址改为谷歌的`8.8.8.8`。

    - DNS修改相关详情：[Day3](https://ocnbtdmgi539.feishu.cn/wiki/LC5zwU1oTiL6EvkBf15c9dYwnwc#share-M4XCdxKXRolAZvxSO70cUAdsncf)

![image\.png](图片和附件/image%2035.png)

## DNS查询命令

- nslookup

```C
# windows下查询域名对应的IP
C:\Users\simid>nslookup www.baidu.com
服务器:  public1.alidns.com
Address:  223.5.5.5

非权威应答:
名称:    www.a.shifen.com
Addresses:  240e:e9:6002:1fd:0:ff:b0e1:fe69
          240e:e9:6002:1ac:0:ff:b07e:36c5
          180.101.49.44
          180.101.51.73
Aliases:  www.baidu.com

# 在Linux上可能需要安装bind-utils软件包
[root@localhost ~]# yum -y install bind-utils
[root@localhost ~]# nslookup www.baidu.com
Server:                192.168.173.2
Address:        192.168.173.2#53

Non-authoritative answer:
www.baidu.com        canonical name = www.a.shifen.com.
Name:        www.a.shifen.com
Address: 180.101.51.73
Name:        www.a.shifen.com
Address: 180.101.49.44
Name:        www.a.shifen.com
Address: 2409:8c20:6:1794:0:ff:b080:87f0
Name:        www.a.shifen.com
Address: 2409:8c20:6:123c:0:ff:b0f6:b2d
```

- dig

```C
[root@localhost ~]# yum -y install bind-utils
[root@localhost ~]# dig www.baidu.com

; <<>> DiG 9.16.23-RH <<>> www.baidu.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43223
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; MBZ: 0x0005, udp: 4096
;; QUESTION SECTION:
;www.baidu.com.                        IN        A

;; ANSWER SECTION:
www.baidu.com.                5        IN        CNAME        www.a.shifen.com.
www.a.shifen.com.        5        IN        A        36.152.44.132
www.a.shifen.com.        5        IN        A        36.152.44.93

;; Query time: 2037 msec
;; SERVER: 192.168.173.2#53(192.168.173.2)
;; WHEN: Tue Jul 22 09:42:33 CST 2025
;; MSG SIZE  rcvd: 104
```

# Linux网络配置

## 图形化

- 使用图形化桌面

    - 不同的Linux图形化桌面，设置页面不一样

![image\.png](图片和附件/image%2032.png)

![image\.png](图片和附件/image%2023.png)

![image\.png](图片和附件/image%2022.png)

## 安装桌面

- 为Rocky Linux安装图形化桌面

```C
[root@localhost ~]# yum grouplist                # 查看系统可以安装的软件组
Last metadata expiration check: 0:04:33 ago on Tue Jul 22 09:41:18 2025.
Available Environment Groups:
   Server with GUI
   Server
   Workstation
   Custom Operating System
   Virtualization Host
Installed Environment Groups:
   Minimal Install
Available Groups:
   Legacy UNIX Compatibility
   Console Internet Tools
   Container Management
   Development Tools
   .NET Development
   Graphical Administration Tools
   Headless Management
   Network Servers
   RPM Development Tools
   Scientific Support
   Security Tools
   Smart Card Support
   System Tools
[root@localhost ~]# yum -y groupinstall "Server with GUI"    # 安装图形化的桌面
[root@localhost ~]# startx            # 临时启动图形化界面

==========开机自动启动图形化=============
[root@localhost ~]# systemctl set-default graphical.target    # 设置默认启动图形化界面
[root@localhost ~]# systemctl start gdm.service            # 启动图形化界面
```

- 使用`nmtui` 命令

    - 输入nmtui命令

![image\.png](图片和附件/image%2019.png)

![image\.png](图片和附件/image%2029.png)

![image\.png](图片和附件/image%2014.png)

![image\.png](图片和附件/image.png)

![image\.png](图片和附件/image%2027.png)

- 修改完配置之后，最好重启一下网卡，让配置生效

```C
[root@localhost ~]# ip a        # 先获取想要重启的网卡名字
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0c:29:2e:48:c6 brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 192.168.173.128/24 brd 192.168.173.255 scope global dynamic noprefixroute ens160
       valid_lft 1386sec preferred_lft 1386sec
    inet6 fe80::20c:29ff:fe2e:48c6/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether a2:de:00:db:fd:f6 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
[root@localhost ~]# nmcli device reapply ens160        # 重新应用ens160网卡的设置
Connection successfully reapplied to device 'ens160'.
[root@localhost ~]# nmcli connection reload ens160        # 重置ens160网卡的连接信息
```

## 命令行

- 修改配置文件

    - 红帽系列

        - Centos\\Rocky\\Fedora

        - `/etc/NetworkManager/system-connections/网卡名称.nmconnection`

    - debain系列

        - ubuntu\\kali\\uos

        - `/etc/network/interfaces`

```C
[root@localhost ~]# vim /etc/NetworkManager/system-connections/ens160.nmconnection
....
[ipv4]
address1=192.168.173.88/24,192.168.173.2        # 配置IP地址和网关
dns=223.5.5.5;223.6.6.6;                        # 配置DNS
method=manual                                    # 配置IP获取方式，manual是手动
....

[root@localhost ~]# nmcli d d ens160        # 关闭网卡
[root@localhost ~]# nmcli c r ens160        # 重新加载ens160的配置
[root@localhost ~]# nmcli d connect ens160    # 开启网卡
[root@localhost ~]# ip a show ens160            # 查看ens160的网卡配置
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0c:29:2e:48:c6 brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 192.168.173.88/24 brd 192.168.173.255 scope global noprefixroute ens160
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe2e:48c6/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
       
[root@localhost ~]# systemctl restart NetworkManager        # 重启网络服务器，也是可以让IP地址生效
[root@localhost ~]# nmcli d r ens160                        # 重置网卡可以让旧地址消失
```

## nmcli工具

- 网络管理工具

```C
[root@localhost ~]# nmcli device status        # 查看网卡的状态
DEVICE   TYPE      STATE                   CONNECTION 
ens160   ethernet  connected               ens160     
lo       loopback  connected (externally)  lo         
docker0  bridge    connected (externally)  docker0    
[root@localhost ~]# nmcli d s
DEVICE   TYPE      STATE                   CONNECTION 
ens160   ethernet  connected               ens160     
lo       loopback  connected (externally)  lo         
docker0  bridge    connected (externally)  docker0 
[root@localhost ~]# nmcli connection show
NAME     UUID                                  TYPE      DEVICE  
ens160   27dd7411-b011-382b-a0a9-bf6431880c76  ethernet  ens160  
lo       e3012474-d38b-4a93-88ae-aa53384216c3  loopback  lo      
docker0  967765f2-2c0e-4ad8-8070-0126adcbaea9  bridge    docker0

# 修改接口的IP地址 nmcli connect modify
[root@localhost ~]# nmcli con mod "ens160" ipv4.address 192.168.173.128/24 ipv4.gateway 192.168.173.2 ipv4.dns "223.5.5.5,223.6.6.6" ipv4.method manual
[root@localhost ~]# nmcli con mod "ens160" \
> ipv4.address 192.168.173.128/24 \
> ipv4.gateway 192.168.173.2 \
> ipv4.dns "223.5.5.5,223.6.6.6" \
> ipv4.method manual

[root@localhost ~]# nmcli connection down ens160        # 关闭ens160
[root@localhost ~]# nmcli connection up ens160          # 打开ens160
```

## ifconfig

`yum -y install net-tools`

- 用于显示或设置网卡

```C
[root@localhost ~]# yum -y install net-tools        # 安装网络工具箱
[root@localhost ~]# ifconfig ens160 up                # 开启ens160网卡
[root@localhost ~]# ifconfig ens160 down                # 关闭ens160网卡
[root@localhost ~]# ifconfig ens160 192.168.173.128        # 配置IP地址
[root@localhost ~]# ifconfig ens160 192.168.173.128 netmask 255.255.255.0        # 配置ip地址和子网掩码
```

## route

- 查看路由表

```C
root@Webserver:/home# route add default gw 192.168.12.254        # 添加默认路由
root@Webserver:/home# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         192.168.12.254  0.0.0.0         UG    0      0        0 eth1
10.177.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth0
192.168.12.0    0.0.0.0         255.255.255.0   U     0      0        0 eth1
```

# 计算机安全等级

![image\.png](图片和附件/image%2033.png)

# 防火墙

- Linux内核自带网络过滤器netfilter，但是并没有提供netfilter的交互方式。

- 我们使用netfilter必须通过配置工具来将策略引入netfilter。

## iptables

- 目前Linux最主流的防火墙配置工具

- 过滤数据包的方式

    - 源或目的端口号

    - 源或目的IP地址

    - 携带特殊标志\(flag\)的流量

    - 源或目的MAC地址

### 五链四表

- 五链

    - 将多个规则合在一起，变成一个链

    - 五链是基于流量的通过过程来制定的规则合集

![image\.png](图片和附件/image%2026.png)

- 四表

    - 四表是根据功能来制定的规则合集

    - 对应的功能策略只能在表所覆盖到的链上面配置

    - raw表

        - 用来确定是否对数据包进行状态跟踪

    - mangle表

        - 为数据包加上标记\(flag\)

    - nat表

        - 修改数据包中源或目的的IP或端口号的规则

    - filter表

        - 确定是否放行该数据包\(过滤\)

![image\.png](图片和附件/image%2034.png)

### 过滤流量

- 注意：在进行iptables设置之前要先关闭firewalld，两个防火墙配置工具不能同时生效

- 提示：这里并没有nginx绑定80端口的命令，因为nginx的配置文件中含有监听80端口的命令

- 在rockylinux上先部署一个网站

```Bash
# 先复制下面的命令，直接运行，解释后面的课程会细讲
yum -y install nginx
cd /usr/share/nginx/html/
rm -rf *
# 这里的curl -O中的-O表示下载下来的文件的名称默认为下面给的地址的最后一个文件名
# 如果是curl -o则需要指明文件名称，例如：curl -o myfile.tar.gz shturl.cc/MPQ2EQS9H8iaTQlgwT
curl -O http://eagleslab.f3322.net:8889/%E8%AF%BE%E7%A8%8B%E7%9B%B8%E5%85%B3%E8%BD%AF%E4%BB%B6/%E4%BA%91%E8%AE%A1%E7%AE%97%E8%AF%BE%E7%A8%8B/%E8%AF%BE%E7%A8%8B%E7%9B%B8%E5%85%B3%E6%96%87%E4%BB%B6/games.tar.gz
tar xzvf games.tar.gz    #这里的x表示extract提取,z表示gzip格式,v表示输出里面的每个文件名（可有可无）,f表示file给文件命名
mv games/* .
systemctl restart nginx
systemctl disable --now firewalld        # 关闭firewwalld防火墙配置工具

# 浏览器访问虚拟机的IP地址，发现无法访问
# 查看系统监听的端口，22是ssh，80是http
[root@localhost ~]# ss -ntl
State            Recv-Q           Send-Q                     Local Address:Port                     Peer Address:Port          Process           
LISTEN           0                128                              0.0.0.0:22                            0.0.0.0:*                               
LISTEN           0                511                              0.0.0.0:80                            0.0.0.0:*                               
LISTEN           0                128                                 [::]:22                               [::]:*   
```

- 查看iptables规则（类似于访问控制列表）

```C
[root@localhost ~]# iptables -F        # 先清空所有的规则
[root@localhost ~]# iptables -L INPUT -n        # 查看INPUT链上的规则，-L是list列出规则, -n不要DNS查找域名
Chain INPUT (policy ACCEPT)                    # 默认规则是放行
target     prot opt source               destination 
```

- 如果发生端口开放但是服务不被允许访问的情况，要检查防火墙的配置问题

![image\.png](图片和附件/image%2031.png)

```C
[root@localhost ~]# iptables -A INPUT -s 192.168.173.1 -p tcp --dport=80 -j DROP
# -A 表示在INPUT链上新增一条规则
# -s 表示源IP地址
# -p 表示协议，可以选tcp  udp   icmp（即ping命令）
# --dport 表示目的端口
# -j 表示执行动作   DROP(不回复)  REJECT(回复不可以)  ACCEPT(放行)  MQUERADE(地址转换)  自定义链名字

[root@localhost ~]# iptables -L INPUT -n        # 查看规则
Chain INPUT (policy ACCEPT)    # 这里的ACCEPT表示默认的规则是放行
target     prot opt source               destination         #下面的6表示协议数字，6是TCP，17是UDP
DROP       6    --  192.168.173.1        0.0.0.0/0            tcp dpt:80、

[root@localhost ~]# iptables -L INPUT -n --line-number        # 为规则加上编号
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1    DROP       6    --  192.168.173.1        0.0.0.0/0            tcp dpt:80

[root@localhost ~]# iptables -D INPUT 1            # -D删除INPUT链中的第一条规则

[root@localhost ~]# iptables -P INPUT DROP         # 修改INPUT链的默认规则，这里默认丢失的话ssh占用端口22也会失联
[root@localhost ~]# iptables -A INPUT -p tcp --dport 22 -j ACCEPT  # 单独放行ssh

[root@localhost ~]# iptables -L INPUT -n --line-number
Chain INPUT (policy DROP)
num  target     prot opt source               destination         
1    ACCEPT     6    --  192.168.173.1        0.0.0.0/0            tcp dpt:22
2    ACCEPT     6    --  192.168.173.1        0.0.0.0/0            tcp dpt:80
[root@localhost ~]# iptables -R INPUT 2 -p tcp --dport 80 -j ACCEPT    # 修改某条策略
[root@localhost ~]# iptables -L INPUT -n
Chain INPUT (policy DROP)
target     prot opt source               destination         
ACCEPT     6    --  192.168.173.1        0.0.0.0/0            tcp dpt:22
ACCEPT     6    --  0.0.0.0/0            0.0.0.0/0            tcp dpt:80
```

### 自定义链

- 主要目的是在规则较多的情况下，可以根据业务需要，将多个规则写在自定义链中

- 在现有的五链中把对应的流量交给自定义链处理

```C
[root@localhost ~]# iptables -N web_chain        # 创建新的自定义链，比如叫web_chain，用于存放web相关的策略
[root@localhost ~]# iptables -L web_chain -n
Chain web_chain (0 references)
target     prot opt source               destination         
[root@localhost ~]# iptables -A web_chain -p tcp -m multiport --dport 80,443 -j ACCEPT    # -m表示加载模块，multiport表示多端口
[root@localhost ~]# iptables -A INPUT -s 192.168.173.1 -j web_chain
[root@localhost ~]# iptables -L INPUT -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
web_chain  0    --  192.168.173.1        0.0.0.0/0           
[root@localhost ~]# iptables -L web_chain -n
Chain web_chain (1 references)
target     prot opt source               destination         
ACCEPT     6    --  0.0.0.0/0            0.0.0.0/0            multiport dports 80,443
```

### NAT

- Linux2本身没有网，通过Linux1的nat进行上网

![image\.png](图片和附件/image%201.png)

- 克隆出Linux2

![image\.png](图片和附件/image%203.png)

![image\.png](图片和附件/image%206.png)

![image\.png](图片和附件/image%209.png)

![image\.png](图片和附件/image%2025.png)

- 添加Linux1的网卡，用于连接Linux2

![image\.png](图片和附件/image%2015.png)

![image\.png](图片和附件/image%2028.png)

![image\.png](图片和附件/image%2024.png)

![image\.png](图片和附件/image%2021.png)

- 把Linux2的网卡也选择仅主机模式

![image\.png](图片和附件/image%2018.png)

- 给Linux2配置IP地址信息

    - 此命令是`nmtui`，修改完成之后输入`systemctl restart NetworkManager`

    - 或者使用`nmcli d r ens160`和`nmcli c r ens160`来重置网卡

    - 其中网关指向Linux1的仅主机模式网卡

![image\.png](图片和附件/image%2017.png)

- 如果发现连不上两个机器的仅主机模式的网卡，查看自己的网络适配器的VMNET1，查看一下是否在同一网段，不在的话修改IPV4的地址，切换成DHCP或者manual同一个网段

- 在Linux1上配置NAT

```C
# 开启流量转发功能，否则与本系统无关的流量会被丢弃
[root@Linux1 ~]# echo "net.ipv4.ip_forward=1" >> /usr/lib/sysctl.d/50-default.conf
[root@Linux1 ~]# sysctl -w net.ipv4.ip_forward=1
[root@Linux1 ~]# sysctl -p /usr/lib/sysctl.d/50-default.conf    # 此处必须要告知生效的配置文件位置，否则可能不应用配置文件

[root@localhost ~]# iptables -t nat -L POSTROUTING -n        # 查看NAT的规则
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  0    --  172.17.0.0/16        0.0.0.0/0         # 这条是docker引擎创建的

# 源地址是192.168.157.0/24就触发SNAT
[root@localhost ~]# iptables -t nat -A POSTROUTING -s 192.168.157.0/24 -j MASQUERADE    
[root@localhost ~]# iptables -t nat -L POSTROUTING -n
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  0    --  172.17.0.0/16        0.0.0.0/0           
MASQUERADE  0    --  192.168.157.0/24     0.0.0.0/0

# 在Linux2上进行测试
[root@Linux2 ~]# ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=127 time=45.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=127 time=51.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=127 time=42.3 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=127 time=53.6 ms
```

- 在Linux1上配置NAT

```C
# 开启流量转发功能，否则与本系统无关的流量会被丢弃
[root@Linux1 ~]# echo "net.ipv4.ip_forward=1" >> /usr/lib/sysctl.d/50-default.conf
[root@Linux1 ~]# sysctl -w net.ipv4.ip_forward=1
[root@Linux1 ~]# sysctl -p /usr/lib/sysctl.d/50-default.conf    # 此处必须要告知生效的配置文件位置，否则可能不应用配置文件
# 到这里时候Linux2使用ping命令发现无法ping通，但是可以抓到包

[root@localhost ~]# iptables -t nat -L POSTROUTING -n        # 查看NAT的规则,-t是table表，与功能相关就查看表
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  0    --  172.17.0.0/16        0.0.0.0/0         # 这条是docker引擎创建的

# 源地址是192.168.157.0/24就触发SNAT
[root@localhost ~]# iptables -t nat -A POSTROUTING -s 192.168.157.0/24 -j MASQUERADE    
[root@localhost ~]# iptables -t nat -L POSTROUTING -n
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  0    --  172.17.0.0/16        0.0.0.0/0           
MASQUERADE  0    --  192.168.157.0/24     0.0.0.0/0

# 在Linux2上进行测试
[root@Linux2 ~]# ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=127 time=45.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=127 time=51.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=127 time=42.3 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=127 time=53.6 ms
```

- 如果没有ping通8\.8\.8\.8。或者重启一下Linux1试一下

```MATLAB
# 检查FORWARD策略
[root@Linux1 ~]# iptables -L FORWARD -n
Chain FORWARD (policy DROP)    # 发现这里默认是丢弃，导致没有放行Linux2的网段转发规则
target     prot opt source               destination         
DOCKER-USER  0    --  0.0.0.0/0            0.0.0.0/0           
DOCKER-FORWARD  0    --  0.0.0.0/0            0.0.0.0/0   
[root@Linux1 ~]# iptables -P FORWARD ACCEPT    # 将默认权限改为ACCPET可以通过
# 也可以单独加一条自定义链，只放行和接收Linux2
[root@Linux2 ~]# ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=127 time=56.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=127 time=44.1 ms

```

- wireshark抓包

![image\.png](图片和附件/image%207.png)

- DNAT

    - 映射内网端口

```C
============在Linux2上部署一个网页==========
[root@Linux2 ~]# yum -y install nginx
[root@Linux2 ~]# systemctl start nginx
[root@Linux2 ~]# echo "in linux2..." > /usr/share/nginx/html/index.html 

#如果通过Linux1不可以curl到Linux2的网页内容，检查关闭防火墙
[root@Linux2 ~]# systemctl stop firewalld
[root@Linux2 ~]# systemctl disable firewalld

===========在Linux1上开启端口映射==========
# 将访问本机的80端口流量，转发到内网Linux2的80端口上，通过浏览器访问Linux1的80端口进行测试
[root@localhost ~]# iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.157.129:80

[root@localhost ~]# iptables -t nat -L PREROUTING -n --line-number 
Chain PREROUTING (policy ACCEPT)
num  target     prot opt source               destination         
1    DOCKER     all  --  0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL
2    DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:80 to:192.168.157.129:80
[root@localhost ~]# iptables -t nat -D PREROUTING 2
# 也可以尝试转发到另一个端口上，此时访问Linux1的10086端口就相当于访问Linux2的80
[root@localhost ~]# iptables -t nat -A PREROUTING -p tcp --dport 10086 -j DNAT --to-destination 192.168.157.129:80
```

### 保存配置

- iptables本身只是一个规则产生工具，一旦重启，规则就会消失

- 安装iptables服务

    - 此服务会在每次开机的时候，加载保存在`/etc/sysconfig/iptables-config`中的所有策略

    - 保存就是使用`iptables-save > /etc/sysconfig/iptables-config`

```C
===========方法一：使用iptables服务来维持命令==========
[root@localhost ~]# yum -y install iptables-services        # 安装iptables服务
[root@localhost ~]# systemctl enable --now iptables        # 设置iptables开机自动加载配置，并且现在立即生效
[root@localhost ~]# iptables-save > /etc/sysconfig/iptables-config    # 保存iptables的配置
#玩坏了可以用重新导入默认配置
iptables-restore < /etc/sysconfig/iptables-config
#如果两个机器之间还是不通，可能是下载iptables服务的时候他自己加了一些策略
vim /etc/sysconfig/iptables    #来查找里面不用的策略，注释掉
==========方法二：使用开启自动脚本来导入命令（推荐）==========
[root@localhost ~]# systemctl disable --now iptables        # 停止服务
# /etc/rc.local是开机自动脚本，这个文件中所有的命令都会在开机的被执行
[root@localhost ~]# echo "iptables-restore < /etc/sysconfig/iptables-config" >> /etc/rc.local
[root@localhost ~]# chmod +x /etc/rc.d/rc.local        # 让rc.local有可执行权限
[root@Linux1 ~]# reboot    #完成之后记得重启
```

- 如果Linux2还是ping不通外网，那么就看一下iptables策略，查看是否有一些REJECT策略没有关闭

```SQL
==============检查INPUT链策略=============
[root@Linux1 ~]# iptables -L INPUT -n --line-number
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED
2    ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           
3    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
4    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            state NEW tcp dpt:22
5    REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited
[root@Linux1 ~]# iptables -D INPUT 5

==============检查FORWARD链策略=============
[root@Linux1 ~]# iptables -L FORWARD -n --line-number
Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination         
1    DOCKER-USER  all  --  0.0.0.0/0            0.0.0.0/0           
2    DOCKER-FORWARD  all  --  0.0.0.0/0            0.0.0.0/0           
3    REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited
[root@Linux1 ~]# iptables -D FORWARD 3
```

## firewalld

- 是redhat系列Linux自带的防火墙

```C
=====先简简单单搭建一个网站页面========
[root@localhost ~]# mkdir webserver
[root@localhost ~]# cd webserver/
[root@localhost webserver]# echo "<h1>I'am Rocky Linux~</h1>" > index.html
[root@localhost webserver]# python3 -m http.server &        # 使用Python自带的http服务器功能，&的意思是后台运行
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
# 后台运行如果想要关闭的话，可以输入fg调到前台，然后ctrl+c打断

=====查看firewalld规则========
[root@localhost ~]# systemctl enable --now firewalld        # 启动firewalld
[root@localhost ~]# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: ens160                # 生效的接口
  sources: 
  services: cockpit dhcpv6-client ssh        # 允许的服务
  ports:                                     # 允许的端口
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules:
[root@localhost ~]# firewall-cmd --add-port=8000/tcp        # 放行8000端口，并未写入配置文件，立即生效
success
[root@localhost ~]# firewall-cmd --reload                    # 重新从配置加载规则，没有写入配置的策略都会失效
success
[root@localhost ~]# firewall-cmd --add-port=8000/tcp --permanent        # 将放行8000的策略写入配置文件，并不会生效
success
[root@localhost ~]# firewall-cmd --reload                    # 重新从配置加载规则，没有写入配置的策略都会失效
success
```

# SELinux

- 在Linux之上建立一个安全访问控制机制，不仅仅是网络，还有进程，文件都会被控制

```C
[root@localhost ~]# getenforce         # 查看SELinux的状态
Enforcing        # 开启状态
[root@localhost ~]# setenforce 0        # 0 Permissive  1 Enforcing 此设置临时有效
[root@localhost ~]# getenforce 
Permissive                            # 只做记录，不做任何阻止

[root@localhost ~]# vim /etc/selinux/config        # 修改配置文件可以永久有效
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
# 修改SELINUX=后面的值，就可以决定以后再次开机时候，SELinux工作状态

SELINUX=enforcing
```

- 为了安全，SELinux会限制某个文件能否成为网站目录

    - 网站是可以提供给互联网用户随意访问，所以认为网站服务是不安全，约束某个文件能够被网站访问是合理

    - 这里不成功的话把nginx关了`systemctl stop nginx`

```C
[root@localhost ~]# yum -y install httpd        # 安装apache，提供网页服务
[root@localhost ~]# systemctl start httpd        # 启动apache服务
[root@localhost ~]# firewall-cmd --add-port=80/tcp --permanent        # 防火墙放行80端口
success
[root@localhost ~]# firewall-cmd --reload
success
[root@localhost ~]# vim /var/www/html/index.html    # 放入一个主页文件在网站目录下
<h1>hahaha apache~</h1>
```

- 浏览器访问页面

![image\.png](图片和附件/image%204.png)

- 尝试自己创建网站根目录文件夹

```C
# 将原本的html目录重命名
[root@localhost ~]# cd /var/www/
[root@localhost www]# mv html{,.old}
[root@localhost www]# ls
cgi-bin  html.old

# 在root目录下创建好新的html目录，并且放置好网页文件，再放到/var/www目录下
[root@localhost www]# cd
[root@localhost ~]# mkdir html
[root@localhost ~]# vim html/index.html
<h1>in new html~</h1>
[root@localhost ~]# mv html/ /var/www/
[root@localhost ~]# cd /var/www/
[root@localhost www]# ls html
index.html
```

- 此时发现页面无法访问，提示没有权限

![image\.png](图片和附件/image%2030.png)

- 查看selinux的标签

    - 如果没有semanage指令：`dnf install -y policycoreutils-python-utils`

```C
[root@localhost www]# ls -Zd html
unconfined_u:object_r:admin_home_t:s0 html
[root@localhost www]# ls -Zd html.old/
system_u:object_r:httpd_sys_content_t:s0 html.old/        # 在www下面新建的目录，会携带httpd_sys_content_t

[root@localhost www]# semanage fcontext -a -t httpd_sys_content_t html    # 手动加上httpd的标签
[root@localhost www]# ls -Zd html            # 此时还未生效
unconfined_u:object_r:admin_home_t:s0 html
[root@localhost www]# restorecon -Rv html        # 更新一下规则
Relabeled /var/www/html from unconfined_u:object_r:admin_home_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0
Relabeled /var/www/html/index.html from unconfined_u:object_r:admin_home_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0
[root@localhost www]# ls -Zd html
unconfined_u:object_r:httpd_sys_content_t:s0 html
```

- 查看与http有关标签

```C
[root@localhost www]# getsebool -a | grep http
httpd_anon_write --> off
httpd_builtin_scripting --> on
httpd_can_check_spam --> off
httpd_can_connect_ftp --> off
httpd_can_connect_ldap --> off
httpd_can_connect_mythtv --> off
httpd_can_connect_zabbix --> off
httpd_can_manage_courier_spool --> off
httpd_can_network_connect --> off
httpd_can_network_connect_cobbler --> off
httpd_can_network_connect_db --> off
httpd_can_network_memcache --> off
httpd_can_network_relay --> off
httpd_can_sendmail --> off
httpd_dbus_avahi --> off
httpd_dbus_sssd --> off
httpd_dontaudit_search_dirs --> off
httpd_enable_cgi --> on
httpd_enable_ftp_server --> off
httpd_enable_homedirs --> off
httpd_execmem --> off
httpd_graceful_shutdown --> off
httpd_manage_ipa --> off
httpd_mod_auth_ntlm_winbind --> off
httpd_mod_auth_pam --> off
httpd_read_user_content --> off
httpd_run_ipa --> off
httpd_run_preupgrade --> off
httpd_run_stickshift --> off
httpd_serve_cobbler_files --> off
httpd_setrlimit --> off
httpd_ssi_exec --> off
httpd_sys_script_anon_write --> off
httpd_tmp_exec --> off
httpd_tty_comm --> off
httpd_unified --> off
httpd_use_cifs --> off
httpd_use_fusefs --> off
httpd_use_gpg --> off
httpd_use_nfs --> off
httpd_use_opencryptoki --> off
httpd_use_openstack --> off
httpd_use_sasl --> off
httpd_verify_dns --> off
mysql_connect_http --> off
named_tcp_bind_http_port --> off
prosody_bind_http_port --> off
```



