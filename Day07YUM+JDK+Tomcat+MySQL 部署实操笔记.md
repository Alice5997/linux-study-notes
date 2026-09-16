# Linux_day07_YUM+JDK+Tomcat+MySQL 部署实操笔记

## 基础信息

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh "autolink")

2、今日严格对应观看选集（按顺序观看，标题完全匹配截图）

053_尚硅谷_Linux 实操篇_YUM

054_尚硅谷_JavaEE 定制篇_JDK 安装和配置

055_尚硅谷_JavaEE 定制篇_Tomcat 安装和配置

057_尚硅谷_JavaEE 定制篇_MySQL 安装和配置

⚠️避坑标注：056 是 Eclipse 图形 IDE，服务器环境不实操，直接跳过；058‑060 Shell 脚本，放到 Day8 学习

3、系统环境：CentOS Stream9，登录普通用户 study

4、全局统一命名规范（和 day01/day02/day03/day04/day05/day06 保持一致）

- 当日总目录：`day07_test01`
- 所有练习产生文件、备份文件统一存放到此目录
- 切换 root：`sudo -i`；普通用户提权加`sudo`
    
    5、今日练习测试目录、文件等：
- 工作主目录：`~/day07_test01`
- YUM 操作备份日志：`yum_operate.log`
- JDK 解压目录：`~/day07_test01/jdk1.8.0`
- Tomcat 解压目录：`~/day07_test01/apache‑tomcat‑9.0`
- MySQL 数据库配置备份：`~/day07_test01/mysql_backup.sql`

---

## 前置准备模块（模块执行目录：普通用户家目录～）

**核心知识点**

1. 创建当日练习总文件夹，所有练习文件统一收纳
2. 校验系统网络连通，YUM 软件源需要外网
    
    **实操命令**

bash

```
# ~目录执行，创建当日总目录
mkdir -p ~/day07_test01
# 进入当日目录
cd ~/day07_test01
# 测试外网连通
ping www.baidu.com
```

## 二、学习模块 1 YUM 软件包管理（对应 053 集 Linux 实操篇_YUM）

> 模块执行目录：`~/day07_test01`
> 
> **核心知识点**

1. YUM 是 RPM 包管理器，自动处理软件依赖关系
2. `yum list` 查询软件；`yum install`安装；`yum remove`卸载
3. CentOS Stream9 使用`dnf`作为 yum 别名，两个命令等效
4. 软件源决定下载速度，国内推荐阿里云镜像源
    
    **实操命令**

bash

```
# ~/day07_test01目录执行
# 1 查询系统全部可安装软件
sudo dnf list | grep tree

# 2 安装tree工具
sudo dnf install tree -y

# 3 验证tree是否安装成功
tree --version

# 4 将yum操作记录输出到日志文件
echo "===yum安装tree成功===" >> yum_operate.log

# 5 查询已安装软件
sudo dnf list installed | grep tree

# 6 卸载tree软件
sudo dnf remove tree -y

# 7 清除缓存
sudo dnf clean all
```

**避坑标注**

- CentOS Stream9 不要使用旧版本`yum`，底层实际调用`dnf`，两个命令都可以执行；
- 安装软件必须加`sudo`提权，普通用户无权限；
- 网络不通会导致 yum 报错，先确认`ping www.baidu.com`可以通外网。
    
    **模块自检清单**
- [ ]  可以成功搜索软件包
- [ ]  可以正常安装、卸载工具软件
- [ ]  操作日志已经写入`yum_operate.log`

## 学习模块 2 JDK 安装和环境变量配置（对应 054 集 JavaEE 定制篇_JDK 安装和配置）

> 模块执行目录：`~/day07_test01`
> 
> **核心知识点**

1. Linux 部署 Java 程序必须安装 JDK，提供 java 运行环境
2. 两种安装方式：dnf 在线安装、压缩包手动解压安装
3. 环境变量`JAVA_HOME`、`PATH`配置在`/etc/profile`全局生效
4. 修改 profile 文件后，必须`source /etc/profile`让配置立即生效
    
    **实操命令**

bash

```
# ~/day07_test01目录执行
# 方式1 dnf在线安装openjdk1.8（CentOS Stream9推荐）
sudo dnf install java‑1.8.0‑openjdk‑devel -y

# 查看java版本，校验安装
java -version
javac -version

# 查找jdk真实安装路径
readlink -f /usr/bin/java

# 备份全局环境变量配置文件到当日目录
sudo cp /etc/profile ./profile.bak

# 编辑全局环境变量配置
sudo vim /etc/profile
# 文件末尾追加如下内容
# export JAVA_HOME=/usr/lib/jvm/java‑1.8.0‑openjdk
# export PATH=$PATH:$JAVA_HOME/bin

# 让配置立刻生效（任意目录执行）
source /etc/profile

# 校验环境变量
echo $JAVA_HOME
```

**避坑标注**

1. 修改`/etc/profile`写错会导致系统命令异常，**操作前务必备份 profile 文件**；
2. source 命令必须执行，否则新开终端才会读取新环境变量；
3. 注意 JDK 路径和自己机器实际路径保持一致。
    
    **模块自检清单**

- [ ]  java -version 可以正常输出版本号
- [ ]  echo $JAVA_HOME 可以打印出 jdk 路径

## 学习模块 3 Tomcat 安装和配置（对应 055 集 JavaEE 定制篇_Tomcat 安装和配置）

> 模块执行目录：`~/day07_test01`
> 
> **核心知识点**

1. Tomcat 是 Javaweb 项目服务器，依赖 JDK 环境
2. 解压二进制压缩包即可使用，不需要编译安装
3. 核心脚本：`startup.sh`启动、`shutdown.sh`关闭 tomcat
4. 默认端口 8080，防火墙需要放行 8080 端口才能浏览器访问
    
    **实操命令**

bash

```
# ~/day07_test01目录执行
# 下载tomcat9压缩包
wget https://archive.apache.org/dist/tomcat/tomcat‑9/v9.0.96/bin/apache‑tomcat‑9.0.96‑bin.tar.gz

# 解压
tar -zxvf apache‑tomcat‑9.0.96‑bin.tar.gz

# 进入tomcat bin目录
cd apache‑tomcat‑9.0.96/bin

# 给脚本增加执行权限
chmod +x *.sh

# 启动tomcat
./startup.sh

# 查看tomcat进程
ps -ef | grep tomcat

# 关闭tomcat
./shutdown.sh
```

**避坑标注**

1. Tomcat 启动前提：JDK 环境变量配置成功；
2. 虚拟机外部浏览器访问，需要 firewalld 放行 8080 端口；
3. 启动失败查看 logs/catalina.out 日志排查错误。
    
    **模块自检清单**

- [ ]  执行 startup.sh 可以正常启动 tomcat 进程
- [ ]  ps 可以查看到 tomcat 相关进程

## 学习模块 4 MySQL (MariaDB) 安装和配置（对应 057 集 JavaEE 定制篇_MySQL 安装和配置）

> 模块执行目录：`~/day07_test01`
> 
> **核心知识点**

1. CentOS Stream9 默认源没有 MySQL，使用 MariaDB 作为兼容替代
2. 安装完成后设置开机自启，修改 root 账号密码
3. 数据库配置文件：`/etc/my.cnf`
    
    **实操命令**

bash

```
# ~/day07_test01目录执行
# dnf安装mariadb服务端+客户端
sudo dnf install mariadb‑server mariadb -y

# 设置开机自启，同时启动服务
sudo systemctl enable --now mariadb

# 查看mariadb运行状态
sudo systemctl status mariadb

# 数据库安全初始化（设置root密码、删除匿名用户）
sudo mysql_secure_installation

# 登录数据库
mysql -uroot -p
```

**避坑标注**

1. 执行`mysql_secure_installation`按提示一步步设置 root 密码；
2. 防火墙放行 3306 端口，外部工具才可以连接数据库；
3. 忘记密码需要停止服务，跳过授权表重置密码。
    
    **模块自检清单**

- [ ]  systemctl status mariadb 显示 active (running)
- [ ]  可以使用密码正常登录数据库

## 当日整体自检清单

- [ ]  day07_test01 目录全部练习文件完整
- [ ]  YUM 可以完成软件安装卸载
- [ ]  JDK 环境变量配置成功，java 命令正常
- [ ]  Tomcat 可以正常启动关闭
- [ ]  MariaDB 数据库服务正常运行