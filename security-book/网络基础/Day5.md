# Day5

# 交换机工作原理

## 广播域

- 广播有效的传播范围，就是广播域，路由器默认情况下是不会帮助局域网转发广播

![image\.png](图片和附件/image%2018.png)

- 交换机收到广播，会将广播数据进行复制，并且从收到的接口以外的所有接口发出

### MAC地址表

- 网络设备的接口都有一个硬件地址，就是MAC地址，在通信的时候会在数据链路层进行封装——\>交换机是一个二层设备

- 交换机会将接口收到的数据包的源MAC地址和接口信息记录到MAC地址表中

    - 查看命令`show mac address-table`

    - 清除命令`clear mac address-table dynamic`

- 交换机收到数据包后，就会查看目的MAC地址是什么，在MAC地址表中是否存在，如果存在，就准确的转发；如果不存在，就每个接口来一份 

![image\.png](图片和附件/image%201.png)

- 交换机默认不配置

- R1、R2、R4都正常配置IP地址 

- 交换机会自动学习到每个路由器的MAC地址

```SQL
Switch#sh mac address-table 
          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
   1    2e0c.fd08.fa71    DYNAMIC     Et0/2
   1    aabb.cc00.0100    DYNAMIC     Et0/0
   1    aabb.cc00.0200    DYNAMIC     Et0/1
   1    aabb.cc00.0400    DYNAMIC     Et0/2
Total Mac Addresses for this criterion: 4

```

- 检查局域网下有多少台设备的方法：ping广播（此方法现实中大多会被防火墙/网关拦截）

```Python
R1#ping 192.168.12.255
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.12.255, timeout is 2 seconds:

Reply to request 0 from 192.168.12.2, 1 ms
Reply to request 0 from 192.168.12.4, 1 ms
Reply to request 1 from 192.168.12.2, 1 ms
Reply to request 1 from 192.168.12.4, 1 ms
Reply to request 2 from 192.168.12.2, 2 ms
Reply to request 2 from 192.168.12.4, 2 ms
Reply to request 3 from 192.168.12.2, 15 ms
Reply to request 3 from 192.168.12.4, 15 ms
Reply to request 4 from 192.168.12.4, 2 ms
Reply to request 4 from 192.168.12.2, 2 ms

```

- 交换机的MAC地址表是有上限的，一般为4096，可以具体查看 `show mac address-table count`

```XML
Switch#show mac address-table count

Mac Entries for Vlan 1:
---------------------------
Dynamic Address Count  : 4
Static  Address Count  : 0
Total Mac Addresses    : 4

Total Mac Address Space Available: 207999032
```

- 大多数交换机（如Cisco、华为等）的MAC地址表动态条目默认老化时间为300s（即5mins）。若超过此时间未检测到对应MAC地址的活动，该条目将被自动删除

- 如果遭到黑客攻击，短时间将MAC地址表填满`macof`，无法再多学MAC地址，那么再次收到数据的时候，由于目的MAC地址无法被查找，就会向所有的接口发出，黑客就可以抓包，窃取到数据。

- 使用kali linux，可以进行`macof`攻击

### macof攻击

- 攻击局域网的MAC地址表，短时间产生大量垃圾数据，每个数据都是随机源MAC地址，将MAC地址表快速填满（损人不利己，谁都别玩）

#### 攻击方法

1. 打开kali进入命令行界面

![image\.png](图片和附件/image%2014.png)

2. 此时会向局域网内发送好多的mac地址导致mac地址表爆满

![image\.png](图片和附件/image%2019.png)

3. 右键kali标签，选择设置

![image\.png](图片和附件/image%2017.png)

4. 设置虚拟机的网络适配器，可以对外部网络进行攻击

![image\.png](图片和附件/image%2012.png)

#### 防御手段

限制设备的mac地址数量，但是也会一定程度上限制网络规模。

# VLAN

- LAN：本地区域网络，一般是一个广播域

- 不同的LAN往往是隔离的，如果有通信需要，就必须经过一台三层的设备，比如防火墙，路由器，网关设备

- 在企业中，存在不同的部门，或者不同的业务需求，需要多个不同的LAN

- VLAN虚拟本地区域网络，使用逻辑的方式将网络给隔离开

    - 默认情况下，所有的接口属于VLAN1，所以可以直接通信

    - 每个VLAN都会维护一个独立的MAC地址表

![image\.png](图片和附件/image%208.png)

- R1和R2属于一个部门，R3和R4属于一个部门，需要划分VLAN进行隔离 

- 在交换机上配置

```XML
en
conf t
vlan 10    #配置vlan
name vivo    #给vlan命名
vlan 20
name oppo
int range e0/0 - 1    #在接口上应用VLAN
switchport access vlan 10
int range e0/2 - 3
sw ac vl 20
end

sh mac address-table vlan 10    #检查
```

- 隔离开了以后，就算R1234都是一个网段的IP地址，12和34也无法直接通信

# Trunk

- 在交换机一层连接一层的情况下，也叫做级联，多个交换机想要打通相同的VLAN，可能需要多根线

- 计算机不会识别到trunk信息，只会识别到默认的access信息

![image\.png](图片和附件/image%2021.png)

- 但是这样做，在VLAN数量上去后，由于接口数量少就无法实现，就算VLAN数量不多，但也浪费接口

- Trunk不属于任何VLAN，当流量经过Trunk链路的时候会被加上标签，用于识别不同VLAN的流量

![image\.png](图片和附件/image%2010.png)

- Trunk实现的拓扑图

![image\.png](图片和附件/image%2011.png)



- 记得增加网卡模块，编辑交换机在ethernet选项中增加到2

- cisco的trunk的分装模式有两种，一个是自己的`isl`，一个是公开的`dot1q`，手动给trunk写一下封装模式`switchport trunk encapsulation dot1q`，就不会有提示了。

- 核心配置命令

```XML
==========SW-L2=========
en
conf t
ho SW-L2
vlan 10
name vivo
vlan 20
name oppo

int e0/1
sw ac vl 10    #在接口上配置VLAN

int e0/2
sw ac vl 20

int e0/0
switchport trunk encapsulation dot1q    #设置trunk的封装模式，大家都用802.1q
switchport mode trunk    #设置trunk接口
=========SW-L1============
int e1/0
switchport trunk encapsulation dot1q
sw mo tr
```

- 检验配置

```XML
SW-L2#show interface trunk
#接口       模式              封装协议        状态          本帧VLAN
Port        Mode             Encapsulation  Status        Native vlan
Et0/0       on               802.1q         trunking      1

Port        Vlans allowed on trunk
Et0/0       1-4094

Port        Vlans allowed and active in management domain
Et0/0       1,10,20

Port        Vlans in spanning tree forwarding state and not pruned
Et0/0       1,10,20

```

- 抓包效果：

![image\.png](图片和附件/image%209.png)

# 本帧VLAN（Native vlan）

- 在Trunk上约定好不打标签的流量VLAN是多少（因为VLAN需要加标签，传输过程中改完，封装，加标签，再封回去，比较消耗资源）

    - 两边必须一致，如果配置不一样，就会造成网络不通，或者流量串错局域网

- 修改方法：`switchport trunk native vlan 10`

![image\.png](图片和附件/image%205.png)

    ```XML
    ==========SW-L2===========
    en
    conf t
    int e1/0
    switchport trunk native vlan 10    #在e1/0接口上配置vlan 10为本帧VLAN
    ```

- 交换机会检测Native vlan号是否一致，如果不一样，就会报错，并且阻塞接口

- 配置完需要一定时间才可以生效

- 比较智能的交换机会报错提醒两边的Native vlan不同，并且关闭这个接口

![image\.png](图片和附件/image%2016.png)

- 此时抓包发现通过`vlan 10`的信息没有加上trunk标签

![image\.png](图片和附件/image%2015.png)

- 而通过`vlan 20`的信息已依旧有trunk标签

![image\.png](图片和附件/image%207.png)

# 交换机级联

交换机串一台，全部使用Trunk连接叫做级联，需要考虑网络瓶颈问题（设备多，需要更多的带宽才可以实现网速快）

![image\.png](图片和附件/image%2020.png)

# VLAN之间的通信

- 根据企业的业务需要，VLAN的通信是必须

- VLAN之间的通信往往是在策略控制下进行的

- 路由器支持划分子接口，并且可以把子接口接入到不同的VLAN

- 子接口随着主接口的开关而开关

![image\.png](图片和附件/image%204.png)



- 可能用到的其他配置

    - 恢复接口初始设置`default interface e0/0`

    - 删除子接口`no interface e0/0.10`

    - 重新加载`reload`

![image\.png](图片和附件/image%206.png)

- 某公司有两部门，VLAN10和VLAN20已经划分好

- 两个部门都需要通过网关进行上网

    - 网关需要和交换机之间启用Trunk

    - 网关路由器启用两个子接口，e0/0\.10接入vlan10，e0/0\.20接入vlan20

- 两个部门之间网络不能通，通过ACL策略实现

- R7和R4有项目需要协作，需要能够互通

```XML
============网关============
int e0/0
no sh

ip access-list extended oppo
permit ip host 192.168.20.4 host 192.168.10.7    #允许R4访问R7
deny ip any 192.168.10.0 0.0.0.255    #拒绝对VLAN10的访问
permit ip any any
ip access-list extended vivo
permit ip host 192.168.10.7 host 192.168.20.4    #允许R7访问R4
deny ip any 192.168.20.0 0.0.0.255    #拒绝VLAN20的访问
permit ip any any

int e0/0.10    #设置子接口
encapsulation dot1q 10    #在vlan10上配置trunk封装协议
ip add 192.168.10.254 255.255.255.0    #网关上连接VLAN的子接口
ip access-group vivo in    #加上策略

int e0/0.20
encapsulation dot1q 20
ip add 192.168.20.254 255.255.255.0
ip access-group oppo in

=========SW-L2==========
en
conf t
ho SW-L2
vlan 10
name vivo
vlan 20
name oppo

int e0/1
sw ac vl 10    #在接口上配置VLAN

int e0/2
sw ac vl 20

int e0/0
switchport trunk encapsulation dot1q    #设置trunk的封装模式，大家都用802.1q
switchport mode trunk    #设置trunk接口

int e0/3
switchport trunk encapsulation dot1q    #设置trunk的封装模式，大家都用802.1q
switchport mode trunk    #设置trunk接口

============SW-L1============
en
conf t
vlan 10    #配置vlan
name vivo    #给vlan命名
vlan 20
name oppo
int range e0/0 - 1    #在接口上应用VLAN
switchport access vlan 10
int range e0/2 - 3
sw ac vl 20
end

int e1/0
switchport trunk encapsulation dot1q
sw mo tr

========每台装作用户的路由器配置=======
no

en
conf t
ho Rx    #每台路由器设备名
no ip do lo
int e0/0
ip add 192.168.x0.x 255.255.255.0    #每台路由器IP地址
no sh
ip route 0.0.0.0 0.0.0.0 192.168.x0.254    #各自VLAN网关




```

- 检验

```C
R7#ping 192.168.20.4    #到R4是可以访问的
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.20.4, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 2/3/4 ms
R7#ping 192.168.20.8    #到其他的vlan20地址是不可以的
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.20.8, timeout is 2 seconds:
U.U.U
Success rate is 0 percent (0/5)
R7#ping 223.5.5.5    #到公网是可以连通的
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 223.5.5.5, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 41/49/74 ms
```

# VRRP

- 在一个局域网中只能有一个网关地址作为网络的出口，一旦网关出了故障，就无法访问外网

- 使用VRRP可以虚拟出一个网关IP地址，这个地址可以由多台设备通过协议决定谁来充当临时网关

![image\.png](图片和附件/image%2013.png)

- PC2配置

![image\.png](图片和附件/image%203.png)

![image\.png](图片和附件/image%202.png)

- R1和R2分别连接不同的运营商，对内网充当网关

- 使用VRRP来虚拟出网关IP地址`192.168.10.254`

```C
===========R1=========
en
conf t
ho R1
int e0/1
ip add 192.168.1.1 255.255.255.0
vrrp 1 ip 192.168.1.254    #在接口上使用vrrp，vrrp 组号 ip 网关IP
no sh
===========R2===========
en
conf t
ho R2
int e0/1
ip add 192.168.1.2 255.255.255.0
vrrp 1 ip 192.168.1.254
no sh
========PC1==========
no

en
conf t
ho PC1
int e0/0
ip add 192.168.1.3 255.255.255.0
no sh
ip route 0.0.0.0 192.168.1.254
```

- 查看VRRP的信息`show vrrp brief`

    - 优先级Pri默认是100，优先级最大的作为Master

    - 如果优先级一样，那么IP地址数值大的作为Master

    - Pre表示是否开启抢占，开启抢占可能导致网络的不稳定

    - Group address表示的是虚拟IP地址

    - vrrp的删除命令`no vrrp 组号`

```C
R1#show vrrp brief
Interface          Grp Pri Time  Own Pre State   Master addr     Group addr
Et0/1              1   100 3609       Y  Backup  192.168.1.2     192.168.1.254  

R2#sh vrrp br
Interface          Grp Pri Time  Own Pre State   Master addr     Group addr
Et0/1              1   100 3609       Y  Master  192.168.1.2     192.168.1.254  
```

- 查看vrrp的详情`show vrrp`

    - VRRP的mac地址段是固定的 

    - 每1秒vrrp设备都会发送存活通告，当3秒都没有收到master的通告，就会重新选举Master

```XML
R1#show vrrp
Ethernet0/1 - Group 1  
  State is Backup  
  Virtual IP address is 192.168.1.254
  Virtual MAC address is 0000.5e00.0101    #vrrp专属的mac地址，0000.5e00.01组号
  Advertisement interval is 1.000 sec    #每隔1s就发送一次存活通告
  Preemption enabled    #抢占开启
  Priority is 100    #优先级
  Master Router is 192.168.1.2, priority is 100     #Master的信息
  Master Advertisement interval is 1.000 sec
  Master Down interval is 3.609 sec (expires in 3.546 sec)    #Master的死亡时间3s倒计时
```

- 修改优先级

```XML
========R1=========
 int e0/1
 ip add 192.168.1.1 255.255.255.0
 vrrp 1 ip 192.168.1.254
 vrrp 1 priority 110    #修改优先级
 
 R1#sh vrrp brief
Interface          Grp Pri Time  Own Pre State   Master addr     Group addr
Et0/1              1   110 3570       Y  Master  192.168.1.1     192.168.1.254  
```

- 如果网关的上连断开了，由于存活通告是靠下连发送的，就会出现无法切换，导致断网

    - 可以使用track去监督某个接口的状态

    - 当借口down了，就会增加优先级的处罚值，让优先级降下来，从而不做Master

```XML
==========R2==========
track 1 int e0/0 line-protocol    #追踪e0/0的接口协议状态，track 组号 接口 链路协议

int e0/1
vrrp 1 track 1 decrement 50    #当track 1跟踪接口状态down,就把vrrp 1的优先级降低50
```

## VRRP脑裂问题（扩展）

- VRRP 脑裂（Split\-Brain） 的核心是主备节点通信中断，双方都认为对方失效，同时成为 Master、争抢虚拟 IP（VIP），导致网络冲突、业务中断。解决需从预防、检测、隔离、仲裁四层入手。

- 核心原因

    心跳链路故障：网线 / 光模块损坏、交换机宕机、端口被 Shutdown / 阻塞

    配置错误：VRID不一致、优先级相同、认证不匹配、防火墙拦截 VRRP 报文

    网络抖动 / 拥塞：心跳报文超时、丢包

    单一路径：无冗余，链路一断即失联

## 自己电脑上配置默认网关

- `win+r`输入`ncpa.cpl`

![image\.png](图片和附件/image.png)



