## 基础信息：

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh "autolink")

2、今日观看选集：045、046、047

- 045：尚硅谷_Linux 实操篇_网络配置原理和说明
- 046：尚硅谷_Linux 实操篇_自动获取 IP
- 047：尚硅谷_Linux 实操篇_修改配置文件指定 IP
    
3、系统环境：CentOS Stream9，普通用户 study
    
4、今日练习测试目录、文件等：
    
    当日总目录：**~/day06_test01**
    
    测试网络日志：day06_net_log.txt
    
    网卡配置备份：ifcfg-ens33.bak/ifcfg-ens33_static.bak
    
5、使用规则：所有命令手动输入，禁止复制；每步执行完成后，在笔记对应标记处插入终端截图。

> 💡补充实操命令（默认在 `~/day06_test01` 目录执行，特殊路径单独标注）

## 一、初始化练习目录（最先执行）

bash

```
# （家目录 ~ 执行）
mkdir -p ~/day06_test01
cd ~/day06_test01
touch day06_net_log.txt
echo "Linux网卡IP、主机、DNS实操记录" > day06_net_log.txt
```

【此处放置截图：ls 查看目录初始化结果】
![[98aa58e95043c745aa5ad8a97303ffab.png]]

## 模块 1 网络配置原理和说明（对应 045 集）

### 核心知识点

1. ==CentOS Stream9 默认网卡名称 ens33，旧系统 eth0 淘汰==
2. ==网卡配置文件路径：`/etc/sysconfig/network-scripts/ifcfg-ens33`==
3. ==两种网络模式==：==DHCP 自动 IP==、==static 静态固定 IP==
	- DHCP 自动获取 IP：开机自动向网关分配地址，适合虚拟机
	- 静态固定 IP：手动指定 IP / 子网掩码 / 网关 / DNS，服务器生产环境使用
4. 基础网络概念：IP、子网掩码、网关、DNS 域名解析服务器


![[c44d8e5459eda1bfec384bb4ad4321c6.png]]
![[Pasted image 20260806175215.png]]

### 实操命令

bash

```
# （任意目录执行）查看网卡硬件信息
ip addr
# （任意目录执行）传统网卡查看命令
ifconfig
# （任意目录执行）查看网卡配置文件夹
ls /etc/sysconfig/network-scripts/
# （任意目录执行）查看当前主机名
hostname
# （任意目录执行）查看DNS配置文件
cat /etc/resolv.conf
```

#### 如果想使用旧命令 `ifconfig`，需要手动安装 net‑tools 工具包

bash

```
# 任意目录执行，安装工具
sudo dnf install net-tools -y
# 安装完成之后就可以执行
ifconfig
```

【此处放置截图：ip addr、网卡目录文件输出】
![[Pasted image 20260806173857.png]]
## 模块 2 自动获取 IP (DHCP)（对应 046 集）

### 核心知识点

1. DHCP：网卡由 VMware NAT 自动分配 IP 地址；CentOS Stream9 使用`nmcli`命令配置，不再编辑`/etc/sysconfig/network‑scripts`配置文件
2. 修改网卡配置后，需要重启网卡配置才会生效
3. `ping`、`nslookup`用于内网、公网连通性测试
4. 本机网卡设备名称：**ens160**

### 实操命令

bash

```
# 执行目录：~/day06_test01
# 备份当前DHCP网卡配置输出到备份文件
nmcli connection show ens160 > ifcfg‑ens160_dhcp.bak

# 设置网卡为DHCP自动获取模式
sudo nmcli connection modify ens160 ipv4.method auto

# （任意目录执行）重启网卡生效
sudo nmcli connection down ens160
sudo nmcli connection up ens160

# （任意目录执行）校验IP地址
ip addr

# （任意目录执行）测试外网连通
ping www.baidu.com

# 执行目录：~/day06_test01，ping日志写入本地文件
ping www.baidu.com >> day06_net_log.txt

# -c 4 代表只ping4次，执行完自动退出，写入日志文件 
ping -c 4 www.baidu.com >> day06_net_log.txt

```



【此处放置截图：ip addr 输出、ping 连通测试结果】
![[Pasted image 20260806183537.png]]
![[Pasted image 20260806183557.png]]
![[Pasted image 20260806183614.png]]

## 模块 3 修改配置文件指定静态 IP（对应 047 集）

### 核心知识点

1. 静态 IP 模式：使用`nmcli`设置`ipv4.method manual`；必须填写 IP 地址、子网掩码、网关、DNS
2. IP 网段需要和 VMware NAT 网段保持一致，本机网段：`192.168.133.0/24`，网关：`192.168.133.2`，否则无法访问外网
3. 修改网卡后必须重启网卡；参数错误会直接断网
4. 本机网卡设备名称：**ens160**

### 实操命令

bash

```
# 执行目录：~/day06_test01
# 备份网卡配置
nmcli connection show ens160 > ifcfg‑ens160_static.bak

# 设置静态IP（适配本机NAT网段）
sudo nmcli connection modify ens160 \
ipv4.method manual \
ipv4.addresses 192.168.133.100/24 \
ipv4.gateway 192.168.133.2 \
ipv4.dns "8.8.8.8,114.114.114.114"

# （任意目录执行）重启网卡生效
sudo nmcli connection down ens160
sudo nmcli connection up ens160

# （任意目录执行）查看分配的静态IP
ip addr

# （任意目录执行）测试外网
ping www.baidu.com

# （任意目录执行）DNS域名解析测试
nslookup baidu.com
```

> ⚠练习完成必做：恢复 DHCP 自动获取 IP（任意目录执行）

bash

```
sudo nmcli connection modify ens160 ipv4.method auto
sudo nmcli connection down ens160
sudo nmcli connection up ens160
ip addr
ping www.baidu.com
```

【此处放置截图：静态 IP 执行后 ip addr 结果、nslookup 域名解析结果、恢复 DHCP 后的 ip addr 截图】
![[Pasted image 20260806184703.png]]

恢复DHCP：
![[Pasted image 20260806185329.png]]
## 拓展补充：主机名修改

### 核心知识点

1. hostname 临时修改重启失效，hostnamectl 永久修改写入配置文件
2. 多服务器环境依靠主机区分机器，方便运维识别

### 实操命令

bash

```
# （任意目录执行）临时修改主机名
sudo hostname linux-study01
# （任意目录执行）永久修改主机名
sudo hostnamectl set-hostname linux-study01
# （任意目录执行）校验主机名
hostname
cat /etc/hostname
```

【此处放置截图：hostname 修改前后对比】

## 补充：当日踩坑记录区域


1. 修改网卡前务必备份配置，写错参数会直接断网无法操作
2. 静态IP网段与VM NAT不匹配，能ping网关但无法访问外网
3. DNS缺失会出现能ping IP地址、不能访问域名的问题
4. 修改配置后不执行nmcli重载，参数不会即时生效
5. ping不通优先检查虚拟机网卡、防火墙拦截
6. ipconfig：Windows 命令，Linux 不能使用
7. ifconfig 属于旧工具，系统默认不带，需要安装 net‑tools 软件包；推荐优先使用系统内置 ip addr。


```
> 🚨CentOS Stream9 和课程CentOS7版本差异
> 1. 课程中的路径 `/etc/sysconfig/network‑scripts/ifcfg‑ens33` 在CentOS Stream9不存在，**禁止使用**。
> 2. 本机真实网卡名称：ens160，不是视频里的ens33，所有网络命令网卡名填写ens160。
> 3. CentOS Stream9 使用nmcli命令管理网络，不用手动编辑网卡配置文件。
> 4. 备份网卡配置语法：`nmcli connection show ens160 > 备份文件名.bak`
> 5. 当前VMware NAT网段：192.168.133.0/24，静态IP必须在该网段内，网关：192.168.133.2
> 6. 实操结束**必须执行命令恢复DHCP模式**，避免虚拟机重启之后断网。
```

## ✅当日自检清单

- [x]  使用 ip addr 查看本机网卡、IP 信息
- [ ]  读懂网卡配置文件所有核心参数含义
- [x]  修改网卡前备份配置，出错可快速恢复
- [x]  完整配置 DHCP 自动 IP 并验证网络连通
- [x]  手动编写静态 IP 全套网卡配置，重启网卡生效
- [x]  使用 ping、nslookup 测试内网、公网、DNS 解析
- [ ]  永久修改服务器主机名