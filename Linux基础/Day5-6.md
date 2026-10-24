# Day5\-6

# Web服务器

- 使用python模拟web服务器

```Python
import socket       # 导入socket模块，可以用于网络编程

sk = socket.socket()    # 创建一个socket对象
sk.bind(("127.0.0.1", 80))  # 绑定IP地址和端口号
sk.listen(5)   # 监听连接，参数为最大连接数

print("启动成功")

while True:  # 循环接收连接
    conn, addr = sk.accept()  # 等待接收连接，返回连接对象和地址
    print(addr, "已经访问成功！")  # 打印客户端地址
    data = conn.recv(1024)  # 接收客户端发送的数据，参数为接收数据的最大字节数
    print(data)  # 打印接收到的数据
    conn.send(b"HTTP/1.1 200 OK\r\n\r\n<h1>Hello, World!</h1>")  # 向客户端发送响应数据
    conn.close()  # 关闭连接
```

- web服务器提供了类似于上面python代码的功能，但是更加的完善

    - 自动处理请求头的信息，并且自动生成响应包头

    - 自动处理访问出错的回应

    - 高性能

    - 代理功能

- web服务器的排名：https://www\.netcraft\.com/blog/june\-2025\-web\-server\-survey

# Nginx

- 2019年被F5收购

- 全球最主流的web中间件

## 安装

```C
[root@localhost ~]# yum -y install nginx        # 安装nginx
[root@localhost ~]# ss -ntlp                    # 确保80端口没有被占用
[root@localhost ~]# systemctl enable --now nginx        # 启动Nginx
[root@localhost ~]# firewall-cmd --add-port=80/tcp --permanent    # 配置firewalld防火墙放行
[root@localhost ~]# firewall-cmd --reload
[root@localhost ~]# iptables -A INPUT -p tcp --dport=80 -j ACCEPT        # iptables的配置
```

- 此时浏览器就可以访问虚拟机IP地址，打开默认的页面，注意此页面为rockylinux页面

![image\.png](图片和附件/image%2027.png)

- 如果不是rockylinux系统，nginx默认页面如下

![image\.png](图片和附件/image%2024.png)

## 静态网站

- Nginx默认配置文件在`/etc/nginx/nginx.conf` 

    - 这里的内容可以自己在设置\.conf文件的时候加上，来保证有对应的效果

```C
user nginx;            # Nginx的进程使用nginx用户打开，访问网站目录下的文件时候，此用户需要有可读权限
worker_processes auto;        # 设置worker进程数量，auto就是根据CPU数量来确定
error_log /var/log/nginx/error.log;        # 访问网页错误日志存放位置
pid /run/nginx.pid;            # Nginx的进程ID存放位置
include /usr/share/nginx/modules/ *.conf;        # 导入子配置文件
.......
http {                        # http协议如何处理
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '        # 日志格式
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
        access_log  /var/log/nginx/access.log  main;                            # 访问日志，按照main格式保存
        ......
        include /etc/nginx/conf.d/ *.conf;                    # 虚拟主机配置文件        
        server {                                        # 虚拟主机配置
            listen       80;                            # 监听IPv4端口
            listen       [::]:80;                        # 监听IPv6端口
            server_name  _;                            # 域名，_表示任意
            root         /usr/share/nginx/html;        # 当前此网站的目录
    
            # Load configuration files for the default server block.
            include /etc/nginx/default.d/ *.conf;        # 网站的默认设置
    
            error_page 404 /404.html;                    # 如果是404错误，就转向/404.html
            location = /404.html {                        # 如果访问/404.html可以单独定义如何处理
            }
            
            location = /www/ {                    # location匹配请求的资源地址，如果符合/www/就会执行下面的操作，匹配符号有多个，存在优先级
                root /html/blog/;
            }
    
            error_page 500 502 503 504 /50x.html;        # 如果是500的错误，就转发到/50x.html上
            location = /50x.html {
        }
    }        

}
```

- nginx默认会在`/usr/share/nginx/html/`目录下查找文件，并且响应浏览器，这个目录就是网站根目录

    - 比如，想要访问此目录下的test\.html文件，在浏览器中需要打开`http://ip地址/test.html`

    - 比如，想要访问此目录下的dir目录下的test1\.html，`http://ip地址/dir/test1.html`

```C
[root@localhost ~]# cd /usr/share/nginx/html/
[root@localhost html]# ls
# 此处文件，就是那个默认的Test Page
404.html  50x.html  icons  index.html  nginx-logo.png  poweredby.png  system_noindex_logo.png
[root@localhost html]# rm -rf *        # 清空此目录的文件
[root@localhost html]# vim test.html        # 编辑一个超文本文件
hello world
[root@localhost html]# mkdir dir        # 创建目录
[root@localhost html]# vim dir/test1.html    # 在目录中放置一个测试文件
```

- 浏览器访问的时候，没有指定具体的文件，Nginx默认会去查找目录下的`index.html`文件，如果没有此文件，就是403报错

    - `index.html` 就是目录的默认索引文件，在只访问目录的情况下，就会加载默认文件

```C
[root@localhost html]# cd dir/
[root@localhost dir]# ls
test1.html
[root@localhost dir]# vim index.html        # 创建一个index.html文件
in dir/index.html
[root@localhost html]# tree            # 当前的目录结构
.
├── dir
│   ├── index.html
│   └── test1.html
├── index.html
└── test.html

1 directory, 4 files
```

![image\.png](图片和附件/image%209.png)

- Nginx支持的格式，浏览器支持的格式，都可以支持

    - 网页相关文件

        - HTML、CSS、JS

        - XML、JSON

    - 媒体文件

        - MP4、SWF

        - MP3

        - jpg、png、gif

    - 文档

        - txt、pdf

- 遇到不支持的格式，默认处理方式下载

## 虚拟主机

- 可以让nginx根据请求头的域名不一样，使用不同的网站根目录

```C
# 创建网站根目录
[root@localhost ~]# mkdir -p /html/www/
[root@localhost ~]# mkdir -p /html/games/
[root@localhost ~]# mkdir -p /html/blog/
[root@localhost ~]# tree /html
/html
├── blog
├── games
└── www

3 directories, 0 files

# 修改Nginx配置文件
[root@localhost ~]# cd /etc/nginx/conf.d/        # Nginx默认配置文件目录
[root@localhost conf.d]# vim www.conf            # 创建www网站的配置文件
server {
   listen 10086;                        # 此网站监听的端口号，在没有server_name的情况下，不能与现有的端口冲突
   root /html/www/;                    # 此网站根目录
}
[root@localhost conf.d]# nginx -t        # 检查配置文件是否正确
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@localhost conf.d]# nginx -s reload        # 生效配置文件，不会断开现有连接
[root@localhost conf.d]# systemctl restart nginx        # 也可以重启整个服务
```

- 通过特定的端口号访问，就可以打开此网站页面

    - 下图是放入了旅游大数据前端页面站点

    - 打不开尝试关闭防火墙

![image\.png](图片和附件/image%201.png)

- 如果HTTP不使用80端口会有诸多问题

    - 搜索引擎不收录

    - 微信QQ会提示风险

    - 一个站一个端口，体验很差

- 如果想要复用80端口，就必须要有区分

    - 使用IP区分，在Linux上配置多个IP，每个IP对应不同的站点，使用`nmtui`增加网口

![image\.png](图片和附件/image%2035.png)

    - systemctl restart NetworkManager

```C
# 可以在接口上配置多个IP
[root@localhost ~]# ip a show ens160
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0c:29:2e:48:c6 brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 192.168.173.128/24 brd 192.168.173.255 scope global noprefixroute ens160
       valid_lft forever preferred_lft forever
    inet 192.168.173.88/24 brd 192.168.173.255 scope global secondary noprefixroute ens160
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe2e:48c6/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
       
[root@localhost ~]# vim /etc/nginx/conf.d/www.conf 
server {
   listen 192.168.173.88:80;            # 可以指定此站点监听的IP地址不一样
   root /html/www/;
}
[root@localhost ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@localhost ~]# systemctl restart nginx
```

![image\.png](图片和附件/image%2032.png)

- 不可能为每个网站都能申请到不同的IP，可以使用域名来做区分

```C
[root@localhost ~]# nginx -t
# 如果多个配置文件，监听的端口，域名，IP冲突了，就会报错
nginx: [warn] conflicting server name "" on 0.0.0.0:80, ignored
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

[root@localhost ~]# vim /etc/nginx/conf.d/games.conf
server {
    listen 80;
    server_name games.xlsyyds.com;            # 监听此域名，需要windows修改hosts文件指向这个虚拟机IP地址
    root /html/games/;
}

[root@localhost ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@localhost ~]# systemctl restart nginx
```

- 如果使用hosts文件方式

![image\.png](图片和附件/image%2021.png)

- 最终访问效果

![image\.png](图片和附件/image%2015.png)

- 解释

```MATLAB
====================/etc/nginx/conf.d============
88的网站是基于nmtui产生的额外网口搭建的，调用的配置：
# www.conf
server {
        listen 192.168.198.88:80;
        root /html/www;
}

games是基于原本IP192.168.198.135配置的
# games.conf
server {
        listen 80;
        server_name games.lbyyyds.com;
        root /html/games/;
}

blog也是原本的IP进行区分，和games用server_name来进行区分
# blog.conf
server {
        listen 80;
        server_name blog.lbyyyds.com;
        root /html/blog/;
}
==============windows配置设置=============
文件：C:\Windows\System32\drivers\etc
192.168.198.135 blog.lbyyyds.com
192.168.198.135 games.lbyyyds.com

```

# LNMP

## 动态网站

- 静态网站访问的资源都是提前准备好的，并且不会根据用户的操作而变化。

- 动态网站是服务器后端通过用户的访问行为，实时渲染出来的。

    - 用户可以提交数据给服务器，服务器可以根据用户是否提交，或者是提交的内容是什么来进行对应的处理

- 动态网站往往需要三层架构

    - 界面层

        - 为访问用户提供页面

        - Nginx

        - Html、CSS、Javascript

    - 业务层

        - 根据访问的请求，做出对应的操作

        - php\-fpm、tomcat

        - PHP、Java、Python

    - 数据层

        - 用于存储业务数据

        - 数据库

        - mysql、redis、mongodb

## LNMP架构

- lnmp是一套技术组合

    - L表示Linux

        - Linux提供系统底层

    - N表示Nginx，如果是Apache就叫LAMP

        - Nginx用于接受请求

        - 响应静态文件

        - 转发动态请求到PHP

    - M表示Mysql或者Mysql兼容的程序，比如Mariadb

        - 用于提供业务数据的管理

        - 增删改查

    - P表示PHP语言开发的后端

        - PHP\-FPM是一个PHP处理的资源池

        - 接受到Nginx传递过来的请求，就会做对应的处理

## LNMP部署

- 部署Nginx

```Plain Text
[root@localhost ~]# yum -y install nginx
[root@localhost ~]# setenforce 0
[root@localhost ~]# vim /etc/selinux/config
SELINUX=disabled
[root@localhost ~]# useradd -M -s /sbin/nologin www    #-M不创建家目录
[root@localhost ~]# vim /etc/nginx/nginx.conf
user www;
[root@localhost ~]# firewall-cmd --add-port=80/tcp --permanent
success
[root@localhost ~]# firewall-cmd --reload
success
[root@localhost ~]# systemctl enable --now nginx
```

![image\.png](图片和附件/image%2034.png)

- 部署PHP

```Plain Text
[root@localhost ~]# yum install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm --skip-broken
[root@localhost ~]# yum install -y php php-cli php-curl php-mysqlnd php-gd php-opcache php-zip php-intl
```

- 修改PHP配置文件

    - 修改PHP和Nginx通信端口号，端口号使用9000

    - 修改PHP的启动用户为`www` ，方便权限管理

```Plain Text
[root@localhost ~]# vim /etc/php-fpm.d/www.conf
......
;listen = /run/php-fpm/www.sock
listen = 9000
......
user = www
group = www

[root@localhost ~]# systemctl enable --now php-fpm
[root@localhost ~]# ss -ntl
State       Recv-Q      Send-Q           Local Address:Port           Peer Address:Port     Process     
LISTEN      0           128                    0.0.0.0:22                  0.0.0.0:*                    
LISTEN      0           511                    0.0.0.0:80                  0.0.0.0:*                     # Nginx工作端口号               
LISTEN      0           511                          *:9000                      *:*                     # PHP工作端口号            
LISTEN      0           128                       [::]:22                     [::]:*                    
LISTEN      0           511                       [::]:80                     [::]:*     
```

- 测试

    - 创建一个测试的虚拟主机，然后编写PHP代码，测试PHP能否正常工作

```Plain Text
[root@localhost ~]# vim /etc/nginx/conf.d/php.conf
[root@localhost ~]# mkdir -p /web/php
[root@localhost ~]# chown -R www.www /web    #这里的www.www是用户名.组名的格式
[root@localhost ~]# vim /etc/nginx/conf.d/php.conf
server {
    listen 80;
    server_name php.xlsyyds.com;    #这里记得修改windows的配置文件
    root /web/php/;
    location / {
        index index.php index.html;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
[root@localhost ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@localhost ~]# systemctl restart nginx
[root@localhost ~]# cd /web/php/
[root@localhost php]# vim info.php
<?php
phpinfo();
?>
```



![image\.png](图片和附件/image%2023.png)

- 部署Mariadb数据库

```Plain Text
[root@localhost ~]# yum -y install mariadb mariadb-server    #下载mariadb的客户端和服务端
[root@localhost ~]# systemctl enable --now mariadb
[root@localhost ~]# mysqladmin password "123456"            # 设置Mysql密码
[root@localhost ~]# mysql -uroot -p123456 -e "show databases;"        # 查看当前有哪些数据库
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
```

- 测试php到Mysql的连接

```Plain Text
[root@localhost ~]# cd /web/php/
[root@localhost php]# vim mysql_test.php
<?php 
$conn = mysqli_connect("127.0.0.1", "root", "123456");
if($conn){
    echo "success!";
}else{
    echo "failed!";
}
?>

```

![image\.png](图片和附件/image%2028.png)

### phpmyadmin

- 图形化的mysql管理工具

- 部署步骤

    - 创建虚拟主机的配置文件，重启Nginx让配置生效

    - 创建项目代码存放的目录，需要注意权限问题

    - 创建项目需要的数据库，如果需要

    - 验证

```Plain Text
[root@localhost ~]# vim /etc/nginx/conf.d/phpmyadmin.conf 
server {
    listen 80;
    server_name mysql.xlsyyds.com;
    root /web/phpmyadmin;
    location / {
        index index.php index.html;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}

[root@localhost ~]# mkdir -p /web/phpmyadmin/
[root@localhost ~]# cd /web/phpmyadmin/
[root@localhost phpmyadmin]# curl -O https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip
[root@localhost phpmyadmin]# yum -y install unzip                # 安装zip解压软件
[root@localhost phpmyadmin]# unzip phpMyAdmin-5.1.1-all-languages.zip
[root@localhost phpmyadmin]# mv phpMyAdmin-5.1.1-all-languages/* .        # 将解压后的文件都放到当前的目录下
[root@localhost phpmyadmin]# chown www.www -R /web/                    # 设置正确权限
[root@localhost phpmyadmin]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@localhost phpmyadmin]# systemctl restart nginx
[root@localhost phpmyadmin]# chown -R www.www /var/lib/php/session            # 给会话的目录权限
```

- 修改hosts文件

![image\.png](图片和附件/image%2010.png)

- 访问测试

![image\.png](图片和附件/image%208.png)

![image\.png](图片和附件/image%203.png)

- 创建数据库

![image\.png](图片和附件/image.png)

- 创建表

![image\.png](图片和附件/image%2013.png)

- 把表中的列作用设置一下

![image\.png](图片和附件/image%2029.png)

- 添加一些数据

![image\.png](图片和附件/image%2018.png)

![image\.png](图片和附件/image%202.png)

- 查看数据

![image\.png](图片和附件/image%2020.png)

### 个人笔记站

- 笔记站推荐

    - wordpress: https://cn\.wordpress\.org/

        - 全能，有100MB左右，但是具备各项功能

        - 偏难

    - typecho: https://typecho\.org/

        - 轻量，只有1MB大小，而且可以通过插件增加额外功能

        - 偏简单

        - 使用过程中出现问题寻找官方的解决文档

    - 在使用一个应用时，可以先看看他的配置文件，来提前设置好

![image\.png](图片和附件/image%2011.png)

```Plain Text
[root@localhost ~]# vim /etc/nginx/conf.d/blog.conf
server {
    listen          80;
    server_name     blog.xlsyyds.com;
    root            /web/blog;
    index           index.html index.htm index.php;
 
    if (!-e $request_filename) {
        rewrite ^(.*)$ /index.php$1 last;
    }
 
    location ~ .*\.php(\/.*)*$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass  127.0.0.1:9000;
    }
 
    access_log /var/log/nginx/blog.log combined;
}

[root@localhost ~]# systemctl restart nginx
[root@localhost ~]# mkdir /web/blog
[root@localhost ~]# cd /web/blog/
# 这里的链接从官网找到下载按钮然后右键复制下载链接
[root@localhost blog]# wget https://github.com/typecho/typecho/releases/latest/download/typecho.zip
# 下载之后可以 ll -h查看一下文件大小是否正确
[root@localhost blog]# unzip typecho.zip
[root@localhost ~]# chown -R www.www /web/    #-R递归，所有子目录文件夹一同修改
```

- 开始安装过程

- 创建数据库

![image\.png](图片和附件/image%2017.png)

![image\.png](图片和附件/image%2025.png)

![image\.png](图片和附件/image%207.png)

![image\.png](图片和附件/image%2026.png)

- 前台页面

![image\.png](图片和附件/image%2016.png)

- 后台页面

![image\.png](图片和附件/image%205.png)

- 换主题

    - 主题站：https://typechx\.com/

    - 找到想要的主题，下载zip，放到`usr/theme` 目录下

```Plain Text
[root@localhost ~]# cd /web/blog/usr/themes
# rz是lrzsz里面的命令，没有自己下载
[root@localhost themes]# rz                        # 上传主题压缩包到此目录
[root@localhost themes]# unzip Typecho-Butterfly-main.zip 
[root@localhost ~]# chown -R www.www /web
```

![image\.png](图片和附件/image%2022.png)

- 注意更换主体之后如果发现打不开，记得关闭VPN

### kodbox

- 国内较多人使用的企业网盘，可私有化部署

```Plain Text
[root@localhost ~]# vim /etc/nginx/conf.d/kodbox.conf 
server {
    listen 80;
    server_name kodbox.xlsyyds.com;
    root /web/kodbox;
    location / {
        index index.php index.html;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}

[root@localhost ~]# nginx -t
[root@localhost ~]# systemctl restart nginx

[root@localhost ~]# cd /web/
[root@localhost web]# mkdir kodbox
[root@localhost web]# cd kodbox/
[root@localhost kodbox]# wget https://static.kodcloud.com/update/download/kodbox.1.60.zip
[root@localhost kodbox]# unzip kodbox.1.60.zip
[root@localhost ~]# chown www.www -R /web
```

- 新建数据库

![image\.png](图片和附件/image%2019.png)

- 添加hosts文件

![image\.png](图片和附件/image%2030.png)

- 开始进入安装

![image\.png](图片和附件/image%2033.png)

- 设置数据库信息

![image\.png](图片和附件/image%2012.png)



![image\.png](图片和附件/image%2014.png)

- 如果上传文件较大，会触发报错

![image\.png](图片和附件/image%2031.png)

- 根据提示进行修改:https://docs\.kodcloud\.com/setup/nginx/

```Plain Text
=======================nginx.conf=============
[root@localhost ~]# cat /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user www;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;
    client_max_body_size 30G;
    client_body_timeout 300s;
    client_body_buffer_size 512k;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    fastcgi_connect_timeout 3600;
    fastcgi_send_timeout 3600;
    fastcgi_read_timeout 3600;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_intercept_errors on;
    fastcgi_hide_header X-Powered-By;

    gzip on;
    gzip_vary on;
    gzip_min_length  1k;
    gzip_comp_level 2;
    gzip_proxied   expired no-cache no-store private auth;
    gzip_types     text/plain application/javascript application/x-javascript text/javascript text/css application/xml;
    gzip_disable   "MSIE [1-6]\.";

    add_header Referrer-Policy                      "no-referrer"   always;
    add_header X-Content-Type-Options               "nosniff"       always;
    add_header X-Download-Options                   "noopen"        always;
    # add_header X-Frame-Options                      "SAMEORIGIN"    always;
    add_header X-Permitted-Cross-Domain-Policies    "none"          always;
    add_header X-Robots-Tag                         "none"          always;
    add_header X-XSS-Protection                     "1; mode=block" always;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}

======php.ini=========
[root@localhost ~]# vim /etc/php.ini
......
max_execution_time = 3600
max_input_time = 3600
memory_limit = 512M
post_max_size = 512M
upload_max_filesize = 512M
......

======php-fpm.d/www.conf=======
[root@localhost ~]# vim /etc/php-fpm.d/www.conf
.....
request_terminate_timeout = 3600
.....

[root@localhost ~]# systemctl restart php-fpm
[root@localhost ~]# systemctl restart nginx
```

- 现在上传文件大小就不受限制了

![image\.png](图片和附件/image%206.png)

## 内网穿透

- 使用的应用

![image\.png](图片和附件/image%204.png)

- 选择海外的网站然后输入自己的IP地址以及对应80端口号，选择TCP隧道

- 配置完成之后打开，可以查看对应的网址

    - 此时需要修改对应的服务器的应用的配置文件，如:/etc/nginx/conf\.d/blof\.conf将其中的server\_name改为刚刚生成的对应的网址

    - 然后重启nginx

