# Day1

# 计算机组成

## 核心组件

- 处理器CPU

    - 负责计算

- 内存RAM

    - 负责临时存放正在运行的数据

    - 断电就丢失所有数据

- 硬盘

    - 负责持久化存储数据

    - 机械硬盘,磁盘

        - 便宜

        - 数据存储时间比较长

    - 固态硬盘，浮栅晶体管

        - 速度快

## 其他组件

- 显卡

    - 游戏

    - AI

    - 图形处理

- 输入输出

    - 键盘鼠标

    - 显示器

    - 音响

    - 麦克风

# 计算机处理的核心内容：数据

## 二进制

计算机中所有的数据，都必须变为二进制才可以进行存储或者传输。

## 文本

通过文字编码，可以将文字变为二进制

文字 \-\> 二进制

- ASCII编码 只支持 英文和特殊字符[图片引用保存](https://ocnbtdmgi539.feishu.cn/wiki/UH7fwFTediBtRfkJBKTc7zA7nDd?larkTabName=space#share-GZLldtplVoGvynxvQk3cnNNGnnJ)

    - 纯英文系统比较偏见

- UTF\-8编码 支持所有的文字

- GBK编码 支持简体繁体中文，不支持生僻字[图片引用保存](https://ocnbtdmgi539.feishu.cn/wiki/UH7fwFTediBtRfkJBKTc7zA7nDd?larkTabName=space#share-IfPldRwp9otjJJxOdQFcvq5vnEc)

    - windows系统默认

## 图片

通过图片格式来定义二进制如何表达像素显示

jpg，jpeg  照片

![result\.jpg](图片和附件/result.jpg)

png          允许透明

![result\.png](图片和附件/result.png)

gif            多张图\+时间轴

### 图片格式的转换

1\.打开电脑自带的画图软件[图片引用保存](https://ocnbtdmgi539.feishu.cn/wiki/UH7fwFTediBtRfkJBKTc7zA7nDd?larkTabName=space#share-TYQzdds9HoA43sxHAdgcme57nXf)

2\.把图片拖入画图软件中，点击文件，点击另存为[图片引用保存](https://ocnbtdmgi539.feishu.cn/wiki/UH7fwFTediBtRfkJBKTc7zA7nDd?larkTabName=space#share-Xgx5dnz63oSWZWxjraicBaZWnub)

## 视频

视频的本质：多张图片＋时间轴

- mp4

- m3u8

    - 分段传输（这种方法可以在你拖动进度条的时候知道你在浏览视频的什么时间段，不用加载前面的内容，bilibili视频就是这种格式，可通过jjdown下载视频）

## 音频

本质上就是记录电平

mp3

# 数据的传输

数据网络提供数据的传输，本质上传递的是二进制

# 什么是网络

给各个节点之间提供数据信息交换的就是数据网络

两个节点之间连接一根网线，就可以组成最简单的网络

# 数据通信的类型

## 单播

一对一

## 广播

一对所有

## 组播

一对特定的组

### 网络延迟原理

网络发起属于一小段一小段传输，用网的人多了，就会导致轮到一个人的周期变长。

# 常见网络设备

## 集线器

主要是将各个节点之间物理连接在一起，会冲突

## 交换机

将各个节点之间连接在一起，通过mac地址精准的交换彼此的数据

交换机组成了局域网，一个局域网中共享一个广播域

## 路由器

连接各个局域网（LAN），并且隔绝广播域

## 互联网

互联网是由无数个局域网组成，局域网之间通过路由器连接

## 网络拓补

各种网络设备之间如何连接（pnet模拟）

# OSI七层模型

## 应用层

各种应用程序协议：

- http

- https

## 表示层

数据的格式化，数据加密解密（即编码解码），数据的压缩解压缩

### 编码解码网站

社会主义核心价值观编码（https://ctf\.bugku\.com/tool/cvecode）：

![image\.png](图片和附件/image%2015.png)

## 会话层

负责会话的管理，建立，终止，区分不同的会话

### session

f12打开管理界面（或者右键）然后点击应用，找到cookie，里面存放着登录信息，删除过后会导致回到网页登录界面。

![image\.png](图片和附件/image.png)

## 传输层（段）

数据分段和重组，提供数据传输方式，提供数据的发送和接收端口

### 端口port

端口提供应用的区分，使用端口号，可以让操作系统将发送或者接收到的数据和进程之间关联

端口号范围0\~65535

- 固定端口号

    - 一些固定好的端口号，让用户访问的时候不用去加上端口，自动添加

    - 系统会记录这些固定端口号在一个文件中:`C:\Windows\System32\drivers\etc\services`

    - 常见端口

        - http 80/tcp

        - https 443/tcp,udp

        - dns 53/tcp,udp

        - ftp 21/tcp 20/tcp

        - ssh 22/tcp

        - rdp 3389/tcp,udp

- 随机端口号

    - 一般用于接收数据，当网络应用发起请求的时候，都会带上本机随机端口号，临时接收一下数据，数据接收完就关闭

#### 查询PID

在cmd中输入`netstat -ano | findstr 查询端口`,可以检测到该进程的连接方式以及是否联网

1. 在后台找到微信可以查看他的运行pid

![image\.png](图片和附件/image%203.png)

2. 然后通过cmd，输入指令`netstat -ano | findstr 查询端口 `找到这个程序的联网情况和IP

![image\.png](图片和附件/image%2020.png)

3. 最后在wireshark中选择自己的联网网口，再通过找到指定IP的形式抓包想要的数据

![image\.png](图片和附件/image%2016.png)

### TCP

- 可靠的传输，发送的每一个数据都需要被确认，才会发下一个数据

- 占用更多的资源，并且容易出现DDOS安全问题

![image\.png](图片和附件/image%2019.png)

- 三次握手

    - 当TCP建立连接的时候，需要发送三个数据包来确保连接的可靠建立

![image\.png](图片和附件/image%2011.png)

    - HostA发送的第一个TCP包里面的序列号是随机的，确认号是0，HostB发送的第一个TCP回应序列号是随机的，确认号是收到的HostA的序列号\+1

- 四次挥手

![image\.png](图片和附件/image%2018.png)

tcp的有限状态机制：https://iproute\.cn/2020/03/06/tcp\-you\-xian\-zhuang\-tai\-ji/

### UDP

- 尽力而为的传输

![image\.png](图片和附件/image%2017.png)



### DDOS攻击工具

低轨道离子炮

### 流量工具

p2p终结者

幻镜网盾

## 网络层（包）

提供了IP地址，IP地址是设备的逻辑地址，相当于快递收件地址

如何查看自己电脑的IP地址

- 查看内网的IP地址

比如1004，这个地址仅在某栋楼有效

- 查看公网的IP地址

浏览器访问https://cip\.cc/

浏览器访问 https://whatismyipaddress\.com/

### IP地址的组成

IP地址是32位二进制组成，使用点分十进制

比如，192\.168\.22\.56，变成二进制：11000000 10101000 00010110 00111000

可以在网站上计算IP地址https://ipjisuanqi\.com/

也可以在电脑自带的计算器上计算

1. [图片引用保存](https://ocnbtdmgi539.feishu.cn/wiki/UH7fwFTediBtRfkJBKTc7zA7nDd?larkTabName=space#share-RLfEdJtt4oJEZ3xRQldcDuoNn4c)

2. [图片引用保存](https://ocnbtdmgi539.feishu.cn/wiki/UH7fwFTediBtRfkJBKTc7zA7nDd?larkTabName=space#share-DzMUdlBzpoH3PZxE7wBcFwGgnye)

手机号码是靠前7位来判断归属地和运营商，IP地址也有类似的设计，通过网络位来判断是哪个局域网，通过主机位在局域网中详细的划分

IP地址网络位长度不固定，根据需要可以调整

192\.168\.22\.56/24，表示前24位是网络位

192\.168\.22\.56/255\.255\.255\.0，子网掩码和IP地址二进制一一对应，子网掩码是1，表示对应的IP位是网络位

### 实战（创建一台PC和Server，让PC可以访问Server）

如果pnet环境异常可以选择恢复快照来重置环境

![image\.png](图片和附件/image%2022.png)

- 创建一个服务器

1. 右键点击Node选择Docker\.io

2. 配置服务器，然后保存

![image\.png](图片和附件/image%202.png)

- 创建一个PC

1. 右键Node选择Docker\.io

2. 配置PC然后保存

![image\.png](图片和附件/image%2010.png)

- 连接PC和Server

1. 连接PC和Server并且打开html控制台（如若不点开html控制台，电脑会下载程序，点开后由自己的电脑开始进行RDP远程连接操作）

![image\.png](图片和附件/image%208.png)

2. 开机后左键图标，点开PC和Server，发现正常工作

3. 随后在PC的浏览器上输入Server的网址发现服务器正常工作

![image\.png](图片和附件/image%201.png)

必须要网络位一样，才可以互相之间直接访问

### IP地址配置

- windows

    - 运行`ncpa.cpl`

    - 双击对应的网卡，点击属性，点击Internet协议版本4，就可以配置IP信息了

![image\.png](图片和附件/image%209.png)

- Linux

    - 输入`nmtui`

### IP地址分类

早期为了方便IP地址的使用，对IP地址进行分类

A类 8位网络位 /8 255\.0\.0\.0

B类 16位网络位 /16 255\.255\.0\.0

C类 24位网络位 /24 255\.255\.255\.0

![image\.png](图片和附件/image%2013.png)

### 私有IP地址

公网IP地址都是由https://www\.iana\.org/

私有IP地址可以自行在内部随意使用，为了防止与公网IP地址冲突，私有IP地址有这几个段（如果私有IP和公网IP重复，会优先查询私有IP）

10\.0\.0\.0\~10\.255\.255\.255

172\.16\.0\.0\~172\.31\.255\.255

192\.168\.0\.0\~192\.168\.255\.255

127\.0\.0\.0\~127\.255\.255\.255\(计算机保留作为本地地址\)

169\.254\.0\.0\~169\.254\.255\.255\(无法得到IP的时候，自己给自己发一个IP用用\)

### 广播地址与网络编号

- 广播地址

    - 规定一个网段（一段局域网），主机位如果全为1，那这个地址就是这个局域网的最后一个地址，也就是广播地址

![image\.png](图片和附件/image%204.png)

    - 这个子网掩码，转化为二进制发现网络位是30位（30个1），因为252的二进制是11111100，而IP地址只有32位，只有最后两个位是主机位。

    - 主机位不能全为0或全为1，所以这里面的IP地址的主机位只有两个选项，1（01）或者2（10），如果是3（11）或者4（100）或导致主机位为0，如果是5（101）会导致不在一个局域网内。

- 网络编号

    - 一个网段，主机位全是0，这个地址保留下来代指整个局域网的编号

    - 192\.168\.1\.0/24 表示这个局域网的地址段

### 网络测试工具

- ping

    - 用于测试到目的IP地址的连通性

    - 在cmd中输入`ping /help`可以查询ping的一些额外命令，比如说`ping -i 时间`可以查询出经过第几个网口的IP地址

- tracert

    - 网络数据包存在一个属性叫TTL，生存时间，每经过一台设备，就会\-1，当为0的时候就被丢弃，并且丢弃的那台设备会回复一个超时。

    - tracert使用TTL减一的方式，可以探测出数据经过的每一个节点

![image\.png](图片和附件/image%2014.png)

精确查询IP地址的位置（收费）：https://www\.ipip\.net/

![image\.png](图片和附件/image%2021.png)

### IP配置实验

配置信息：

1. 选择Cisco Device，创建三个，image选择路由器或三层交换。

2. 选择Cisco Device，创建一个，image选择二层交换，改名为SW，并且更换图标Switch。

3. 关闭左侧的html选项，这样配置界面会使用下载好的Xshell

4. 在xshell中点击查看，工具栏，可以将不用的选项关闭

5. 右键标签，显示终端标题可以方便确定是哪个设备

6. 点击文件，属性，外观可以更改颜色

![image\.png](图片和附件/image%206.png)

- R1

```MATLAB
no        #不需要进行配置引导
Router>enable        #进入到特权模式下，在此模式下，才具备设备完整的权限
Router#configure terminal        #进入到全局配置模式，在这个模式下可以配置系统的各项参数
Router(config)#hostname R1        #修改主机名字
R1(config)#no ip domain lookup        #关闭域名解析，防止输入错误指令导致卡顿
R1(config)#interface ethernet 0/0        #进入到e0/0接口配置模式，在这个模式下，可以配置与此接口相关配置
R1(config-if)#ip address 192.168.123.1 255.255.255.0        #配置接口IP地址
R1(config-if)#no shutdown        #开启接口
R1(config-if)#end        #回到特权模式
R1#show ip interface brief        #查看接口状态
```

- R2

```MATLAB
no        #不需要进行配置引导
Router>enable        #进入到特权模式下，在此模式下，才具备设备完整的权限
Router#configure terminal        #进入到全局配置模式，在这个模式下可以配置系统的各项参数
Router(config)#hostname R2        #修改主机名字
R2(config)#no ip domain lookup        #关闭域名解析，防止输入错误指令导致卡顿
R2(config)#interface ethernet 0/0        #进入到e0/0接口配置模式，在这个模式下，可以配置与此接口相关配置
R2(config-if)#ip address 192.168.123.2 255.255.255.0        #配置接口IP地址
R2(config-if)#no shutdown        #开启接口
R2(config-if)#end        #回到特权模式
R2#show ip interface brief        #查看接口状态
```

- R3

```MATLAB
no        #不需要进行配置引导
Router>enable        #进入到特权模式下，在此模式下，才具备设备完整的权限
Router#configure terminal        #进入到全局配置模式，在这个模式下可以配置系统的各项参数
Router(config)#hostname R3        #修改主机名字
R3(config)#no ip domain lookup        #关闭域名解析，防止输入错误指令导致卡顿
R3(config)#interface ethernet 0/0        #进入到30/0接口配置模式，在这个模式下，可以配置与此接口相关配置
R3(config-if)#ip address 192.168.123.3 255.255.255.0        #配置接口IP地址(如果想修改ip可以使用这个指令，会把上个ip顶掉)
R3(config-if)#no shutdown        #开启接口
R3(config-if)#end        #回到特权模式
R3#show ip interface brief        #查看接口状态
```





## 数据链路层（帧）

数据链路层主要是维护局域网，MAC地址是跟着设备接口走的

将数据封装成帧，实现两个相邻节点之间的通信



![image\.png](图片和附件/image%207.png)

### mac地址

媒体访问控制，是网卡固件中烧录的地址，由厂家提供，全球唯一\*，无法轻易改变，类似于身份证号码

在实际通信中，有效范围仅限于局域网

mac前面部分表示生产厂商，后面的部分精确到具体的设备信息

在硬件中以48位二进制表示，为了人类方便记忆，使用16进制表示

windows查看mac地址的方式

方式一：

1. `win+r`打开运行

2. 输入`cmd`然后回车

3. 输入`ipconfig /all`然后回车

![image\.png](图片和附件/image%2023.png)

方法二:

1. `win+r`打开运行

2. 输入`ncpa.cpl`然后回车

3. 双击对应的网卡，点击详细信息看到mac地址

![image\.png](图片和附件/image%2012.png)

mac地址会通过一些渠道被查询到在哪里交易的设备，所以尽量不要泄露

### 目的地址

1. 如果是交换机收到了帧，就会查找目的地址的位置接口

2. 如果是终端（手机，电脑），就会查看目的地址是否给自己，如果不是给自己的，就丢弃\*，如果是给自己的，就会拆开这一层，然后丢给网络层

#### 摩托c118实现短信监听

这个手机拆开后盖，焊上三个点，就可以接受附近的短信，从而实现短信监听

### 源地址

发送者自己的mac地址，但是不鉴别

### 校验码

帧尾校验，使用CRC算法得到的二进制，可以确保数据不破损

#### 嘉豪命令

1. `win+r`输入`cmd`

2. `color a`改变字体颜色

3. 输入`dir /s`查阅C盘所有文件😂

### ARP地址解析协议

知道对方的IP地址，但是不知道对方的mac地址，就会向局域网发起广播，进行查询，如果收到回复，就会记下来

1. 右键路由器选择capture，选择对应的接口，进行wireshark（pnet配置环境自带）抓包。

![image\.png](图片和附件/image%205.png)

## 物理层

定义各种物理传输介质的电气标准

主要是为了传递二进制

网线

- 电线

    - RJ45：八个数据线

    - RJ11：四个数据线

- 光线

    - SC

        - 单根芯：一根线解决所有问题，但是会导致光色散，不好用

    - LC

        - 双根芯：一根接受，一根发送

- 无线

    - wifi

有一个产品叫做usbkiller，插在电脑上会充电，充满电后放点会导致电脑内部硬件损坏。



