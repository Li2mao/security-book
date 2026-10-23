# Day2

# 文件的类型

- windows依赖文件后缀名来识别文件的类型

- Linux不依靠文件后缀名来识别文件类型，在Linux中文件后缀名是用来给人类看的

## stat

- 可以查看文件类型

```YAML
[root@localhost ~]# stat test1.mp4 
  File: test1.mp4
  Size: 24                Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d        Inode: 100665687   Links: 1        # inode是文件在硬盘中的位置
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Context: unconfined_u:object_r:admin_home_t:s0
Access: 2025-07-19 10:58:37.548773304 +0800        # 访问时间，也叫做atime
Modify: 2025-07-19 10:31:23.284860735 +0800        # 修改时间，mtime也是文件内容改变的时间
Change: 2025-07-19 10:58:34.240772620 +0800        # 改变时间，ctime是文件状态发生变化的时候
 Birth: 2025-07-19 10:22:03.268159280 +0800        # 创建时间
[root@localhost ~]# stat dir
  File: dir
  Size: 34                Blocks: 0          IO Block: 4096   directory
Device: fd00h/64768d        Inode: 100665677   Links: 3
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Context: unconfined_u:object_r:admin_home_t:s0
Access: 2025-07-19 10:20:38.788053463 +0800
Modify: 2025-07-19 10:20:37.086051324 +0800
Change: 2025-07-19 10:20:37.086051324 +0800
 Birth: 2025-07-19 10:14:49.025814381 +0800
```

- 通过`ls -l` 可以看到文件的硬链接数量

- 使用`ln file1 file2` 可以增加引用数量，相当于硬盘的位置\(inode\)被多处调用了

- 当文件被删除，硬链接数量就会\-1，当硬链接为0的时候，空间就被释放

## file

查看文件类型

```MATLAB
[root@Rocky ~]# file test1.txt 
test1.txt: UTF-8 Unicode text
[root@Rocky ~]# file a
a: directory
```

# 文件查找

## find

文件查找

```MATLAB
[root@Rocky ~]# find / -name li2mao66    #根据文件名查找文件
/var/log/chrony/li2mao66

[root@Rocky ~]# find /etc -size +5M    #按照文件尺寸查找
/etc/udev/hwdb.bin

[root@Rocky ~]# du -sh        #查看当前目录的文件大小占用
80K        

[root@Rocky ~]# find /etc/ -mtime -5        #查看最近五天修改的文件
/etc/
/etc/resolv.conf
```

# 用户权限

- 在Linux上用户主要用于两个用途

    - 用于确定文件的所属人，从而可以判断权限

    - 用于确定进程的所属人，从而可以判断能做的事情、

## id

- 用于显示用户ID

```MATLAB
[root@Rocky ~]# id root
uid=0(root) gid=0(root) groups=0(root)
[root@Rocky ~]# id games
uid=12(games) gid=100(users) groups=100(users)
[root@Rocky ~]# id lp
uid=4(lp) gid=7(lp) groups=7(lp)
```

- uid的约定

    - 0：超级管理员，也就是root，拥有Linux系统中所有权力

    - 1\~999：系统用户，用来约束系统中一些服务的权限

    - 1000\+：普通用户，创建并且登录使用Linux系统

- 查看文件的拥有者

```MATLAB
[root@Rocky ~]# ll test1.txt
-rw-r--r--. 1 root root 24 Sep  9 10:23 test1.txt
```

![image\.png](图片和附件/image%201.png)

- 查看进程的用户名

    - 可以查看到ping命令的用户是root

```MATLAB
[root@Rocky ~]# ps aux | grep ping
root        1860  0.0  0.0   5092  2560 pts/0    S+   11:08   0:00 ping baidu.com
```

- 相关文件

    - 有些用户登录后自动执行相关命令，比如shutdown用户登录后会自动关机

    ```TypeScript
    [root@Rocky ~]# cat /etc/passwd
    root:x:0:0:root:/root:/bin/bash
    bin:x:1:1:bin:/bin:/sbin/nologin
    daemon:x:2:2:daemon:/sbin:/sbin/nologin
    adm:x:3:4:adm:/var/adm:/sbin/nologin
    lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
    sync:x:5:0:sync:/sbin:/bin/sync
    shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
    halt:x:7:0:halt:/sbin:/sbin/halt
    mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    operator:x:11:0:operator:/root:/sbin/nologin
    games:x:12:100:games:/usr/games:/sbin/nologin
    ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
    nobody:x:65534:65534:Kernel Overflow User:/:/sbin/nologin
    systemd-coredump:x:999:997:systemd Core Dumper:/:/sbin/nologin
    dbus:x:81:81:System message bus:/:/sbin/nologin
    tss:x:59:59:Account used for TPM access:/:/usr/sbin/nologin
    sssd:x:998:996:User for sssd:/:/sbin/nologin
    sshd:x:74:74:Privilege-separated SSH:/usr/share/empty.sshd:/usr/sbin/nologin
    chrony:x:997:995:chrony system user:/var/lib/chrony:/sbin/nologin
    #这里的格式为用户名：密码：uid：gid：描述：家目录：登录后执行的命令
    ```

    - 查看用户及其密码

```MATLAB
cat /etc/shadow    #密码使用sha-256不可逆处理后保存在文件中
root:$6$mBkrTYGuk8eBiIYT$NCl0euAXHjtXYZRYAgOM99xG5YcrBNaBVlrAU6B98FNtrgdC6UJYydMc1mgCjL16DjU4tvH..h5STYL0E9Z1P.::0:99999:7:::
# 这个格式为用户名：加密密码：最后一次修改时间：最小修改时间间隔：密码有效期：密码需要变更前的警告天数：密码过期后的宽限时间：账号失效时间：保留字段
```

# 用户组管理

- Linux中的用户，必须要属于某个组，如果没有指定，就属于他自己的组，比如root默认属于root组

- 一个组可以有多个用户，一个用户也可以属于多个组

```MATLAB
[root@Rocky ~]# cat /etc/group
```

## groupadd

- 创建组

```MATLAB
[root@Rocky ~]# groupadd hr -g 1000    #-g 后面输入组的标签号，这里只认标签号，根据标签号进行组划分
[root@Rocky ~]# groupadd sale -g 2000    #后续如果改名称，但是标签号还是不变，组的设置不会变
[root@Rocky ~]# groupadd it -g 3000
[root@Rocky ~]# groupadd fd -g 4000

[root@Rocky ~]# tail -4 /etc/group
hr:x:1000:
sale:x:2000:
it:x:3000:
fd:x:4000:

[root@Rocky home]# passwd user03    #修改user03的密码，没有密码不给远程登录
Changing password for user user03.
New password: 
BAD PASSWORD: The password is a palindrome
Retype new password: 
passwd: all authentication tokens updated successfully.
```

## groupmod

- 修改组

```MATLAB
[root@Rocky ~]# groupmod -n finance fd    #修改组的ID
[root@Rocky ~]# tail -4 /etc/group
hr:x:1000:
sale:x:2000:
it:x:3000:
finance:x:4000:
```

## groupdel

- 删除组

```MATLAB
[root@Rocky ~]# groupadd test
[root@Rocky ~]# tail -4 /etc/group
sale:x:2000:
it:x:3000:
finance:x:4000:
test:x:4001:
[root@Rocky ~]# groupdel test    #使用组名删除组
[root@Rocky ~]# tail -4 /etc/group
hr:x:1000:
sale:x:2000:
it:x:3000:
finance:x:4000:
```

## gpasswd

- 添加组成员

```SQL
[root@Rocky ~]# useradd itadmin
[root@Rocky ~]# gpasswd -a itadmin it    #将用户加入it组
Adding user itadmin to group it
[root@Rocky ~]# tail -4 /etc/group
sale:x:2000:
it:x:3000:itadmin
finance:x:4000:
itadmin:x:4001:
[root@Rocky ~]# id itadmin        #可以看到itadmin属于itadmin和it组
uid=1000(itadmin) gid=4001(itadmin) groups=4001(itadmin),3000(it)
```

# 用户管理

- /etc/skel/文件，包含新建用户后自带的命令，可以在里面修改\.bashrc文件内容，在登录时产生提示，也可以创建一个新的readme\.md文件，给新用户一些提示

## useradd

- 添加用户

    - home家目录，其实是复制于`/etc/skel/` 文件夹，如果想要给新用户预设一些文件，可以放在这个目录下

```MATLAB
[root@Rocky ~]# useradd user01    #添加一个普通用户
[root@localhost ~]# useradd -M user05        # 创建用户，但是不需要创建家目录，此用户往往不需要登录
[root@Rocky ~]# id user01 
uid=1001(user01) gid=1001(user01) groups=1001(user01)
[root@Rocky ~]# useradd -g root user02    #添加一个普通用户，加入到root组
[root@Rocky ~]# id user02
uid=1002(user02) gid=0(root) groups=0(root)

[root@Rocky home]# useradd -d /home/li2mao66 user03    #指定home的位置
[root@Rocky home]# ll
total 0
drwx------. 2 itadmin itadmin 62 Sep  9 16:38 itadmin
drwx------. 2 user03  user03  62 Sep  9 18:58 li2mao66
drwx------. 2 user01  user01  62 Sep  9 18:52 user01
drwx------. 2 user02  root    62 Sep  9 18:53 user02

[root@Rocky home]# useradd -s /sbin/nologin user04    #创建一个不给登录的用户，主要用于进程或文件权限约束
```

- 切换用户

```MATLAB
[root@Rocky home]# su - user04    #user04不给登录
This account is currently not available.
[root@Rocky home]# su - user03
```

## usermod

- 修改用户

```MATLAB
[root@localhost ~]# id user01
uid=1001(user01) gid=1001(user01) groups=1001(user01)
[root@localhost ~]# usermod -d /home/user01_01 user01    # 修改用户的home目录

[root@localhost home]# usermod -u 6666 user02        # 修改用户的uid
[root@localhost home]# id user02
uid=6666(user02) gid=0(root) groups=0(root)


[user02@localhost tmp]$ touch user02_file        # 如果使用user02创建一个文件
[user02@localhost tmp]$ ll                        # 此文件就会显示属于user02
total 0
-rw-r--r--. 1 user02 root  0 Jul 19 13:33 user02_file
[user02@localhost tmp]$ exit
[root@localhost home]# usermod -u 1002 user02
[root@localhost home]# ll /tmp
total 0
-rw-r--r--. 1 6666 root  0 Jul 19 13:33 user02_file    # 由于没有任何用户uid是6666，所以此文件就不属于任何人
[root@localhost home]# usermod -u 6666 user01
[root@localhost home]# ll /tmp
total 0
-rw-r--r--. 1 user01 root  0 Jul 19 13:33 user02_file    # user01目前的uid是6666，所以这个文件目前就属于user01了
# Linux根据uid判定文件属于某个用户，在不同的系统上uid所属的用户不一样，所以跨主机的时候，需要注意同一个用户名的uid可能不一样的问题
```

## userdel

- 删除用户

```MATLAB
[root@Rocky home]# userdel user04    #删除用户，home目录不会被删除
[root@Rocky home]# ll /home
drwx------. 2    1004    1004 62 Sep  9 19:00 user04
[root@Rocky home]# userdel -r user04    #-r删除用户的时候连带home目录一起删除
```

# 密码管理

- passwd命令只有root用户在修改自己或别人密码的时候，不需要提供原密码

- 普通用户使用passwd只能修改自己的密码，并且需要提供原密码

```C
[root@localhost ~]# passwd                # 修改自己的密码
[root@localhost ~]# passwd user02        # 修改别人的密码(只有root)
```

# 提权

- 普通用户想要使用root权限执行某些命令

    - Linux中大多数操作，比如安装软件，关机重启等等都需要root权限，所以普通用户不可避免的需要提权

    - 提权有两种

        - 直接切换到root用户，`su - root`，但是需要root密码才可以

        - `sudo -i`是sudo一个接口，输入密码进入之后输入的每一条命令都是提权过的

        - 使用sudo，默认情况下所有普通用户都无法调用

```Markdown
[root@localhost ~]# visudo            # 进入sudo的配置编辑中
........................
## Allow root to run any commands anywhere 
root    ALL=(ALL)       ALL            # 允许使用sudo的用户

## Allows members of the 'sys' group to run networking, software, 
## service management apps and more.
# %sys ALL = NETWORKING, SOFTWARE, SERVICES, STORAGE, DELEGATING, PROCESSES, LOCATE, DRIVERS

## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL               # 允许使用sudo的组
.........................


[root@localhost ~]# gpasswd -a user03 wheel    # 将某个用户加入到wheel组，就可以使用sudo来执行命令了
[root@localhost ~]# su - user03
[user03@localhost ~]$ sudo whoami            # sudo后面的命令相当于是root输入的
[sudo] password for user03:                 # 输入的是当前普通用户的密码
root

[root@localhost ~]# visudo
.............
user02  ALL=(ALL)       ALL        # 单独允许某个用户有sudo权限
...........

# 最后的ALL是表示允许使用所有命令
# 如果只给几个可用的命令
user02  ALL=(ALL)       /usr/bin/whoami,/usr/bin/ls,/usr/bin/pwd
```

# 文件权限管理

- 文件所属用户与组

- 文件特殊权限

```C
[root@localhost ~]# ll -h
total 24K
-rw-r--r--. 1 root root 24K Jul 19 14:35 tree.txt
```

![image\.png](图片和附件/image%202.png)

每个文件的属性由左边第一个部分的10个字符来确定

- u

    - 文件属主

- g

    - 文件属组

- o

    - 其他用户

![image\.png](图片和附件/image.png)

```MATLAB
[root@Rocky ~]# ll -h
total 4.0K
drwxr-xr-x. 2 root root  6 Sep  9 10:29 dir
-rw-r--r--. 1 root root 77 Sep  9 20:58 tree.txt
[root@Rocky ~]# chmod g+w tree.txt    # tree.txt文件给属组添加w权限
[root@Rocky ~]# ll -h
total 4.0K
drwxr-xr-x. 2 root root  6 Sep  9 10:29 dir
-rw-rw-r--. 1 root root 77 Sep  9 20:58 tree.txt

[user02@Rocky ~]$ id
uid=6666(user02) gid=0(root) groups=0(root) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[user02@Rocky ~]$ echo "hello" >> /root/tree.txt     #修改之后可以写入

[root@Rocky ~]# chmod g=--- tree.txt    #把tree.txt的组权限全部删掉
[root@Rocky ~]# ll -h
total 4.0K
drwxr-xr-x. 2 root root  6 Sep  9 10:29 dir
-rw----r--. 1 root root 83 Sep  9 21:03 tree.txt

[user02@Rocky ~]$ chmod g=rwx /root/tree.txt 
chmod: changing permissions of '/root/tree.txt': Operation not permitted    #只有文件的属主和root有权限对文件进行修改

[root@Rocky ~]# chown user02 tree.txt     #属主root将文件所有权转给user02
[root@Rocky ~]# ll -h   
total 4.0K
drwxr-xr-x. 2 root   root  6 Sep  9 10:29 dir
-rw----r--. 1 user02 root 83 Sep  9 21:03 tree.txt

[user02@localhost ~]$ chmod u=--- /root/tree.txt    # user02此时就可以修改文件权限了
[user02@localhost ~]$ chmod g=--- /root/tree.txt
[user02@localhost ~]$ chmod o=--- /root/tree.txt
[root@localhost ~]# ll -h        # 对于root用户来说，不受权限约束
total 24K
drwxr-xr-x. 2 root   root   6 Jul 19 14:36 dir
----------. 1 user02 root 24K Jul 19 14:39 tree.txt

[user02@localhost ~]$ chmod u+r /root/tree.txt    # user02如果想查看自己的文件，也要加个r权限

[root@Rocky ~]# groupadd project1    #创建一个项目组
[root@Rocky ~]# chown user02:project1 tree.txt
[root@Rocky ~]# chmod g+rw tree.txt     #给属组添加权限
[root@Rocky ~]# ll -h
total 4.0K
drwxr-xr-x. 2 root   root      6 Sep  9 10:29 dir
-rw-rw-r--. 1 user02 project1 83 Sep  9 21:03 tree.txt
[root@Rocky ~]# gpasswd -a user03 project1
Adding user user03 to group project1

[user03@Rocky ~]$ cat /root/tree.txt    #文件放在root用户的家目录下还是不允许被查看
cat: /root/tree.txt: Permission denied

[user03@Rocky ~]$ cat /tmp/tree.txt     #放到其他约束小的文件可以查看
```

# 八进制语法

- 给不同的权限不同的数值，然后使用数值的方式来表示权限

    - 比如`chmod u=rw- file` 相当于`chmod 600 file`

    - `r` 数值是4，`w` 数值是2, `x` 数值是1

```SQL
[root@Rocky tmp]# chmod 666 tree.txt 
[root@Rocky tmp]# ll -h
total 4.0K
-rw-rw-rw-. 1 user02 project1 83 Sep  9 21:03 tree.txt
[root@Rocky tmp]# chmod 777 tree.txt 
[root@Rocky tmp]# ll -h
total 4.0K
-rwxrwxrwx. 1 user02 project1 83 Sep  9 21:03 tree.txt
[root@Rocky tmp]# chmod 640 tree.txt
[root@Rocky tmp]# ll -h
total 4.0K
-rw-r-----. 1 user02 project1 83 Sep  9 21:03 tree.txt
```

# 文件访问控制列表

- 传统Linux文件权限管理使用的是ugo的方式，并不能满足所有的情况

- 如果某个文件只想针对某一个用户做权限设置，其他所有的人都不给权限

```SQL
[root@Rocky tmp]# ll -h
total 4.0K
-rw-r-----. 1 user02 project1 83 Sep  9 21:03 tree.txt
[root@Rocky tmp]# setfacl -m u:user01:rw tree.txt    #facl=file acl，-m = -modify
[root@Rocky tmp]# ll -h
total 4.0K
-rw-rw----+ 1 user02 project1 83 Sep  9 21:03 tree.txt
[root@Rocky tmp]# getfacl tree.txt
# file: tree.txt
# owner: user02
# group: project1
user::rw-
user:user01:rw-
group::r--
mask::rw-
other::---

[root@Rocky tmp]# setfacl -b tree.txt #删除所有的访问控制列表

[root@Rocky tmp]# setfacl -b tree.txt 
[root@Rocky tmp]# ll -h
total 4.0K
-rw-r-----. 1 user02 project1 83 Sep  9 21:03 tree.txt
[root@Rocky tmp]# setfacl -m m::r-- tree.txt
[root@Rocky tmp]# getfacl tree.txt
# file: tree.txt
# owner: user02
# group: project1
user::rw-
group::r--
mask::r--
other::---

[root@localhost tmp]# setfacl -m m::r-- tree.txt        # 设置facl的mask，用于限制能给到的最大权限
[root@localhost tmp]# setfacl -m u:user01:rwx tree.txt
[root@localhost tmp]# getfacl tree.txt 
# file: tree.txt
# owner: user02
# group: project1
user::rw-
user:user01:rwx                        #effective:r--    # 就算给了rwx，能够生效的也只有
group::r--
mask::r--
other::---
[root@localhost tmp]# setfacl -m d:o::rw- homework/    # 想要让homework目录下新创建的文件，默认o=rw-
[root@localhost homework]# touch file
[root@localhost homework]# ll -h    # 配置facl之后，此目录下新建的文件，默认就是o=rw-
total 0
-rw-rw-rw-. 1 root root 0 Jul 19 15:48 file
```

# 特殊权限

- 除了rwx以外，还有三个特殊权限

    - suid

    - sgid

    - sticky

## suid

- 只能被设置在可执行程序上，如果被设置在不可执行程序上，就显示为S

- 有suid的可执行程序，在被调用的时候，不管是什么用户执行的，都以属主身份运行

```C
[root@localhost ~]# chmod u+s file
[root@localhost ~]# ll -h
total 0
-rwSr--r--. 1 root root 0 Jul 19 16:00 file        # u上面有S，表示suid设置无效


[root@localhost ~]# ll -h /etc/shadow        # 此文件保存着用户的密码信息
----------. 1 root root 904 Jul 19 13:53 /etc/shadow

# 为什么普通用户还能修改密码？
[user01@localhost ~]$ passwd
Changing password for user user01.
Current password: 
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.

# 原因出现在改密码的程序passwd
[root@localhost ~]# ll -h /usr/bin/passwd
-rwsr-xr-x. 1 root root 32K May 15  2022 /usr/bin/passwd        # u上面有s，表示suid被设置

[root@localhost ~]# which whoami
/usr/bin/whoami
[root@localhost ~]# ll -h /usr/bin/whoami
-rwxr-xr-x. 1 root root 32K Apr 21  2024 /usr/bin/whoami
[root@localhost ~]# chmod u+s /usr/bin/whoami        # 将whoami程序设置上了suid之后
[root@localhost ~]# ll -h /usr/bin/whoami
-rwsr-xr-x. 1 root root 32K Apr 21  2024 /usr/bin/whoami
[user01@localhost ~]$ whoami        # 被设置之前
user01
[user01@localhost ~]$ whoami        # 被设置之后，任何用户执行whoami都是root执行的
root
```

## sgid

- 能被设置在可执行程序上，如果被设置在不可执行程序上，就显示为S

- 能被设置在目录上，如果设置在目录上，那此目录下所有的新建文件，都会和目录是一个组的

- 有suid的可执行程序，在被调用的时候，不管是什么用户执行的，都以属组身份运行

```C
[root@localhost tmp]# mkdir worker
[root@localhost tmp]# chown .homework worker/        # 将worker目录的属组改为homework
[root@localhost tmp]# ll -h
total 4.0K
-rw-r--r--. 1 root   root     0 Jul 19 15:48 testfile
-rw-r-----+ 1 user02 project1 6 Jul 19 15:36 tree.txt
drwxr-xr-x. 2 root   homework 6 Jul 19 16:11 worker
[root@localhost tmp]# chmod g+s worker                # 添加sgid到woker目录上
[root@localhost tmp]# ll -h
total 4.0K
-rw-r--r--. 1 root   root     0 Jul 19 15:48 testfile
-rw-r-----+ 1 user02 project1 6 Jul 19 15:36 tree.txt
drwxr-sr-x. 2 root   homework 6 Jul 19 16:11 worker
[root@localhost tmp]# cd worker/
[root@localhost worker]# touch file            # 新建文件
[root@localhost worker]# ll -h
total 0
-rw-r--r--. 1 root homework 0 Jul 19 16:11 file        # 默认加入到homework组中
```

## sticky

- 只能用于目录上

- 该目录下所有的文件和子目录只能由属主删除

```C
[root@localhost tmp]# mkdir test1
[root@localhost tmp]# chmod o+t test1        # 加上sticky
[root@localhost tmp]# chmod g+w test1/
[root@localhost tmp]# chmod o+w test1/
[root@localhost tmp]# ll -h
total 0
drwxrwxrwt. 2 root root 6 Jul 19 16:15 test1

[user01@localhost test1]$ touch user01        # user01新建了一个文件

[user02@localhost test1]$ rm -rf user01        # 由于sticky被设置了，无法删除非自己的文件
rm: cannot remove 'user01': Operation not permitted
```

# 文件属性

chattr命令用于改变文件属性。

这项指令可改变存放在文件或目录属性，这些属性共有以下8种模式：

- a：让文件或目录仅供追加用途

    - 用于日志防篡改

- b：不更新文件或目录的最后存取时间

- c：将文件或目录压缩后存放

- i：不得任意更动文件或目录

    - 防止文件被修改，比如一些重要的配置文件

- s：保密性删除文件或目录

- S：即时更新文件或目录

- u：预防意外删除

```C
[root@localhost ~]# lsattr log         # 查看文件属性
---------------------- log
[root@localhost ~]# chattr +i log         # 加上i
[root@localhost ~]# lsattr log 
----i----------------- log
[root@localhost ~]# echo "test" > log        # 尝试修改文件的时候，没有权限
-bash: log: Operation not permitted
[root@localhost ~]# ll -h
total 0
-rw-r--r--. 1 root root 0 Jul 19 16:22 log


[root@localhost ~]# chattr -i log 
[root@localhost ~]# chattr +a log         # 加上a属性，此文件只能追加，不能覆盖
[root@localhost ~]# echo "test" > log
-bash: log: Operation not permitted
[root@localhost ~]# echo "test" >> log    # 追加内容是可以的
[root@localhost ~]# echo "test" >> log


┌──(root㉿kali)-[~]
└─# lsattr web-dvwa.tar 
--------------e------- web-dvwa.tar        # e代表这个文件在 ext4 里使用 **Extents（区段）** 来管理磁盘块，不再用传统间接块指针。
```



