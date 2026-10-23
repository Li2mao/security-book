# Day3

# ACL\(Acess Control List\|\|访问控制列表\)

1. 对流量进行过滤

2. 对路由条目进行过滤

3. 访问控制列表不能过滤自己产生的包，管别人，不管自家

## 类型

1. 标准访问控制列表（列表编号1\-99）

2. 扩展访问控制列表（列表编号100\-199）

## 配置环境异常如何重启

1. 重启pnet服务

2. 登录ssh重启容器

    1. 建立一个新的xshell标签，并且使用指令`ssh root@服务器对应IP`登录对应的服务器

![image\.png](图片和附件/image%2011.png)

    2. 最后输入指令`systemctl restart docker`重启容器\(成功后pnet的docker容器全部重启\)

![image\.png](图片和附件/image%2014.png)

## 标准访问控制列表

1. 只能对流量的源IP地址进行匹配

2. 默认情况下acl没有匹配上的行为是deny

3. 由于只能匹配源IP，影响较大，所以尽量靠近目的地

4. `sh run`可以查看历史配置记录

5. `show ip access-lists 数字`显示该ACL的过滤内容

![image\.png](图片和附件/image%2012.png)

- 命令配置

```XML
=============R1=============
hostname R1

interface Ethernet0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
interface Ethernet0/1
 ip address 192.168.12.1 255.255.255.0
 no shutdown
 
router rip            # 动态路由协议
 network 192.168.1.0        # 参与动态路由协议的条目
 network 192.168.12.0
 
=============R2==============
hostname R2

interface Ethernet0/0
 ip address 192.168.12.2 255.255.255.0
 no shutdown
interface Ethernet0/1
 ip address 192.168.23.2 255.255.255.0
 no shutdown

router rip
 network 192.168.12.0
 network 192.168.23.0

============R3===========
hostname R3

interface Ethernet0/0
 ip address 192.168.23.3 255.255.255.0
 no shutdown
interface Ethernet0/1
 ip address 192.168.2.1 255.255.255.0
 no shutdown

router rip
 network 192.168.2.0
 network 192.168.23.0
```

- 测试

    - 在没有任何策略之前，PC是可以访问webserver

![image\.png](图片和附件/image%208.png)

    - 在R3上加上拦截策略

    ```XML
    access-list 1 deny 192.168.1.0 /24
    access-list 1 permit any    #标准的访问控制列表默认是拒绝所有，所以加上允许指令
    
    interface Ethernet0/1    #定义的策略要在选定的端口上进行
    ip access-group 1 out    #这里的out或者是in指的是网络的出入
    ```

- 再次测试

![image\.png](图片和附件/image%2010.png)

这种方式的拦截范围模糊，会拦截所有来自`192.168.1.0  /24`网段的服务。

- 删除过滤

```XML
int e0/1
no ip access-group 1 out
```

## 扩展访问控制列表

1. 可以匹配源或者目的地的流量

2. 可以匹配TCP或者UDP的具体端口

3. 没有被匹配上的会被deny

![image\.png](图片和附件/image%2021.png)

- 禁止所有人可以ping通webserver，但是不影响网站访问,在R3上配置

```XML
access-list 100 deny icmp any host 192.168.2.2 echo    #icmp就是ping使用的协议，echo是ping的请求，阻止任何来自192.168.2.2机器的icmp协议下的echo请求
access-list 100 permit ip any any

int e0/1
ip access-group 100 out
```

- 测试

![image\.png](图片和附件/image%2017.png)

- 允许除了`192.168.1.2`以外的IP地址访问`webserver`，在R3上配置

- 如果直接配置

```XML
R3(config)#access-list 100 deny tcp host 192.168.1.2 host 192.168.2.2 eq 80    #直接过滤80端口的访问

#查看acl的匹配顺序
R3#sh ip access-lists 100
Extended IP access list 100
    10 deny icmp any host 192.168.2.2 echo (6 matches)
    20 permit ip any any (16 matches)                #此处已将所有流量放行，所以下面一条规则无效
    30 deny tcp host 192.168.1.2 host 192.168.2.2 eq www

```

- 调整顺序

```XML
R3(config)#ip access-list extend 100
R3(config-ext-nacl)#no 30    #删除30的规则
R3(config-ext-nacl)#15 deny tcp host 192.168.1.2 host 192.168.2.2 eq www    #加一个15的规则

R3#show ip access-lists 100
Extended IP access list 100
    10 deny icmp any host 192.168.2.2 echo (6 matches)
    15 deny tcp host 192.168.1.2 host 192.168.2.2 eq www
    20 permit ip any any (16 matches)    #只有前面都匹配不上，才会被放行
```

- 测试

    - 直接使用192\.168\.1\.2的地址，无法ping也无法访问网站

    - 换一个192\.168\.1\.233的地址，就可以访问

# telnet远程命令行工具

- 在目标主机上配置

```XML
en
conf t
line virtual terminal 0 4    #开启虚拟控制台0~4
password cisco    #配置登录密码cisco
login    #开启密码校验
transport input talent    #允许telnet协议
```

- 验证登录

```XML
telnet 192.168.23.3    #目标IP地址
输入密码
q    #退出
```

## 安全性

telnet很危险，通过wireshark抓包，过滤telnet，从某一个由源地址发给目的地址的指令开始，就会出现密码。

![image\.png](图片和附件/image%2020.png)

# NAT\(Network Address Translation\)

将局域网内部的IP地址转换为路由器上的公网IP地址并附带上端口号，从而用公网的IP去访问互联网上的服务，内网的私有IP不被互联网认可，所以采用NAT的形式，可出不可进，起到一定的保护作用。

## SNAT\(源地址NAT\)

- 访问外部且不可被外部访问

1. ipv4资源已经枯竭，现在个人网络通信使用的都是私有IP地址，并且通过NAT技术复用一个公网IP

2. NAT设备可以充当防火墙，保护内网安全，公共网络无法直接访问内部的地址

3. 解决地址冲突

4. 发布内网的服务

5. 负载均衡

![image\.png](图片和附件/image%2018.png)

- 其中R2的e0/1接口连接的是家庭内网，内网IP无法上网

- R2的e0/0是连接运营商\(移动、联通、电信\)，得到地址可以上网

- 为了保障家庭内网也可以上网，R2需要配置NAT

```XML
=======R1============
ho R1
int e0/1
ip add 192.168.12.1 255.255.255.0
no sh
```

- 配置家庭网关

```XML
======R2=============
ho R2
int e0/0
ip add 192.168.12.2 255.255.255.0
ip nat outside
no sh
int e0/1
ip add 192.168.1.1 255.255.255.0
ip nat inside
no sh
ip route 0.0.0.0 0.0.0.0 192.168.12.1
access-list 1 permit 192.168.1.0 /24
ip nat inside source list 1 int e0/0 overload
```

- 检查是否成功

![image\.png](图片和附件/image.png)

- 抓包检查，确认去往外部网络的原地址，已经被替换为R2的e0/0接口

![image\.png](图片和附件/image%2013.png)

- 为了实现多台电脑共享一个IP地址对外上网，使用不同的端口号进行区分

## DNAT\(目的地址NAT\)

- 被外部访问

![image\.png](图片和附件/image%207.png)

- R6作为企业的网关，需要承担以下几个任务

    - 为内网设备提供SNAT（给内网设备提供上外网的能力）

    - 为内网的服务器提供DNAT（为服务器提供端口映射，将内部某个地址的端口映射到公网可以被访问的IP上）

    ```XML
    ==========R6==============
    hostname R6
    
    interface Ethernet0/0
     ip address 192.168.16.6 255.255.255.0
     ip nat outside
     no shutdown
    interface Ethernet0/1
     ip address 192.168.2.1 255.255.255.0
     ip nat inside
     no shutdown
     
     ip route 0.0.0.0 0.0.0.0 192.168.16.1
     
     ======下面是SNAT的配置，保障内部可以上网=============
     access-list 1 permit 192.168.2.0 /24
     ip nat inside source list 1 interface Ethernet0/0 overload
     
     ======下面是DNAT的配置，提供服务器的端口映射================
     ip nat inside source static tcp 192.168.2.2 80 interface Ethernet0/0 8080
     ip nat inside source static tcp 192.168.2.3 80 interface Ethernet0/0 8081
    ```

- 检验效果

![image\.png](图片和附件/image%2019.png)

![image\.png](图片和附件/image%204.png)

如果想改变webserver的网页内容，可以点开weberver输入下面命令

```XML
echo "<h1>in webserver? ...</h1>" > /var/www/html/index.html
```

## TCP负载均衡（扩展）

- 复用DNAT的一个端口，将请求分摊到多个设备上来处理

- 在R6上配置

```XML
=========删除旧的DNAT配置=============
R6#clear ip nat translation *    #清除所有的旧NAT表，否则可能会冲突
R6#conf t

R6(config)#no ip nat inside source static tcp 192.168.2.2 80 interface Ethernet0/0 8080    #外网访问路由器的8080端口转换为内网的192.168.2.2
R6(config)#no ip nat inside source static tcp 192.168.2.3 80 interface Ethernet0/0 8081

! 创建服务器轮询池（命名为 WEB_POOL）
R6(config)# ip nat pool WEB_POOL 192.168.2.2 192.168.2.3 prefix-length 24 type rotary    #prefix-length表示子网掩码255.255.255.0；type rotary表示轮询负载均衡
! 定义访问控制列表（匹配外部访问流量）
R6(config)# access-list 100 permit tcp any host 192.168.16.6 eq 80    #任意外网主句访问80端口
! 将ACL与轮询池绑定，启用目标地址转换
R6(config)# ip nat inside destination list 100 pool WEB_POOL    #inside destination是目的地址转换为100这个轮换池
```

- 测试，多次访问`192.168.16.6`可以发现访问的服务器不一样

![image\.png](图片和附件/image%2016.png)

![image\.png](图片和附件/image%202.png)

# DHCP\(动态主机配置协议\)

- 工作在局域网中，使用UDP协议工作

- 为内部网络自动分配IP地址相关信息

- 作为管理内部主机的一种技术手段

## DHCP地址分配

![image\.png](图片和附件/image%205.png)

- R1作为网关设备，由于模拟器的特点，NAT已经自动实现，不需要额外配置

- R1的e0/1配置`192.168.1.1/24`，并且项次网络开启DHCP

```XML
no cdp run    #关闭思科发现协议，此协议会自动发现接口半双工状态，并且不停提示

int e0/1
ip add 192.168.1.1 255.255.255.0
duplex full    #开启接口全双工，保持与交换机一致

ip dhcp pool inmind    #配置一个名为inmind的地址池
network 192.168.1.0 /24    #在地址池中放入一些IP，如果此设备（网关设备）上存在此IP范围的地址，就会自动在那个接口上开启DHCP
default-router 192.168.1.1    #默认网关是192.168.1.1
exit

ip dhcp excluded-address 192.168.1.1    #排除网关地址，避免网关地址被分配出去
```

- 查看地址分配情况

    - 可以通过PC上的命令行查看，在linux上是`ifconfig`

![image\.png](图片和附件/image%203.png)

    - 或者在网关路由器上通过命令`show ip dhcp binding`查看

![image\.png](图片和附件/image%2022.png)

- 如果PC没有得到IP，尝试重启PC（一段时间PC得不到IP，PC就不回去尝试再次获得IP）

- 获取dhcp池的信息：`sh run | sec dhcp`

### 全双工和半双工

- 半双工

同一时间，只能发或者只能收，不能同时

像对讲机：你说我不能说，我说你不能说，轮流来。

半双工：早期共享式集线器、老式 Wi\-Fi 常见

- 全双工

可以同时发、同时收，互不干扰

像打电话：你说话我也能说话，两边同时进行。

全双工：现在交换机、网线、光纤基本都是全双工，速度更快、不冲突

- 查询方式

可以在电脑中`win+r`输入`ncpa.cpl`，进入网络连接配置界面，找到有线网的配置选择`高级`中就可以看到连接方式。

![image\.png](图片和附件/image%201.png)

## DHCP静态地址绑定

- 如果内网存在一些设备的IP地址需要进行固定，比如网络打印机

- 可以通过MAC地址进行绑定

```XML
clear ip dhcp binding *    #在进行静态地址绑定之前要先把之前给分配的动态地址清空，否则会产生IP地址存在而不能设定静态IP的情况发生
sh ip dhcp binding    #先查看对应的设备是用什么信息得到的IP，可能有MAC地址，Client-ID,或者Username
Bindings from all pools not associated with VRF:
IP address          Client-ID/                     Lease expiration        Type
                    Hardware address/
                    User name
192.168.1.2         5000.0003.0001          Apr 12 2026 05:53 AM    Automatic
192.168.1.3         5000.0004.0001          Apr 12 2026 05:53 AM    Automatic

ip dhcp pool printer    #单独为此设备创建一个名为printer地址池
host 192.168.1.233 255.255.255.0
hardware-address 5000.0004.0001    #使用设备得到IP的信息，进行绑定
```

- 重启设备的网卡（pnet模拟的话直接重启设备即可）

![image\.png](图片和附件/image%2015.png)

## DHCP续租机制

- DHCP分配的IP地址，只要动态分配就有一个租约时间，在Cisco路由器上这个时间默认是一天。可以手动修改。

![image\.png](图片和附件/image%206.png)

- 如果续租成功了，那么从续租那一刻起重新计算租约时间。

## 关于DNS服务器

空着 = 自动获取运营商 DNS

手动填 = 强制替换成更好的 DNS

- 常见好用的 DNS 地址

    - 国内通用：114\.114\.114\.114 备选:114\.114\.115\.115

    - 谷歌 DNS：8\.8\.8\.8 备选：8\.8\.4\.4

    - 阿里云 DNS：223\.5\.5\.5   备选：223\.6\.6\.6

    - 腾讯 DNS：119\.29\.29\.29

- 给自己的电脑配置DNS

![image\.png](图片和附件/image%209.png)

查看linux中的dns指令`cat /etc/resolv.conf`



