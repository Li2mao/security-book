# Day1

# 操作系统

- Windows

    - 闭源且收费

    - 主要用于日常办公、游戏、娱乐

- Linux

    - 开源

    - 主要用于服务器领域，性能稳定，安全

    - 嵌入式领域

    - 信创系统（国产化技术硬件）

- Unix

    - 用于封闭的硬件环境，大多数软件都需要定制化开发

## Linux图谱

Linux发展到今天出现了大量不同的分支。不同的分支都有不同的发展方向，可以扫描下面二维码，查看Linux发现分支图，或者点开https://i\-blog\.csdnimg\.cn/blog\_migrate/15527b01d1ad00636514aaf21fa6197e\.png

这些分支都是在某个内核下通过外加套件发展而来的。就像电脑，它本身除了以外什么都不包含，于是我们安装了屏幕驱动，鼠标驱动，还有桌面之类的。像是桌面这种驱动是可以关闭的。

- 关闭电脑的桌面

    - 打开任务管理器，找到详细信息，搜索explorer，右键，结束任务

![image\.png](图片和附件/image%205.png)

- 开启桌面的方法

    - 打开任务管理器，运行新任务

![image\.png](图片和附件/image%206.png)

## Redhat认证

![image\.png](图片和附件/image%2011.png)

# RockyLinux

- https://rockylinux\.org/

- 红帽的下游系统，使用redhat系统的源码进行编译，和redhat一样稳定，100%兼容

![image\.png](图片和附件/image%2013.png)

- 下载的方式

    - DVD：鼠标点点点，各种图形化操作，更加方便，但同时也需要更大的下载空间

    - Boot：下载空间小，下载一个启动程序，然后让电脑联网，从网上下载linux镜像

    - Minimal：只有必要的软件，其余什么都没有。企业更喜欢这种默认的，不带其他杂质的Linux。（之后学习的Linux中还额外下载了Docker镜像【需要翻墙下载】，这个不包含在内）

![image\.png](图片和附件/image%2010.png)

- 每个Linux系统都100%拥有root用户

# SSH连接

- 开启虚拟机

![image\.png](图片和附件/image%204.png)

- 登录Linux，用户名是root，密码是1，默认情况下数字小键盘是不启用

![image\.png](图片和附件/image.png)

- 查看系统的IP地址，输入`ip address` 查看系统IP地址

![image\.png](图片和附件/image%2014.png)

## xshell

- 方法一：打开xshell，输入`ssh root@192.168.198.135` 之后回车，会提示输入密码

![image\.png](图片和附件/image%202.png)

- 方法二：

    - 打开xshell，点击左上角新建会话，输入好名称，更改协议为`SSH`，输入主机的IP地址。

![image\.png](图片和附件/image%2017.png)

    - 点击用户身份验证，输入用户名`root`和密码`1`，点击确定

![image\.png](图片和附件/image%203.png)

    - 随后点击文件夹，就可以看到新加的Rocky Linux

![image\.png](图片和附件/image%201.png)

- 为什么用xshell连接：

    - Linux里面复制粘贴麻烦，用xshell方便

    - 现实的Linux服务器都是在机房里面，所以可以通过xshell用IP地址连接

    - 有些租的服务器在国外，可以通过IP地址连接

## cmd

- 使用windows的cmd同样可以连接进入Linux

![image\.png](图片和附件/image%2015.png)

# 虚拟机快照

快照可以让你的虚拟机恢复到初始状态，以至于你怎么玩都不会玩坏

- 恢复快照步骤：

![image\.png](图片和附件/image%208.png)

# Linux基础命令

## 提示符

登录Linux之后，默认会进入一个可命令交互的页面，这个页面会有一个提示符号

```Bash
[root@localhost ~]# 
[用户名@主机名 目录名]权限标识
```

- 用户名

    - 显示当前登录的用户是谁

- 主机名

    - 当前计算机的名字

    - 修改主机名`hostnamectl set-hostname Rocky`，修改之后`exit`退出，重新登录才能生效

- 目录名

    - 当前操作所在的目录

    - `~`符号表示当前用户的家目录，就类似于windows的桌面

- 权限标识

    - `#`表示当前用户具备超级管理员权限

    - `$`表示当前用户只是普通用户

## shell语法

- 命令\+选项\+参数

```C
[root@Rocky ~]# cal --year -m 1752
```

- 命令

    - `cal`是命令，用于查看日历

- 选项

    - 选项是可以不写，这样会有默认行为，也可以写多个

    - 长选项

        - `--monday`表示周一为一周的第一天

        - `--year`表示显示一整年

    - 短选项

        - `-m`等同于`--monday`

        - `-y`等同于`--year`

        - 短选项是可以写在一起`-ym`或者`-my`

- 参数

    - 参数是可以不写，这样会有默认参数，也可以写多个

    - `1752`就是查看日历命令作用的对象

查看某条命令的帮助

```C
[root@Rocky ~]# cal --help

Usage:
 cal [options] [[[day] month] year]
 cal [options] <timestamp|monthname>

Display a calendar, or some part of it.
Without any arguments, display the current month.

Options:
 -1, --one             show only a single month (default)
 -3, --three           show three months spanning the date
 -n, --months <num>    show num months starting with date's month
 -S, --span            span the date when displaying multiple months
 -s, --sunday          Sunday as first day of week
 -m, --monday          Monday as first day of week
 -j, --julian          use day-of-year for all calendars
     --reform <val>    Gregorian reform date (1752|gregorian|iso|julian)
     --iso             alias for --reform=iso
 -y, --year            show the whole year
 -Y, --twelve          show the next twelve months
 -w, --week[=<num>]    show US or ISO-8601 week numbers
 -v, --vertical        show day vertically instead of line
     --color[=<when>]  colorize messages (auto, always or never)
                         colors are enabled by default

 -h, --help            display this help
 -V, --version         display version

For more details see cal(1).
```

## 常用命令

Linux命令速查手册:https://iproute\.cn/html/linux/

### ls

显示目录内容列表

```C
[root@Rocky ~]# ls       #查看当前目录下有哪些文件
anaconda-ks.cfg

[root@Rocky ~]# ls -l    #查看当前文件的详细信息
total 4
-rw-------. 1 root root 907 May 15  2025 anaconda-ks.cfg

[root@Rocky ~]# ls -la    #查看当前目录下的隐藏文件，文件名以.开头，就是隐藏文件

[root@Rocky ~]# ls -lh    #让文件的大小以合适的单位显示出来

[root@Rocky ~]# ls -F    #在显示出来的文件夹后面标识/

[root@Rocky ~]# ll -h    #ll是ls -l的别名
```

### cd

切换用户当前工作目录

```C
[root@Rocky ~]# cd 目录名

[root@Rocky etc]# cat ../root/file    #查看相对当前目录的上一层目录root下的file

[root@Rocky etc]# cat /root/file    #查看绝对路径/root/file

[root@Rocky ~]# cd         #在空格后按两下TAB键，就会查看当前目录下可以cd的文件
.bash_history  .bashrc        .ssh/          .viminfo
.bash_logout   .cshrc         .tcshrc        tree.txt
.bash_profile  .lesshst       .tree.txt.swp  tree.txt.old

#在输入命令中途按一下TAB键，此命令会自动补全，按两下TAB键会找到此开头的所有命令
#在命令输入完后，按两下TAB键会显示当前目录下的文件
```

- 绝对路径

    - 从`/`根目录开始，写某个文件夹具体的位置

- 相对路径

    - 从当前位置开始，写某个文件夹的位置

- `cd`命令几个特殊目录

    - `cd`直接回车，默认的参数是当前用户的家目录

    - `cd -`回到上一次的目录\(类似于撤回\)

    - `cd ..`回到上一层目录

    - `cd .`去往当前目录

### pwd

显示当前工作目录的绝对路径

```C
[root@Rocky ~]# pwd
/root
```

### clear

清除当前屏幕终端上的任何信息

```C
[root@Rocky ~]# clear
```

- 可以使用快捷键`ctrl`\+`l`来清空屏幕

### echo

输出指定的字符串或者变量

```C
[root@Rocky ~]# echo "hello world"
hello world

[root@Rocky ~]# help echo    #查看帮助

[root@Rocky ~]# echo -e "hello\nworld"    #-e允许执行转义符号标注的特殊字符，通过help echo查看
hello
world

[root@Rocky ~]# echo "hello world" > hello.txt    #使用>符号，可以把原本显示在屏幕上的内容显示到文件中
[root@Rocky ~]# cat hello.txt
hello world
```

### 重定向功能实现聊天

- 在某个时刻如果一台Linux设备有多人登录，则可以通过`last`查看登录信息，然后在第二列查看到其余用户姓名。

- 通过输入`echo "聊天内容" > /dev/名字`来实现聊天

![image\.png](图片和附件/image%209.png)

- 此时另一台机器上就会显示信息，但是不会运行这个消息。

![image\.png](图片和附件/image%207.png)

- 可以通过恶意脚本，发送大量乱码信息，导致其余人无法正常使用Linux

## 系统命令

### poweroff

关闭Linux系统，关闭记录会被写入到/var/log/wtmp日志文件中

```C
poweroff -d    #关机但是不记录在日志里面
```

### reboot

重新启动正在运行的Linux操作系统

### halt

关闭正在运行的Linux操作系统

### shutdown

用来执行系统关机的命令

### top

查看linunx系统的任务管理器

- 按下m会显示内存占用的进度条

- 搭配在xshell中复制会话使用，更加方便

### last

列出目前与过去登入系统的用户相关信息（如果是厉害的黑客的话，这个也不可信）

### whoami

打印当前有效的用户ID对应的名称

## 快捷键

## 别名

- 为了方便Linux操作，允许为命令设置别名

```SQL
[root@Rocky ~]# alias wl='ping -c 4 223.5.5.5'    #临时将一个命令进行命名
[root@Rocky ~]# wl
PING 223.5.5.5 (223.5.5.5) 56(84) bytes of data.
64 bytes from 223.5.5.5: icmp_seq=1 ttl=128 time=38.9 ms
64 bytes from 223.5.5.5: icmp_seq=2 ttl=128 time=43.2 ms
64 bytes from 223.5.5.5: icmp_seq=3 ttl=128 time=41.5 ms
64 bytes from 223.5.5.5: icmp_seq=4 ttl=128 time=58.0 ms

--- 223.5.5.5 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 38.917/45.410/58.040/7.449 ms

[root@Rocky ~]# alias    #查看已存在的别名
alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias xzegrep='xzegrep --color=auto'
alias xzfgrep='xzfgrep --color=auto'
alias xzgrep='xzgrep --color=auto'
alias zegrep='zegrep --color=auto'
alias zfgrep='zfgrep --color=auto'
alias zgrep='zgrep --color=auto'

[root@Rocky ~]# \ls    #在命令前加上\符号，可以不执行别名
anaconda-ks.cfg  dir

#永久的alias别名
[root@Rocky ~]# vim /etc/bashrc    #当我们打开bash交互界面，登录上命令行，就相当于打开了bash，此文件会被自动执行
...省略...
alias wl='ping -c 4 223.5.5.5'    #在最后加上这个命令，退出linux重新登陆，此命令生效
```

- 别名不要随意覆盖已存在的命令

```C
[root@Rocky ~]# alias ls='rm -rf /'    #当下次输入ls的时候，系统就自毁了。真正毁数据库指令/后面要加*  由于太过危险，所以命令没写全
[root@Rocky ~]# unlias ls    #删除别名，恢复原生命令
```

# 文件管理

- `ls`

    - 查看当前目录下的文件

    - `ls /etc`查看/etc目录下的文件（这个etc文件里面装着Linux所有的配置文件，如果删除下次就不能开机了）

- `cd`

    - 切换目录

- `pwd`

    - 查看当前在哪个目录下

## touch

- 创建新的空文件

```C
[root@Rocky ~]# touch file1
```

`touch` 命令在 Linux 中主要用于修改文件的时间戳（访问时间 `atime` 和修改时间 `mtime`），以下是具体操作方法和示例：

---

### 1\. 基本时间戳修改

默认情况下，`touch` 会同时更新文件的访问时间和修改时间为当前系统时间：

```Bash
touch filename.txt  *# 更新 filename.txt 的 atime 和 mtime*
```

效果：

- 若文件存在，时间戳更新为当前时间；若文件不存在，则创建空文件（除非使用 `-c` 选项）。

---

### 2\. 仅修改特定时间戳

通过选项单独修改 `atime` 或 `mtime`：

- 仅更新访问时间 \(`atime`文件访问时间\)​：

```Bash
touch -a filename.txt  *# 只更新 atime*
```

- 仅更新修改时间 \(`mtime`文件修改时间\)​：

```Bash
touch -m filename.txt  *# 只更新 mtime*
```

注意​：`ctime`（状态变更时间）无法通过 `touch` 直接修改，它由系统自动更新

---

### 3\. 指定自定义时间

使用 `-d` 或 `-t` 选项设置具体时间：

- `-d`：人类可读的日期字符串

```Bash
touch -d "2024-01-01 12:00:00" filename.txt  *# 设置为 2024 年元旦中午*
```

- 支持灵活格式（如 `"next Thursday"` 或 `"yesterday"`）

- `-t`：精确时间戳格式 `[[CC]YY]MMDDhhmm[.ss]`

```Bash
touch -t 202401011200.30 filename.txt  *# 设置为 2024-01-01 12:00:30*
```

- 示例中 `CC` 为世纪（可选），`YY` 为年份后两位

## mkdir

用来创建目录

```C
[root@Rocky ~]# mkdir dir1 dir2 dir3
[root@Rocky ~]# ls
anaconda-ks.cfg  dir  dir1  dir2  dir3  file1
[root@Rocky ~]# mkdir dir{1..9}    #命令行的特性，{1..9}表示传入1~9的9个参数,dir1~9
[root@Rocky ~]# ls
dir1  dir2  dir3  dir4  dir5  dir6  dir7  dir8  dir9

[root@Rocky ~]# mkdir dir{a..z}    #传入26个参数

[root@Rocky ~]# mkdir a/b    #默认情况下没有父文件夹a无法创建子文件夹b
mkdir: cannot create directory ‘a/b’: No such file or directory
[root@Rocky ~]# mkdir -p a/b    #输入-p可以自动解决父子文件夹关系
[root@Rocky ~]# tree
.
└── a
    └── b

2 directories, 0 files

```

## cp

将源文件或目录复制到目标文件或目录中

```C
[root@Rocky ~]# cp file1 dir/file2    #将file1复制到dir中，并且重命名为file2
[root@Rocky ~]# ls dir
file2

[root@Rocky ~]# cp tree.txt{,.old}    #tree.txt{,.old}相当于传入tree.txt tree.txt.old
[root@Rocky ~]# ls                    #可以用于备份文件
tree.txt  tree.txt.old

[root@Rocky ~]# cp -r dir/ dir1/    #复制文件夹，需要加上-r
```

## mv

用来对文件进行移动或对目录重新命名

```C
[root@Rocky ~]# mv file1 file2    #重命名
[root@Rocky ~]# ls
anaconda-ks.cfg  dir  dir1  dir2  dir3  file2
[root@Rocky ~]# mv file2 dir1/    #移动文件
[root@Rocky ~]# ls dir1
file2

[root@Rocky ~]# mv -v tree.txt dir/    #-v可以显示移动的过程
renamed 'tree.txt' -> 'dir/tree.txt'

[root@Rocky ~]# tree -L 2    #-L是树的深度，查看几层
.
├── a
│   └── b
├── dir
│   ├── dir1
│   └── tree.txt
├── dir1
│   └── dir
└── tree.txt.old

6 directories, 2 files
```

## tree

- 树状图列出目录的内容

- 最小化安装的redhat系列Linux不自带这个命令

    - `yum -y install tree`

```C
[root@Rocky ~]# tree
.
├── anaconda-ks.cfg
├── dir
│   └── file2
├── dir1
│   └── file2
├── dir2
└── dir3

4 directories, 3 files
[root@Rocky ~]# mv dir1/file2 .    #将文件复制到当前目录
[root@Rocky ~]# tree
.
├── anaconda-ks.cfg
├── dir
│   └── file2
├── dir1
├── dir2
├── dir3
└── file2

4 directories, 3 files
```

## rm

用于删除给定的文件和目录

```XML
[root@Rocky ~]# rm file2
rm: remove regular empty file 'file2'? y
[root@Rocky ~]# touch file2
[root@Rocky ~]# rm -f file2    #直接删除不提示
[root@Rocky ~]# rm -rf dir    #强制删除文件夹以及文件，此处的dir是文件名称
[root@Rocky ~]# rm -rf /*    #删除根目录下的所有文件。！！！这条命令非常危险！！！
```

# 文件查看

在Linux中一切皆文件

## cat

查看某个文件，并且将内容打印出来

```XML
[root@Rocky ~]# cal -y > cal.txt    # >是输出重定向，可以把原本输出到屏幕上的内容输出到文件中
[root@Rocky ~]# cat cal.txt    #查看文件

[root@Rocky ~]# cat test1.txt 
Hello World
你好
我好
大家好
[root@Rocky ~]# tac test1.txt     #可以倒过来查看文件
大家好
我好
你好
Hello World

[root@Rocky ~]# cat -n test1.txt    #-n显示行号
     1        Hello World
     2        你好
     3        我好
     4        大家好
[root@Rocky ~]# cat -A test1.txt    #将英文和空格以外的字符都显示出来，比如换行符
Hello World$
M-dM-=M- M-eM-%M-=$
M-fM-^HM-^QM-eM-%M-=$
M-eM-$M-'M-eM-.M-6M-eM-%M-=$
```

## less

查看文件，可以上下翻页看

```XML
[root@Rocky ~]# tree /etc > tree.txt
[root@Rocky ~]# less tree.txt    #可以方向键上下翻页，按q退出

[root@Rocky ~]# more tree.txt    #上下翻页，回车换行，按q退出，可以显示文件查看的百分比
```

## head

查看文件的开头

```XML
[root@Rocky ~]# head tree.txt    #默认看文件开始的10行
[root@Rocky ~]# head -18 tree.txt    #查看文件开始的18行
```

## tail

查看文件的结尾

```XML
[root@Rocky ~]# tail tree.txt    #默认看文件结束的10行
[root@Rocky ~]# tail -8 tree.txt    #查看文件结束的8行
```

- 可以持续查看文件末尾的变化，常用于查看日志

```XML
[root@Rocky ~]# tail -f  /var/log/messages    #跟踪日志文件末尾的变化
```

# 文本编辑

## 重定向

### 输出重定向

- 使用`>`或者`>>`来写入文件内容

    - `>`表示覆盖文件写入

    - `>>`表示文件末尾追加

```SQL
[root@Rocky ~]# touch file
[root@Rocky ~]# echo "hello world" > file    #覆盖写入
[root@Rocky ~]# cat file
hello world
[root@Rocky ~]# echo "hello world" >> file    #追加写入
[root@Rocky ~]# cat file
hello world
hello world

[root@Rocky ~]# cat    #如果只输入一个cat回车，就会等待用户键盘的输入

[root@Rocky ~]# cat <<EOF > test2.txt    #使用cat可以写入文件，遇到EOF的时候，就会结束
> 你好
> 我好
> 大家好
> EOF
[root@Rocky ~]# cat test2.txt
你好
我好
大家好
```

### 输入重定向

- 恶意截取对方输入

    - last获取名称

    - 两个人还是在同一台linux机器下，通过last查看对方名称。

    - 然后通过`cat < /dev/名称`来进行输入重定向，截取对方的输入

    - 此方法截取的内容不会被记录在被截取的机器中，导致命令输入不全

    ```XML
    =========1==========
    [root@Rocky ~]# cat < /dev/pts/1
    hll wold
    =========2==========
    [root@Rocky ~]# eor        #输入内容为hello world但是被截取
    ```

## vi/vim\(文本编辑器\)

- vim是vi的升级版，可能需要安装`yum -y install vim`

- vim和电脑上记事本是一样的，可以编辑文本，但是vim没有菜单，所有的操作都靠快捷键

![image\.png](图片和附件/image%2012.png)

### vim的模式

- 命令模式

    - 等待用户的输入，来决定下面进入什么模式

    - 如果输入的是`i`或者`o`会进入到输入模式，输入模式就可以随意编辑文本

    - 如果输入的是`:`按键（需要英文），就进入到末行模式，此时可以输入命令

    - 常见操作

        - `gg`光标跳到文件开头

        - `G`光标到文件结尾

        - `yy`复制

        - `23yy`复制从光标开始往下23行

        - `p`粘贴

        - `u`撤销

        - `dd`剪切/删除光标所在那一行

        - `20dd`剪切从光标开始往下20行

        - `dG`从光标开始剪切到结尾

        - `yG`从光标开始复制到结尾

        - `dgg`剪切从光标开始到开头

        - `/host`搜索host，开启搜索后，`n`可以查看下一个结果，`N`可以查看上一个结果

- 输入模式

    - 可以随意地编辑文本

    - `esc`键回到命令模式

- 末行模式

    - 按`esc`键可以回到命令模式

    - 可以输入vim支持的指令

        - `:w`保存

        - `:q`退出

        - `:wq`保存退出

        - `:qw`报错

        - `:q!`不保存退出

        - `:wq!`强制保存并退出

    - 还有别的操作

        - `:x`相当于`:wq`

        - `:X`加密当前文件，只有vim支持，vi不支持

            - 这个加密可以在原本基础上再次加密，再次输入`:X`，并且退出时输入`:wq!`。

            - 但是通过这种手段加密的话，需要输入最后的那个密码

            - 然后输入`:X`，但是此时直接回车，让密码为空，然后再输入最开始的密码

            - 主打我看不到，你也别想看到

        - `:set number`设置显示行号

        - `:set ai`设置自动缩进（方便写代码时候用，使代码可读性更强）

        - `set mouse=a`设置支持鼠标改变光标位置

        - `set paste`设置粘贴模式，在粘贴制表符的时候会自动和缩进合并

# 文件管理的图形化操作 

![image\.png](图片和附件/image%2016.png)





