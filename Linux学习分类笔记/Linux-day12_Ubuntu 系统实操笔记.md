# Linux_day12_Ubuntu 系统实操笔记

基础信息
1、课程资源：BV1dW411M7xL 尚硅谷 Linux 全套 77 集 
2、今日观看选集（严格匹配分集清单标题）
- 073_尚硅谷_Python 定制篇_Ubuntu 安装和配置 
- 074_尚硅谷_Python 定制篇_Ubuntu 的 root 用户设置
- 075_尚硅谷_Python 定制篇_Ubuntu 下开发 Python 
- 076_尚硅谷_Python 定制篇_apt 软件包管理 
- 077_尚硅谷_Python 定制篇_ssh 远程登录 Ubuntu
3、系统环境：Ubuntu（虚拟机），普通用户 
4、全局统一规范（与 Day1~Day10 模板统一） 当日练习根目录：`~/day12_test01` Shell 脚本统一后缀：`.sh` 脚本需使用 `#!/bin/bash` 开头 💡补充实操命令 (默认在～/day12_test01 目录执行，特殊路径单独标注)

```
# (Ubuntu普通用户家目录 ~ 执行)
mkdir -p ~/day12_test01
cd ~/day12_test01
```

【此处放置截图：ls 查看 day12_test01 目录初始化结果】

---

## 模块 1：073_尚硅谷_Python 定制篇_Ubuntu 安装和配置

### 核心知识点

1. Ubuntu 属于 Debian 系 Linux，和 CentOS (RHEL 系) 是两大主流发行版；CentOS 用`dnf`包管理器，Ubuntu 使用`apt`。
2. 安装方式：VMware 虚拟机安装 Ubuntu 桌面版。
3. 基础配置：网卡 NAT 模式、设置主机名、更新系统软件源。
4. 源替换：默认国外源下载慢，替换国内镜像源（阿里云 / 清华源）提升下载速度。

### 💡补充实操命令 (默认在～/day12_test01 目录执行)

```
# 查看Ubuntu版本
lsb_release -a
# 查看主机名
hostname
# 修改主机名
sudo hostnamectl set-hostname ubuntu-study
# 更新软件源缓存
sudo apt update
# 升级所有已安装软件包
sudo apt upgrade -y
```

【此处放置截图：Ubuntu 版本查看、源更新执行结果】

> 避坑：修改源文件前务必备份原 sources.list；apt update 只更新索引，apt upgrade 才真正升级软件。

## 模块 2：074_尚硅谷_Python 定制篇_Ubuntu 的 root 用户设置

### 核心知识点

1. Ubuntu 默认安装**不启用 root 账号**，安装时创建的普通用户自带 sudo 权限。
2. sudo：临时借用 root 权限执行命令，输入**当前普通用户密码**，不是 root 密码。
3. 手动给 root 设置密码，开启 root 登录。

### 💡补充实操命令

```
# 设置root密码，执行后连续输入两次密码
sudo passwd root

# 切换root用户
su - root

# 切回普通用户
exit

# 验证sudo权限，查看系统日志（需要管理员权限）
sudo cat /var/log/auth.log
```

【此处放置截图：passwd 设置 root 密码，su 切换用户演示】

> 避坑：
> 
> 1. `sudo passwd root` 是设置 root 密码；不要混淆普通用户密码和 root 密码
> 2. 生产环境不建议长期直接使用 root 登录，优先使用 sudo

## 模块 3：075_尚硅谷_Python 定制篇_Ubuntu 下开发 Python

### 核心知识点

1. Ubuntu 新版自带 Python3，**不自带 python 命令（python 指向 python2，已淘汰），只能用 python3**
2. pip：Python 包管理工具，需要单独安装
3. 虚拟环境：隔离项目依赖包，不同项目版本互不干扰

### 💡补充实操命令

```
# 查看python版本
python3 -V

# 安装pip3
sudo apt install python3-pip -y

# 安装python虚拟环境工具
sudo apt install python3-venv -y

# 创建python虚拟环境
python3 -m venv py_venv_demo

# 激活虚拟环境
source py_venv_demo/bin/activate

# 退出虚拟环境
deactivate
```

【此处放置截图：python 版本查看、虚拟环境激活 / 退出演示截图】

> 避坑：
> 
> 1. Ubuntu 中直接敲 python 会提示 command not found，要用 python3
> 2. 虚拟环境激活后，命令行前缀会带环境名；所有 pip 安装包仅在当前虚拟环境生效

## 模块 4：076_尚硅谷_Python 定制篇_apt 软件包管理

### 核心知识点

1. apt：Ubuntu/Debian 系列官方包管理器，对应 CentOS 的 dnf
2. 常用子命令：
    - `apt update`：更新软件包索引清单
    - `apt install`：安装软件
    - `apt remove`：卸载软件（保留配置文件）
    - `apt purge`：彻底卸载，连同配置文件一起删除
    - `apt list --installed`：查看已经安装的软件
    - `apt search`：搜索软件包

### 💡补充实操命令

```
# 更新软件索引
sudo apt update

# 搜索tree软件包
apt search tree

# 安装tree
sudo apt install tree -y

# 执行tree查看目录结构
tree ~/day12_test01

# 卸载tree，保留配置
sudo apt remove tree -y

# 彻底卸载（含配置文件）
# sudo apt purge tree -y

# 列出本机所有已经安装的软件
apt list --installed
```

【此处放置截图：apt 搜索、安装 tree 命令执行结果】

> 避坑：
> 
> 1. apt 操作安装 / 卸载**必须加 sudo**，普通用户无权限
> 2. apt update ≠ apt upgrade；update 只是更新包清单，不会升级软件

## 模块 5：077_尚硅谷_Python 定制篇_ssh 远程登录 Ubuntu

### 核心知识点

1. Ubuntu 默认**没有预装 openssh-server**，CentOS 默认自带 ssh 服务，这是最大区别
2. openssh-server：服务端，让别的电脑可以 ssh 远程连接 Ubuntu
3. 客户端 ssh：默认自带，用来连接别的 Linux 主机

### 💡补充实操命令

```
# 安装ssh服务端
sudo apt install openssh-server -y

# 查看ssh服务状态
systemctl status ssh

# 开机自启ssh
sudo systemctl enable ssh

# 查看本机ip，远程连接需要这个IP
ip a
```

> 远程连接语法（Xshell / Windows cmd）

```
ssh 普通用户名@Ubuntu的IP地址
#示例：ssh study@192.168.1.105
```

【此处放置截图：ssh 服务安装、status 状态查看截图】

> 避坑：
> 
> 1. 装完 openssh-server 服务才会启动；只装客户端无法被远程连接
> 2. 防火墙如果开启，需要放行 22 端口
> 3. 可以使用 Xshell 连接 Ubuntu，和 CentOS 远程登录操作逻辑一致

## 模块 6 综合小脚本：Ubuntu 系统信息脚本

💡补充实操命令 (默认在～/day12_test01 目录执行)

```
vim ubuntu_info.sh
chmod u+x ubuntu_info.sh
./ubuntu_info.sh
```

【此处放置截图：脚本执行结果】 脚本 ubuntu_info.sh

```
#!/bin/bash
# Ubuntu系统信息查看脚本
echo "=====Ubuntu系统版本===="
lsb_release -a
echo "=====主机名===="
hostname
echo "=====本机IP地址===="
ip a | grep inet
echo "=====Python3版本===="
python3 -V
```

## 📌day12 避坑汇总（直接放入笔记末尾）

1. Ubuntu 是 Debian 系，包管理器 apt；CentOS 是 RHEL 系，包管理器 dnf，**命令不互通**
2. Ubuntu 默认无 root 登录，需要`sudo passwd root`手动设置 root 密码；日常优先 sudo
3. Ubuntu 只预装 python3，直接敲 python 命令找不到程序
4. Ubuntu 默认不自带 ssh 服务端，需要手动安装 openssh-server，否则外部无法远程登录
5. apt update 只更新软件清单；apt upgrade 执行软件版本升级，两个命令经常搭配使用

## 当日自检清单

- [ ] 掌握 Ubuntu 虚拟机基础配置，会替换软件源
- [ ] 学会设置 root 密码，理解 sudo 临时管理员权限
- [ ] 掌握 python3+venv 虚拟环境创建、激活、退出
- [ ] 熟练 apt 常用命令：search/install/remove/update
- [ ] 安装 openssh-server，使用 Xshell 远程 ssh 登录 Ubuntu

## 实操收尾

```
#练习文件全部保存在 ~/day12_test01
#可选：删除练习目录
# rm -rf ~/day12_test01
```

