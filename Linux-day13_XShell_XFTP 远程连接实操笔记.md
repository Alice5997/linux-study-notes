# Linux_day13_XShell_XFTP 远程连接实操笔记

## 基础信息

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://www.bilibili.com/video/BV1dW411M7xL)
2、今日观看选集（严格匹配分集清单标题）

- 013_尚硅谷_Linux 实操篇远程登录 XShell5
- 014_尚硅谷_Linux 实操篇远程上传下载文件 XFTP5

3、系统环境：CentOS Stream9，普通用户 study 
4、全局统一规范（与 Day1~Day11 模板完全统一）

- 当日练习根目录：`~/day13_test01`
- Shell 脚本统一后缀：`.sh` 
5、今日练习测试目录、文件等：
- 测试文件：`day13_test01.txt`、`day13_upload.txt`
- 测试目录：`day13_transfer_dir`

💡补充实操命令 (默认在 `~/day13_test01` 目录执行，特殊路径单独标注)

```
# (家目录 ~ 执行)
mkdir -p ~/day13_test01
cd ~/day13_test01
touch day13_test01.txt
echo "day13 XShell XFTP远程练习" > day13_test01.txt
mkdir day13_transfer_dir
```

【此处放置截图：ls 查看 day13_test01 目录初始化结果】
![[Pasted image 20260912000007.png]]
---
![[Pasted image 20260912000057.png]]

## 模块 1：013 远程登录 XShell5

### 核心知识点

1. XShell：Windows 平台 SSH 远程终端工具，替代 VMware 黑框终端；通过 ssh 协议远程连接 Linux。
2. CentOS Stream9 默认自带`openssh‑server`，ssh 服务默认开机自启。
3. 连接三要素：**Linux 主机 IP 地址、用户名、密码**。
4. 协议：`ssh`默认端口`22`。

### 实操命令（CentOS 虚拟机终端执行）

```
# 查看本机ip地址，XShell连接要使用这个IP
ip a

# 查看ssh服务状态
systemctl status sshd

# 设置ssh开机自启
sudo systemctl enable --now sshd

# 防火墙放行ssh 22端口（CentOS默认已经放行，确认即可）
sudo firewall‑cmd --list‑ports
```

【此处放置截图：ip a 查询 IP、sshd 服务状态截图】
![[Pasted image 20260911234507.png]]
![[Pasted image 20260911234541.png]]

#### XShell 软件操作步骤（Windows 客户端）

1. 文件 → 新建会话
2. 主机：填入 CentOS 查询出来的 IP 地址，端口默认`22`
3. 用户：`study`，填入 study 用户密码
4. 点击连接，成功进入命令行终端。

【此处放置截图：XShell 新建会话配置界面、成功登录界面截图】
![[Pasted image 20260911235342.png]]
![[Pasted image 20260911235408.png]]
![[Pasted image 20260911235432.png]]


### 本模块避坑

> 1. 连不上优先检查：虚拟机网络模式为 NAT；sshd 服务运行；防火墙放行 22 端口；IP 地址填写正确。
> 2. 不要使用 127.0.0.1，这个是本机回环地址，Windows 访问虚拟机填写虚拟机真实 IP。
> 3. 密码输入的时候屏幕不显示字符，属于 ssh 正常行为，直接输入回车。

---

## 模块 2：014 XFTP5 远程上传下载文件

### 核心知识点

1. XFTP：配套工具，基于 sftp 协议，图形化拖拽实现 Windows ↔ Linux 文件互传。
2. 上传：Windows 本地文件传到 Linux 虚拟机。
3. 下载：Linux 虚拟机文件下载保存到 Windows 电脑。

### CentOS 端前置确认

```
# sftp依赖openssh‑server，sshd正常运行即可，不需要额外安装服务
systemctl status sshd
```

#### XFTP 软件操作步骤（Windows 客户端）

1. 新建会话，同样填入虚拟机 IP，用户名 study，密码，协议选`sftp`，端口 22。
2. 连接成功：左边 Windows 本地目录，**右边是 Linux 虚拟机家目录**。
3. 上传练习：Windows 新建`day13_upload.txt`，拖拽到 Linux `~/day13_test01`目录。
4. 下载练习：把 Linux 的`day13_test01.txt`拖拽下载到 Windows 桌面。

回到 CentOS 终端校验上传结果：

```
# 查看刚刚上传的文件是否存在
ls ~/day13_test01
cat ~/day13_test01/day13_upload.txt
```

【此处放置截图：XFTP 会话配置，拖拽上传后 ls 查看文件结果截图】
![[Pasted image 20260914215605.png]]
![[Pasted image 20260914215554.png]]

![[Pasted image 20260914215629.png]]
拖拽到windows桌面失败
![[Pasted image 20260914215753.png]]
名称改成了虚拟机IP，用户名下面的密码输入进去之后重新连接之后可以将Linux虚拟机上的文件拖到windows桌面上
![[Pasted image 20260915210010.png]]
![[Pasted image 20260915205943.png]]
### 本模块避坑

> 1. 权限问题：普通用户 study 只能读写自己家目录`/home/study`，**不能直接拖拽到 /root、/etc 系统目录**。
> 2. 如果要操作系统目录，先上传到家目录，再在 Linux 终端 sudo 移动到目标路径。
> 3. XShell、XFTP 会话配置信息保持一致：IP、用户名密码要相同。

---

## 模块 3：ssh 基础命令补充（不依赖 XShell，Windows 自带 ssh）

### 核心知识点

Windows10/11 自带 ssh 客户端，不装 XShell 软件也可以 cmd 直接远程登录 Linux。

### 实操（Windows cmd 终端）

```
# windows cmd中执行
ssh study@你的虚拟机IP
```

输入 study 用户密码即可登录 Linux。

【此处放置截图：Windows cmd 原生 ssh 登录演示截图】
![[Pasted image 20260914215509.png]]


### 补充：scp 命令传输文件（命令行上传下载，不用 XFTP 图形界面）

> Windows cmd / Linux 终端都可以执行 scp

```
# Linux→Windows下载示例（Windows cmd执行）
scp study@虚拟机IP:/home/study/day13_test01/day13_test01.txt C:\Users\你的用户名\Desktop

# Windows没有原生scp上传，优先用XFTP图形界面
```

---

## 📌day13 避坑汇总

1. 远程连接三要素：**IP 地址、用户名、密码，端口默认 22**。
2. 虚拟机网络必须 NAT 模式；桥接模式也可以，但 NAT 是学习环境推荐。
3. study 普通用户不能直接读写`/etc`、`/root`，文件先上传家目录，sudo 再移动。
4. ssh 输入密码无回显，不是卡死，正常输入回车。
5. XShell、XFTP 是 Windows 客户端软件，运行在 Windows，**不是 Linux 虚拟机内部执行**。

## 当日自检清单

- [x] `ip a`能够正确获取 CentOS 虚拟机 IP 地址
- [x] 确认`sshd`服务 active 运行，开机自启
- [x] XShell 新建会话成功 ssh 登录 study 用户
- [x] XFTP 使用 sftp 协议连接，成功上传文件到`~/day13_test01`
- [ ] XFTP 可以把 Linux 文件下载到 Windows 本地
- [x] 了解 Windows 自带 ssh 可以 cmd 直接远程登录

## 实操收尾

```
#练习文件全部保存在 ~/day13_test01
#可选：删除练习目录
# rm -rf ~/day13_test01
```