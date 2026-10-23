# Day4

# 动态路由协议

- 让路由器可以自动学习到网络中的路由条目

- RIP

    - 距离矢量 路由协议

- OSPF

    - 链路状态路由协议

# RIP

## RIPv1

- 无子网掩码

![image\.png](图片和附件/image%201.png)

- 配置

```SQL
==========R1===========
no

en
conf t
ho R1
no ip do lo
int e0/0
ip add 192.168.12.1 255.255.255.0
no sh
router rip
network 192.168.12.0
==========R2===========
no

en
conf t
ho R2
no ip do lo
int e0/0
ip add 192.168.12.2 255.255.255.0
no sh
int e0/1
ip add 192.168.23.2 255.255.255.0
no sh
router rip
network 192.168.12.0
network 192.168.23.0
==========R3===========
no

en
conf t
ho R3
no ip do lo
int e0/0
ip add 192.168.23.3 255.255.255.0
no sh
int e0/1
ip add 192.168.34.3 255.255.255.0
no sh
router rip
network 192.168.23.0
network 192.168.34.0
==========R4===========
no

en
conf t
ho R4
no ip do lo
int e0/0
ip add 192.168.34.4 255.255.255.0
no sh
router rip
network 192.168.34.0
```

- 检查

```SQL
R1#sh ip route
Codes: L - local, C - connected, S - static, R - RIP, M - mobile, B - BGP
       D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area 
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2
       i - IS-IS, su - IS-IS summary, L1 - IS-IS level-1, L2 - IS-IS level-2
       ia - IS-IS inter area, * - candidate default, U - per-user static route
       o - ODR, P - periodic downloaded static route, H - NHRP, l - LISP
       a - application route
       + - replicated route, % - next hop override, p - overrides from PfR

Gateway of last resort is not set

      192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.12.0/24 is directly connected, Ethernet0/0
L        192.168.12.1/32 is directly connected, Ethernet0/0
R     192.168.23.0/24 [120/1] via 192.168.12.2, 00:00:22, Ethernet0/0
R     192.168.34.0/24 [120/2] via 192.168.12.2, 00:00:22, Ethernet0/0
```

- 抓包，每隔30s，就收到一次RIP信息，路由表中关于此路由条目的记录就会归0

- RIP会将自己在路由表中所有学习到的条目，发送给被network匹配上的网络

- 通过抓包R1的e0/0接口，可以发现RIP每隔30s发送一次的传输方式是UDP，并且占用520端口。

- RIP为了知道目的局域网离自己多远，路由条目每经过一个路由器转发，Metric就会\+1，初始值是0

- Metric叫做度量值，用于衡量同一条路由不同路径学到的好坏，如果Metric是一样的就会负载均衡

- 在RIP中，为了防止路由环路，规定当Metric到达16跳的时候，就认为不可达，立即把这个条目删除

![image\.png](图片和附件/image%204.png)

- 当RIP路由器的某一个路由消失了，为了防止下一个路由器依旧认为这个条目存在，会立即发出此路由的更新，但是metric是16跳，意思是立即删除此路由

- 断开的必须是R3的e0/1接口，如果断开e0/1接口的话，由于RIP的保留机制，会导致R3到R4的路由条目依旧存在一段时间

![image\.png](图片和附件/image%208.png)

- 模拟路由器故障

- 在R2上，配置访问控制列表，阻止接收RIP的消息

    - 可以看到没有再收到更新消息的路由计时就不会清零

    - 180s左右，路由状态变为`is possibly down`

    - 240s左右，路由就会从路由表中消失

    ```XML
    access-list 100 deny   udp any eq rip any eq rip    #acces-list 100是ACL名称，deny拒绝，udp这个传输方式，any任何来源的，到eq rip端口的消息，以及此设备去往any任意目的地的，从eq rip端口出发的协议
    access-list 100 permit ip any any
    int e0/1
    ip access-group 100 in    #R2无法从e0/1再接收RIP更新消息
    
    R2#sh ip route
    ...
    R     192.168.34.0/24 [120/1] via 192.168.23.3, 00:03:02, Ethernet0/1    # 计时超过了30秒
    ```

## RIPv2

- RIPv2和v1并不兼容

- RIPv2发送路由信息的时候，会携带子网掩码

- 发送方式为组播，一般电脑不会接收

![image\.png](图片和附件/image%206.png)

- 配置命令

```XML
router rip
version 2
no auto-summary    #关闭RIPv2的默认自动汇总，不然RIPv2会根据IP地址ABC类，将子网掩码自动合并为/8,/16,/24
```

# 环回接口

环回接口是网络中一种重要的逻辑接口

## 定义

- 纯软件实现的逻辑接口，不依赖物理硬件

- 接口状态始终可以保持up，除非设备故障

- 可以创建很多个

- 通常配置为32位子网掩码`255.255.255.255`，因为他是一个虚拟的接口，只有R1认得他，不用和其他设备连接

## 作用

- 用于测试，可以用来模拟网络中的设备

- 用于路由器的标识，很多协议（比如OSPF,BGP等等）会使用IP地址来标识某台设备，如果使用物理接口不稳定

- 用于设备的管理接口，为了稳定

```XML
interface loopback 0    #环回接口启用后就是up的状态
```

# OSPF

- 距离矢量路由协议，比如RIP，特点是更新是传递路由表，路由表在每台路由器上都可以被二次处理，路由信息就会越来越失真。

- 距离矢量协议所有条目都是道听途说来得，容易篡改或者丢失

- RIP的网络规模不能大，不然会产生环路等一系列问题，RIP的网络收敛速度非常慢。

![image\.png](图片和附件/image%207.png)

```SQL
==========R1===========
no

en
conf t
ho R1
no ip do lo
int lo0    #环回接口，用于给OSPF提供稳定的Router-ID
ip add 1.1.1.1 255.255.255.255
int e0/0
ip add 192.168.12.1 255.255.255.0
no sh
router ospf 1    #启动ospf实例1
network 1.1.1.1 0.0.0.0 area 0    #将192.168.12.0/24加入ospf区域0中，注意这里的子网掩码是反过来的
network 192.168.12.0 0.0.0.255 area 0    
end
sh ip protocols    #查看路由协议的运行状态
==========R2===========
no 

en
conf t
ho R2
no ip do lo
int lo0
ip add 2.2.2.2 255.255.255.255
int e0/0
ip add 192.168.12.2 255.255.255.0
no sh
int e0/1
ip add 192.168.23.2 255.255.255.0
no sh
router ospf 1
network 2.2.2.2 0.0.0.0 area 0
network 192.168.12.0 0.0.0.255 area 0
network 192.168.23.0 0.0.0.255 area 0
end
sh ip protocols
==========R3===========
no

en
conf t
ho R3
no ip do lo
int lo0
ip add 3.3.3.3 255.255.255.255
int e0/0
ip add 192.168.23.3 255.255.255.0
no sh
int e0/1
ip add 192.168.34.3 255.255.255.0
no sh
router ospf 1
network 3.3.3.3 0.0.0.0 area 0
network 192.168.23.0 0.0.0.255 area 0
network 192.168.34.0 0.0.0.255 area 0
end
sh ip protocols
==========R4===========
no

en
conf t
ho R4
no ip do lo
int lo0
ip add 4.4.4.4 255.255.255.255
int e0/0
ip add 192.168.34.4 255.255.255.0
no sh
router ospf 1
network 4.4.4.4 0.0.0.0 area 0
network 192.168.34.0 0.0.0.255 area 0
end
sh ip protocols

```

- 检查

```SQL
R1#sh ip route
....
      1.0.0.0/32 is subnetted, 1 subnets
C        1.1.1.1 is directly connected, Loopback0
      2.0.0.0/32 is subnetted, 1 subnets
O        2.2.2.2 [110/11] via 192.168.12.2, 00:06:27, Ethernet0/0
      3.0.0.0/32 is subnetted, 1 subnets
O        3.3.3.3 [110/21] via 192.168.12.2, 00:00:23, Ethernet0/0
      4.0.0.0/32 is subnetted, 1 subnets
O        4.4.4.4 [110/31] via 192.168.12.2, 00:00:23, Ethernet0/0
      192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.12.0/24 is directly connected, Ethernet0/0
L        192.168.12.1/32 is directly connected, Ethernet0/0
O     192.168.23.0/24 [110/20] via 192.168.12.2, 00:00:23, Ethernet0/0
O     192.168.34.0/24 [110/30] via 192.168.12.2, 00:00:23, Ethernet0/0
```

## 链路状态路由原理

![image\.png](图片和附件/image%202.png)

- 每台路由器都会发布链路状态信息

    - 链路状态信息包含每个接口的IP地址以及宽带的度量值

- 链路状态信息最终会扩散到整个区域

- 根据链路状态信息，每台路由器都可以计算得到整个区域的拓扑图

- 使用SPF算法，可以计算出到达每个节点的最短路径

```XML
R1#sh ip ospf database     #查看路由器记录的链路状态数据库

            OSPF Router with ID (1.1.1.1) (Process ID 1)

                Router Link States (Area 0)

Link ID         ADV Router      Age         Seq#       Checksum Link count
1.1.1.1         1.1.1.1         26          0x80000004 0x0059C2 2
2.2.2.2         2.2.2.2         23          0x80000005 0x00C529 3
3.3.3.3         3.3.3.3         18          0x80000006 0x00139E 3
4.4.4.4         4.4.4.4         19          0x80000005 0x004B7A 2

R1#sh ip ospf database router 2.2.2.2    #查看某个路由器具体的链路状态

            OSPF Router with ID (1.1.1.1) (Process ID 1)

                Router Link States (Area 0)

  LS age: 131
  Options: (No TOS-capability, DC)
  LS Type: Router Links
  Link State ID: 2.2.2.2    #链路状态的ID
  Advertising Router: 2.2.2.2    #通告的路由器ID
  LS Seq Number: 80000005
  Checksum: 0xC529
  Length: 60
  Number of Links: 3    #通告有3条链路状态

    Link connected to: a Stub Network
     (Link ID) Network/subnet number: 2.2.2.2
     (Link Data) Network Mask: 255.255.255.255
      Number of MTID metrics: 0
       TOS 0 Metrics: 1    #带宽度量值，速率越小，数值越大

    Link connected to: a Transit Network
     (Link ID) Designated Router address: 192.168.23.3
     (Link Data) Router Interface address: 192.168.23.2
      Number of MTID metrics: 0
       TOS 0 Metrics: 10

    Link connected to: a Transit Network
     (Link ID) Designated Router address: 192.168.12.2
     (Link Data) Router Interface address: 192.168.12.2
      Number of MTID metrics: 0
       TOS 0 Metrics: 10
```

- 更加推荐的配置方法

```XML
R1(config)#no router ospf 1
R1(config)#int lo0
R1(config-if)#ip ospf 1 area 0    #将此接口加入OSPF
R1(config)#int e0/0
R1(config-if)#ip ospf 1 area 0
R1(config-if)#end

R2(config)#int range lo0, e0/0 - 1    #同时配置三个接口
R2(config-if-range)#ip ospf 1 area 0
R2(config-if-range)#end
```

## OSPF多区域

- 由于SPF算法会消耗一定的资源，如果OSPF网络过于庞大，会导致OSPF运行性能不佳。

- 解决SPF算法的最好方案是规划好区域。

- OSPF规定区域0是骨干区域，其他非0区域必须要和骨干区域直接相连

![image\.png](图片和附件/image%203.png)

```XML
=====R1=====
no router ospf 1
int range lo0, e0/0
ip ospf 1 area 1

=====R2======
no router ospf1
int rangelo0,e0/1
ip ospf 1 area 0
int e0/0
ip ospf 1 area 1

=====R3======
no router ospf 1
int range lo0, e0/0
ip ospf 1 area 0
int e0/1
ip ospf 1 area 2

======R4======
no router ospf 1
int range e0/0, lo0
ip ospf 1 area 2
```

- 检查

```SQL
R1#sh ip route
...
      1.0.0.0/32 is subnetted, 1 subnets
C        1.1.1.1 is directly connected, Loopback0
      2.0.0.0/32 is subnetted, 1 subnets
O IA     2.2.2.2 [110/11] via 192.168.12.2, 00:10:57, Ethernet0/0    #O代表ospf，IA表示在OSPF的其他区域
      3.0.0.0/32 is subnetted, 1 subnets
O IA     3.3.3.3 [110/21] via 192.168.12.2, 00:10:57, Ethernet0/0
      4.0.0.0/32 is subnetted, 1 subnets
O IA     4.4.4.4 [110/31] via 192.168.12.2, 00:07:04, Ethernet0/0
      192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.12.0/24 is directly connected, Ethernet0/0
L        192.168.12.1/32 is directly connected, Ethernet0/0
O IA  192.168.23.0/24 [110/20] via 192.168.12.2, 00:10:57, Ethernet0/0
O IA  192.168.34.0/24 [110/30] via 192.168.12.2, 00:08:16, Ethernet0/0

```

- 查看ospf的链路状态数据库

```XML
R1#sh ip ospf database

            OSPF Router with ID (1.1.1.1) (Process ID 1)

                Router Link States (Area 1)    #每台路由器都会产生描述链路状态，仅限本区域

Link ID         ADV Router      Age         Seq#       Checksum Link count
1.1.1.1         1.1.1.1         1164        0x80000003 0x0045D8 2
2.2.2.2         2.2.2.2         1162        0x80000002 0x00E049 1

                Net Link States (Area 1)    #每个局域网都会有一个，仅限本区域

Link ID         ADV Router      Age         Seq#       Checksum
192.168.12.1    1.1.1.1         1166        0x80000001 0x00C7EB

                Summary Net Link States (Area 1)    #由区域边界路由器，汇总其他区域的路由条目

Link ID         ADV Router      Age         Seq#       Checksum
2.2.2.2         2.2.2.2         1167        0x80000001 0x00FA31
3.3.3.3         2.2.2.2         1167        0x80000001 0x0031EC
4.4.4.4         2.2.2.2         931         0x80000001 0x0067A8
192.168.23.0    2.2.2.2         1167        0x80000001 0x0002A8
192.168.34.0    2.2.2.2         1003        0x80000003 0x00E8AA
```

- 非骨干区域是否可以使用一个区域号

    - 非骨干区域的区域号重复，不影响

```XML
=======R3=======
int e0/1
ip ospf 1 area 1
=======R4=======
int range e0/0, lo0
ip ospf 1 area 1

========检查R1路由条目===========
R1# sh ip route
......
      1.0.0.0/32 is subnetted, 1 subnets
C        1.1.1.1 is directly connected, Loopback0
      2.0.0.0/32 is subnetted, 1 subnets
O IA     2.2.2.2 [110/11] via 192.168.12.2, 00:25:34, Ethernet0/0
      3.0.0.0/32 is subnetted, 1 subnets
O IA     3.3.3.3 [110/21] via 192.168.12.2, 00:25:34, Ethernet0/0
      4.0.0.0/32 is subnetted, 1 subnets
O IA     4.4.4.4 [110/31] via 192.168.12.2, 00:00:24, Ethernet0/0
      192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.12.0/24 is directly connected, Ethernet0/0
L        192.168.12.1/32 is directly connected, Ethernet0/0
O IA  192.168.23.0/24 [110/20] via 192.168.12.2, 00:25:34, Ethernet0/0
O IA  192.168.34.0/24 [110/30] via 192.168.12.2, 00:01:26, Ethernet0/0
```

- 非骨干区域，如果不与骨干区域相连的后果

    - 只有区域边界路由器可以汇总其他区域的路由进行通告

    - 区域边界路由器，至少有一个接口属于骨干区域，才可以汇总路由

```XML
========R1=======
int range e0/0, lo0
ip ospf 1 area 0

=======R2=====
int range e0/0, lo0
ip ospf 1 area 0
int e0/1
ip ospf 1 area 1

=========R3=======
int range e0/0, lo0
ip ospf 1 area 1
int e0/1
ip ospf 1 area 2
========R4=======
int range e0/0, lo0
ip ospf 1 area 2
```

![image\.png](图片和附件/image.png)

# 综合实验

![image\.png](图片和附件/image%205.png)

- 该实验运用了之前学过的全部知识

- 配置

```SQL
=======R1=======
en
conf t
ho R1
no ip do lo    #关闭了域名解析，会导致ping qq.com的时候不会解析qq.com的域名，导致ping不通
int e0/2
ip add 192.168.116.1 255.255.255.0
no sh
int e0/1
ip add 192.168.12.1 255.255.255.0
no sh

ip dhcp pool PC16    #配置dhcp地址池
network 192.168.116.0 /24    
default-router 192.168.116.1    #默认路由
dns-server 223.5.5.5 223.6.6.6    #默认DNS

ip dhcp pool R2
network 192.168.12.0 /24
default-router 192.168.12.1
dns-server 223.5.5.5 223.6.6.6

end
sh ip int br 
=======R2=======
en
conf t
no ip do lo
ho R2

int e0/0
ip add dhcp
ip nat outside
no sh

int lo0    #环回接口
ip add 2.2.2.2 255.255.255.255
ip ospf 1 area 0

int e0/1
ip add 192.168.23.2 255.255.255.0
ip ospf 1 area 0
ip nat inside    #NAT地址转换协议
no sh

int e0/2
ip add 192.168.24.2 255.255.255.0
ip ospf 1 area 0
ip nat inside
no sh

int e0/3
ip add 192.168.27.2 255.255.255.0
ip ospf 1 area 0
ip nat inside
no sh

int e1/0
ip add 192.168.28.2 255.255.255.0
ip ospf 1 area 0
ip nat inside
no sh

router ospf 1
default-information originate always    #配置ospf其他走不通，就默认全部放行

access-list 1 permit 192.168.145.0 /24    #acl访问控制列表
access-list 1 permit 192.168.8.0 /24
access-list 1 permit 192.168.10.0 /24

ip nat inside source list 1 int e0/0 overload    #SNAT内部放行

ip dhcp pool PC15      #另一种SNAT配置
network 192.168.10.0 /24 
default-router 192.168.10.1
dns-server 223.5.5.5 223.6.6.6

end
sh ip int br   
=====================================
R2#sh ip int br
Interface                  IP-Address      OK? Method Status                Protocol
Ethernet0/0                192.168.12.5    YES DHCP   up                    up      
Ethernet0/1                192.168.23.2    YES manual up                    up      
Ethernet0/2                192.168.24.2    YES manual up                    up      
Ethernet0/3                192.168.27.2    YES manual up                    up      
Ethernet1/0                192.168.28.2    YES manual up                    up      
Ethernet1/1                unassigned      YES unset  administratively down down    
Ethernet1/2                unassigned      YES unset  administratively down down    
Ethernet1/3                unassigned      YES unset  administratively down down    
Loopback0                  2.2.2.2         YES manual up                    up      
NVI0                       192.168.12.5    YES unset  up                    up      
=====================================
conf t
access-list 2 permit 192.168.12.5 /32    #DNAT允许外部访问
ip nat pool WebServer 192.168.8.11 192.168.8.12 netmask 255.255.255.0 type rotary
ip nat inside destination list 2 pool WebServer

end
sh ip int br
=======R3=======
no

en
conf t
ho R3
no ip do lo

int lo0
ip add 3.3.3.3 255.255.255.255
ip ospf 1 area 0    #ospf配置

int e0/0
ip add 192.168.23.3 255.255.255.0
ip ospf 1 area 0
no sh

int e0/1
ip add 192.168.35.3 255.255.255.0
ip ospf 1 area 1
no sh

int e0/2
ip add 192.168.36.3 255.255.255.0
ip ospf 1 area 1
no sh

end
sh ip int br
=======R4=======
no

en
conf t
ho R4
no ip do lo

int lo0
ip add 4.4.4.4 255.255.255.255
ip ospf 1 area 0

int e0/0
ip add 192.168.24.4 255.255.255.0
ip ospf 1 area 0
no sh

int e0/1
ip add 192.168.49.4 255.255.255.0
ip ospf 1 area 2
no sh

int e0/2
ip add 192.168.104.4 255.255.255.0
ip ospf 1 area 2
no sh

end
sh ip int br
=======R5=======
no

en
conf t
ho R5
no ip do lo

int lo0
ip add 5.5.5.5 255.255.255.255
ip ospf 1 area 1

int e0/0
ip add 192.168.35.5 255.255.255.0
ip ospf 1 area 1
no sh

int e0/1
ip add 192.168.145.5 255.255.255.0
ip ospf 1 area 1
no sh

ip dhcp pool PC14
network 192.168.145.0 /24 
default-router 192.168.145.5    #ospf连接PC电脑时记得配置默认路由
dns-server 223.5.5.5 223.6.6.6

end
sh ip int br
=======R6=======
no 

en
conf t
ho R6

int lo0
ip add 6.6.6.6 255.255.255.255
ip ospf 1 area 1

int e0/0
ip add 192.168.36.6 255.255.255.0
ip ospf 1 area 1
no sh

end
sh ip int br
=======R7=======
no 

en
conf t
ho R7

int lo0
ip add 7.7.7.7 255.255.255.255
ip ospf 1 area 0

int e0/0
ip add 192.168.27.7 255.255.255.0
ip ospf 1 area 0
no sh

end
sh ip int br
=======R8=======
no

en
conf t
no ip do lo
ho R8

int lo0
ip add 8.8.8.8 255.255.255.255
ip ospf 1 area 0

int e0/0
ip add 192.168.28.8 255.255.255.0
ip ospf 1 area 0
no sh

int e0/1
ip add 192.168.8.1 255.255.255.0
ip ospf 1 area 3
no sh

ip dhcp pool webserevr
network 192.168.8.0 /24
default-router 192.168.8.1
dns-server 223.5.5.5 223.6.6.6

end
sh ip dhcp binding    #配置DHCP静态协议，即手动配置固定IP
==========================================
Bindings from all pools not associated with VRF:
IP address          Client-ID/                     Lease expiration        Type
                    Hardware address/
                    User name
192.168.8.11        5000.000b.0001          Infinite                Manual
192.168.8.12        5000.000c.0001          Infinite                Manual
==========================================
conf t
ip dhcp pool webserver11
hardware-address 5000.000b.0001
host 192.168.8.11
exit
ip dhcp pool webserver12
hardware-address 5000.000c.0001
host 192.168.8.12

end
sh ip int br
=======R9=======
no

en
conf t
no ip do lo
ho R9

int lo0
ip add 9.9.9.9 255.255.255.255
ip ospf 1 area 2

int e0/0
ip add 192.168.49.9 255.255.255.0
ip ospf 1 area 2
no sh

end
sh ip int br
=======R10=======
no

en
conf t
no ip do lo
ho R10

int lo0
ip add 10.10.10.10 255.255.255.255
ip ospf 1 area 2

int e0/0
ip add 192.168.104.10 255.255.255.0
ip ospf 1 area 2
no sh

int e0/1
ip add 192.168.10.1 255.255.255.0
ip ospf 1 area 2
no sh

ip helper-address 2.2.2.2    #另一种配置DHCP的方式，需要在R2(NAT设备上)上也进行相关配置

end
sh ip int br
```

