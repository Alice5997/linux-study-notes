# Linux_day07_Vim 拓展 + JDK+Tomcat+MariaDB 部署实操笔记

## 基础信息

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh "autolink")

2、今日观看选集（修正集号匹配错误）

054_尚硅谷_JavaEE 定制篇_JDK 安装和配置

055_尚硅谷_JavaEE 定制篇_Tomcat 安装和配置

057_尚硅谷_JavaEE 定制篇_MySQL 安装和配置

⚠️重要说明：

①053 YUM 软件管理已在 Day5 完整学完，今日不再重复；

②056 Eclipse 图形桌面 IDE，服务器运维无使用场景，直接跳过不实操；

③Vim 高级操作为前置巩固拓展模块，无对应视频集，放在最开头练习。

3、系统环境：CentOS Stream9，登录普通用户 study

4、当日统一规范（与 Day1~Day6 格式完全统一）

当日总目录：`~/day07_test01`

软件存放子目录：`~/day07_test01/software`

测试网页文件：`index_test.html`

vim 个人配置文件：`~/.vimrc`

5、实操规则：所有命令手动输入，禁止复制；每模块实操完成后，在对应位置插入终端截图。

## 一、初始化练习目录（家目录～执行）

bash

```
# 创建主目录+软件存放子文件夹
mkdir -p ~/day07_test01/software
cd ~/day07_test01
# 创建测试网页文件
touch index_test.html
# 写入测试网页内容
echo "<h1>Day07 Tomcat测试页面</h1>" > index_test.html
```

【此处放置截图：ls 查看 day07_test01 完整目录结构】
![[Pasted image 20260809003323.png]]
![[Pasted image 20260809003343.png]]

## 模块 1：拓展实操 - Vim 高级使用（无对应视频，巩固练习）

### 核心知识点

1、三种模式流转：命令模式→i/a/o 插入模式→Esc 退回命令→输入`:`进入底行模式

2、进阶功能：行号显示、快速跳转、全文替换、批量复制 / 删除、文件另存

3、`~/.vimrc`是用户独立配置文件，仅 study 用户生效，新开终端自动加载，当前终端不刷新

### 实操命令

bash

```
# 打开测试网页实操vim
vim index_test.html

# 底行模式常用指令
:set nu       # 显示行号
:set nonu     # 关闭行号
:15           # 直接跳转到第15行
:s/old/new    # 当前行首个字符替换
:%s/old/new/g # 全文全局替换（g代表全部匹配）
:w test_bak.html # 文件另存为备份
:q!           # 不保存强制退出
:wq           # 保存并正常退出
:wq!          # 强制保存退出

# 命令模式快捷操作
yy    # 复制当前一行
5yy   # 向下复制5行
p     # 粘贴
dd    # 删除当前行
10dd  # 向下删除10行
gg    # 跳转文件首行
G     # 跳转文件末尾
u     # 撤销上一步修改

# 配置个人vim永久环境（任意目录执行）
vim ~/.vimrc
# .vimrc写入配置内容
set nu
set expandtab
set tabstop=4
set shiftwidth=4
```

【此处放置截图 1：vim 行号、全文替换实操界面】
![[Pasted image 20260809003721.png]]
【此处放置截图 2：~/.vimrc 配置文件内容】
![[Pasted image 20260809003956.png]]
![[Pasted image 20260809004043.png]]
### 本模块避坑标注

1、编辑后未按 Esc 直接输入冒号，会出现乱码；必须先返回命令模式才能进底行；

2、`.vimrc`修改后，当前终端不生效，需要新开终端；

3、全局替换缺少`g`参数，只会替换每行第一个匹配文字。

### 本模块自检清单

- [ ]  熟练使用行号、跳转、复制删除快捷键
- [ ]  能独立编写`.vimrc`基础配置

## 模块 2：JDK17 安装（对应 054_JDK 安装和配置）

### 核心知识点

1、CentOS Stream9 使用 ==dnf 安装官方 OpenJDK==，无需手动配置全局环境变量；

2、JRE 仅能运行 Java 程序，无编译工具`javac`；==开发必须安装`-devel`开发包；==

3、双重校验：`java -version`（运行环境）、`javac -version`（编译工具）都正常才算安装完成。

4、`dnf search`不要输入长字符串`java‑openjdk`，使用简短关键词`openjdk`检索；

5、CentOS 系统支持同时安装多个 JDK 版本，使用`alternatives`工具快速切换系统默认 JDK。

### 实操命令

bash

```
# 1、确认启用的软件仓库
sudo dnf repolist enabled

# 2、简短关键词搜索jdk
sudo dnf search openjdk

# 3、安装JDK8完整开发包（和课程版本对齐）
sudo dnf install java-1.8.0-openjdk-devel -y

# 4、校验Java运行环境
java -version

# 5、校验Java编译工具
javac -version

# 6、查看JDK全部安装文件路径
rpm -ql java-1.8.0-openjdk-devel

# ============ 拓展：多JDK版本切换（可选实操） ============
# 如果后续安装了JDK17，系统存在多个JDK，执行下面命令切换默认java
sudo alternatives --config java

# 同步切换javac编译器版本
sudo alternatives --config javac

# 切换完成后再次校验版本
java -version
javac -version
```

【此处放置截图：dnf 搜索输出、java、javac 输出版本信息；切换版本可以选做截图】
![[Pasted image 20260809010751.png]]
![[Pasted image 20260809010810.png]]
![[Pasted image 20260809010831.png]]
![[Pasted image 20260809010851.png]]
![[Pasted image 20260809010909.png]]


==执行这个命令提示404错误：==
sudo dnf install java-1.8.0-openjdk-devel -y

出现 `Status code:404` 阿里云镜像访问异常，包下载缓存下来，但事务没有真正完成安装。

### 执行校验，确认现状

bash

```
java -version
javac -version
```

- 如果提示命令找不到：代表没装上
- 如果输出版本号：才是真正安装完成

### 修复方案

1. 清理损坏缓存

bash

```
sudo dnf clean packages
```

2. 重新执行安装

bash

```
sudo dnf install java-1.8.0-openjdk-devel -y
```

> 404 属于镜像临时网络问题，缓存了 rpm 包，但没有写入系统。`‑y`只是自动确认，遇到仓库 404 报错依然会终止安装。

安装结束终端输出 `完毕！` 才代表成功。

安装完之后再跑`java -version`、`javac -version`两条命令。

修复之后还是404错误：
![[Pasted image 20260809010339.png]]
### 问题原因

阿里云镜像的 GPG 密钥地址 404 访问失败，导致包虽然下载完成，但**校验失败拒绝写入系统**，javac、java 命令依然不存在。

#### 临时解决方案（跳过 gpg 校验，先完成 JDK 安装练习）

bash

```
sudo dnf install java-1.8.0-openjdk-devel -y --nogpgcheck
```

> `--nogpgcheck`：临时跳过 GPG 密钥校验，只本次安装生效，适合镜像密钥 404 的故障场景。

安装结束看到 `完毕！`，再执行校验：

bash

```
java -version
javac -version
```
![[Pasted image 20260809010542.png]]

### 本模块避坑标注

1、`dnf search`普通用户直接执行搜不到包，search 同样需要`sudo`提权；

2、搜索软件包尽量用短关键词，长完整包名容易匹配不到结果；

3、只装不带`‑devel`的包，缺少`javac`编译命令，无法做开发练习；

4、手滑拼写错误（如`clena`代替`clean`）会提示找不到命令，仔细核对单词；

5、`alternatives --config java`只修改系统默认版本，不会删除已经安装的其他 JDK 包。

6、dnf 出现 404，即便下载进度走完，不等于安装完成；必须看到事务执行完毕提示，再做版本校验。

7、dnf 镜像出现 GPG‑KEY 404，即使 rpm 包下载完毕也会终止安装；练习环境增加参数`--nogpgcheck`临时跳过密钥校验完成安装；**生产环境严禁长期关闭 GPG 校验**。
### 模块自检清单

- [x]  `java -version`正常输出版本
- [x]  `javac -version`正常输出版本
- [ ]  （拓展）多版本环境下，`alternatives`切换版本生效

## 模块 3：Tomcat9 部署（对应 055_Tomcat 安装和配置）

### 核心知识点

1、Tomcat 为 ==JavaWeb 容器==，依赖完整 JDK 环境，默认监听 ==8080 端口==；

2、启停脚本：`startup.sh`启动、`shutdown.sh`关闭；

3、外部浏览器访问失败，优先排查防火墙 8080 端口、虚拟机 192.168.133 NAT 网段。

![[Pasted image 20260809012415.png]]

### 实操命令

bash

```
# 进入软件存放目录
cd ~/day07_test01/software

# 下载Tomcat9压缩包
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz

# 解压压缩包
tar -zxvf apache-tomcat-9.0.96.tar.gz

# 进入Tomcat根目录
cd apache-tomcat-9.0.96

# 后台启动Tomcat
bin/startup.sh

# 任意目录查看Tomcat后台进程
ps aux | grep tomcat

# 正常停止Tomcat
bin/shutdown.sh
```

【此处放置截图：解压目录、启动后进程查询结果】
![[Pasted image 20260809012433.png]]
![[Pasted image 20260809012452.png]]
![[Pasted image 20260809012507.png]]
验证：
![[Pasted image 20260809012750.png]]

### 本模块避坑标注

1、==Tomcat 启动成功≠外网可访问，需要防火墙放行 8080 端口；==

2、本机网卡为 ens160，静态 IP 必须在 192.168.x 网段，否则无法访问；

3、直接关闭终端不会停止进程，必须执行 shutdown.sh 正常关闭；

4、启动报错查看 logs/catalina.out 日志排查问题。

### 本模块自检清单

- [x]  可正常下载、解压 Tomcat 压缩包
- [x]  startup.sh 正常启动，ps 能查询到 Tomcat 进程

## 模块 4：MariaDB (兼容 MySQL) 安装（对应 057_MySQL 安装和配置）

### 核心知识点

1、CentOS Stream9 无原版 MySQL，系统内置 MariaDB，SQL 语法完全兼容；

2、数据库默认端口 3306，使用 systemctl 管理启停、开机自启；

3、安装后必须执行`mysql_secure_installation`做安全初始化，消除匿名空账号风险。

### 实操命令

bash

```
# 1、安装数据库服务端+客户端
sudo dnf install mariadb-server mariadb -y

# 2、启动数据库服务
sudo systemctl start mariadb

# 3、设置开机自动启动
sudo systemctl enable mariadb

# 4、查看数据库运行状态
sudo systemctl status mariadb

# 5、安全初始化（必做）
sudo mysql_secure_installation

# 6、密码登录数据库客户端
mysql -uroot -p
```

【此处放置截图：systemctl 服务状态、mysql 登录界面】
![[Pasted image 20260809015649.png]]
![[Pasted image 20260809015713.png]]
![[Pasted image 20260809015729.png]]
![[Pasted image 20260809015741.png]]
这里出现404错误：
![[Pasted image 20260809015901.png]]
又是阿里云镜像 GPG‑KEY 地址 404，包下载完成，校验失败没有真正安装。

#### 直接带上 `--nogpgcheck` 参数执行

bash

```
sudo dnf install mariadb-server mariadb -y --nogpgcheck
```

这个参数本次安装临时跳过 GPG 密钥校验，专门解决当前镜像 404 问题。

执行完成后校验：

bash

```
rpm -qa |grep mariadb
```

能输出 mariadb‑server 版本包，才算真正安装成功。
![[Pasted image 20260809015950.png]]

这里
Enter current password for root (enter for none): 直接回车
这一步错输入了虚拟机用户的密码，后续只能设置一个密码：==`Root@123456`==

原来正常步骤应该是：
交互问答参考（学习环境直接照这个选）：

1. Enter current password for root (enter for none): 直接回车
2. Set root password? [Y/n] **Y**，设置 root 数据库密码，记好
3. Remove anonymous users? [Y/n] **Y**
4. Disallow root login remotely? [Y/n] **Y**
5. Remove test database and access to it? [Y/n] **Y**
6. Reload privilege tables now? [Y/n] **Y**
由于输错之后
![[Pasted image 20260809015827.png]]
![[Pasted image 20260809015842.png]]


### 本模块避坑标注

1、执行`mysql_secure_installation`按提示一步步设置 root 密码；

2、需要 Navicat/DBeaver 等外部工具连接，防火墙放行 3306 端口；

3、忘记 root 密码：停止服务，跳过授权表重置密码；

4、所有 systemctl 操作必须加 sudo 提权。


## 续如果忘记数据库 root 密码怎么办（记到笔记）

不需要重装，直接一套命令重置密码即可，不用卸载数据库：

bash

```
#停止mariadb
sudo systemctl stop mariadb
#跳过授权启动
sudo mysqld_safe --skip-grant-tables &
sudo mysql
```

在数据库内执行重置：

sql

```
FLUSH PRIVILEGES;
SET PASSWORD FOR root@localhost = PASSWORD('新密码');
exit;
```

再杀掉后台进程，重新启动服务。

### 本模块自检清单

- [x]  systemctl status mariadb 显示 active (running)
- [x]  输入密码可正常登录数据库

# 当日统一汇总踩坑记录

1、Vim 修改`.vimrc`仅新开终端生效；

2、JDK 不加 - devel 参数缺少 javac 编译命令；

3、Tomcat 外网访问失败优先检查 8080 防火墙、虚拟机网段；

4、MariaDB 不执行安全初始化存在匿名空用户，有安全隐患；

5、wget 下载软件超时可更换镜像或手动上传压缩包；

6、systemctl 管理服务必须使用 sudo。

# ✅当日总自检清单

- [ ]  Vim 掌握行号、替换、复制删除，自定义 vim 配置文件
- [ ]  dnf 安装 JDK17，java、jav 命令均正常
- [x]  Tomcat 下载、解压、启停操作熟练，可查看后台进程
- [x]  MariaDB 完整安装、安全初始化，能密码登录数据库

# 实操收尾环境恢复命令（练习结束执行）

bash

```
# 移除8080永久放行规则，重载防火墙
sudo firewall-cmd --remove-port=8080/tcp --permanent
sudo firewall-cmd --reload
# MariaDB保留开机自启，日常学习频繁使用无需关闭
```