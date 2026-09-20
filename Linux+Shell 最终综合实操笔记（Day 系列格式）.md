# Linux+Shell 最终综合实操笔记（8.4–8.14 红框整合 · Day 系列格式）

## 基础信息

1、课程地址：
- Linux 全套（BV1dW411M7xL）：[https://www.bilibili.com/video/BV1dW411M7xL](https://www.bilibili.com/video/BV1dW411M7xL)
- Shell 专项（BV1hW41167NW）：[https://www.bilibili.com/video/BV1hW41167NW](https://www.bilibili.com/video/BV1hW41167NW)

2、本次最终练习整合观看选集（严格对照分集清单标题）

Linux 部分（BV1dW411M7xL）：
- 013：尚硅谷_Linux 实操篇_远程登录 XShell5
- 014：尚硅谷_Linux 实操篇_远程上传下载文件 XFTP5
- 022：尚硅谷_Linux 实操篇_实用指令 运行级别和找回 root 密码
- 039：尚硅谷_Linux 实操篇_任务调度基本说明
- 040：尚硅谷_Linux 实操篇_任务调度应用实例
- 041：尚硅谷_Linux 实操篇_磁盘分区介绍
- 042：尚硅谷_Linux 实操篇_Linux 分区
- 043：尚硅谷_Linux 实操篇_给 Linux 添加一块新硬盘
- 044：尚硅谷_Linux 实操篇_磁盘查询实用指令
- 048：尚硅谷_Linux 实操篇_进程管理 进程介绍和静态查看
- 049：尚硅谷_Linux 实操篇_进程管理 终止进程
- 050：尚硅谷_Linux 实操篇_进程管理 服务管理
- 051：尚硅谷_Linux 实操篇_进程管理 监控服务

Shell 专项（BV1hW41167NW）：
- 01_尚硅谷_Shell_课程介绍 ～ 26_尚硅谷_Shell_企业真题讲解（完整 26 集）

3、系统环境：CentOS Stream9，普通用户 study，主机名 linux-study01，网卡 ens160（NAT：192.168.133.0/24，网关 192.168.133.2，静态 IP 192.168.133.100）

4、全局统一规范（与 Day1~Day14 模板完全统一）
- 虚拟机 CentOS 练习根目录：`~/shell_test`（只放脚本和日志练习数据）
- 虚拟机脚本目录：`~/shell_test/scripts/`
- 虚拟机日志练习数据目录：`~/shell_test/logs/`
- **产出 .md 文档存放位置：Windows 本地 Obsidian 知识库 `01_Linux学习` 目录**（不放虚拟机，与 day01~day14 笔记归档在一起）
  `F:\Knowledge\运维AI学习知识库\运维AI学习知识库\01_Linux学习\`
- shell 脚本统一后缀：`.sh`
- 脚本开头必须声明 `#!/bin/bash`

5、使用规则：所有命令手动输入，禁止复制；每步执行完成后，在笔记对应标记处插入终端截图

💡补充实操命令 (默认在 `~/shell_test` 目录执行，特殊路径单独标注)

```
# (家目录 ~ 执行)
mkdir -p ~/shell_test/logs ~/shell_test/scripts
cd ~/shell_test
```

【此处放置截图：ls 查看 shell_test 目录初始化结果】
![[Pasted image 20260918153711.png]]

---

## 模块 1 进程管理 ps/top/kill、端口查看 netstat/ss（对应 048/049/051 集）

### 核心知识点

1. 程序：硬盘上静态二进制文件；进程：程序运行后产生动态实例，系统资源调度最小单位
2. 前台进程占用终端窗口；后台进程命令末尾加 `&`，不阻塞终端
3. `ps aux` 静态快照查看全部进程；`ps -ef` 查看含 PPID 的完整进程链
4. `top` 动态实时监控，交互键：`q` 退出、`M` 按内存排序、`P` 按 CPU 排序
5. `kill` 默认发 15 号 SIGTERM 优雅关闭；`kill -9` 发 SIGKILL 强制杀死；`killall` 按名称批量终止
6. 端口查看：`netstat -tunlp`（需装 net-tools）、`ss -tunlp`（内置，更轻量）

### 实操命令

#### 1. 静态查看进程（ps）

```
# 查看当前终端进程（任意目录执行）
ps
# 查看系统所有进程快照（任意目录执行）
ps aux
# 查看含父进程的完整进程链（任意目录执行）
ps -ef
# 按用户名过滤进程（任意目录执行）
ps aux | grep study
# 配合管道精确查找某进程（任意目录执行）
ps aux | grep sshd
```

【此处放置截图：ps aux 与 ps -ef 输出对比】
![[Pasted image 20260918182003.png]]
![[Pasted image 20260918182320.png]]

![[Pasted image 20260918182511.png]]
![[Pasted image 20260918182532.png]]
#### 2. 实时监控进程（top）

```
# 实时资源监控界面，q退出（任意目录执行）
top
# top界面内：c显示完整命令行、M按内存排序、P按CPU排序
```

【此处放置截图：top 实时监控界面】
![[Pasted image 20260918182635.png]]

#### 3. 终止进程（kill / killall）

```
# 创建后台休眠测试进程（任意目录执行）
sleep 300 &
# 过滤sleep进程，获取PID编号（任意目录执行）
ps aux | grep sleep
# 优雅终止（默认发SIGTERM，15），替换为查到的PID（任意目录执行）
kill 进程PID
# 重新创建后台进程用于强制杀死测试（任意目录执行）
sleep 300 &
# 强制杀死（SIGKILL，9），用于无响应的进程（任意目录执行）
kill -9 进程PID
# 按进程名批量终止所有匹配进程（任意目录执行）
killall sleep
```

【此处放置截图：kill、kill -9、killall 执行效果】
![[Pasted image 20260918183508.png]]

#### 4. 端口查看（netstat / ss）

```
# 安装netstat工具（任意目录执行）
sudo dnf install -y net-tools
# 查看所有监听端口及对应进程（任意目录执行）
netstat -tunlp
# 查看指定端口（任意目录执行）
netstat -tunlp | grep 22
# ss为内置命令，功能更轻量（任意目录执行）
ss -tunlp
# 查看某端口被哪个进程占用（任意目录执行）
ss -tunlp | grep 8080
```

【此处放置截图：netstat -tunlp 与 ss -tunlp 端口列表】
![[Pasted image 20260918185209.png]]

### 故障模拟：端口被占用（独立排查）

场景：服务 A 占用 8080 端口后，服务 B 绑定同端口报 `Address already in use`。

```
# (~/shell_test 目录执行)
# 1.用 python 简易 HTTP 服务模拟服务A占用8080端口
python3 -m http.server 8080 &
# 2.再启动第二个，模拟服务B绑定同端口 → 预期报错
python3 -m http.server 8080
# 3.确认服务A的PID
ss -tunlp | grep 8080
# 4.终止占用进程（-9强制）
kill -9 <上一步查到的PID>
# 5.验证端口已释放，可重新绑定
ss -tunlp | grep 8080
python3 -m http.server 8080 &
```

【此处放置截图：报错 Address already in use 现象】
![[Pasted image 20260918185848.png]]

【此处放置截图：ss 查 PID → kill → 端口释放全过程】
![[Pasted image 20260918190028.png]]
### 本模块避坑

> 1. 普通用户监听 1024 以下端口会报 `Permission denied`，练习用 8080 等高位端口。
> 2. `ss -tunlp` 的 `-p` 显示进程，普通用户可能看不到他人进程，必要时加 `sudo`。
> 3. kill 后务必用 `ss -tunlp | grep 8080` 二次确认端口真正释放。
> 4. `kill -9` 尽量不用，数据库、Web 服务强制杀死会丢失业务数据。
> 5. `top` 界面必须输入 `q` 退出，不能直接关闭终端残留进程。

### 本模块最终产出：端口冲突故障解决流程

在 Windows 本地 Obsidian 知识库 `01_Linux学习` 目录新建 `01_端口冲突故障解决流程.md`，框架如下：

```
# 端口冲突故障解决流程

## 一、故障现象
（启动服务提示 Address already in use，端口 8080 无法绑定）

## 二、排查过程
1. ss -tunlp | grep 8080 → 发现 PID xxx 占用
2. ps -p xxx 确认占用进程是什么服务
3. 判断：该进程是否可终止

## 三、解决方案
1. kill -9 <PID> 终止占用进程
2. ss -tunlp | grep 8080 确认端口释放
3. 重新启动目标服务，验证成功

## 四、避坑点
1. 1024 以下端口需要 root 权限
2. 终止进程前先确认是否系统关键服务
3. 释放后必须二次验证
```

【此处放置截图：01_端口冲突故障解决流程.md 最终内容】
![[Pasted image 20260918190458.png]]

---

## 模块 2 磁盘管理 df/du、日志查看 grep（对应 041/042/043/044 集）

### 核心知识点

1. `df -h` 查看文件系统整体使用率；`df -i` 查看 inode 使用（小文件过多会耗尽 inode）
2. `du -sh * | sort -rh` 定位大目录/大文件，从大到小排序
3. `lsblk` 查看磁盘、分区、挂载点整体结构；`blkid` 查看 UUID
4. 磁盘使用完整流程：分区（fdisk）→ 格式化（mkfs.xfs）→ 挂载（mount）→ 永久挂载（/etc/fstab）
5. `grep -i` 忽略大小写；`grep -c` 统计条数；grep 结合管道二次过滤

### 实操命令

#### 1. 磁盘使用情况（df）

```
# 查看文件系统整体使用情况（任意目录执行）
df -h
# 只看根分区（任意目录执行）
df -h /
# 查看inode使用情况（小文件过多会耗尽inode，任意目录执行）
df -i
```

【此处放置截图：df -h、df -i 输出】
![[Pasted image 20260918233634.png]]

#### 2. 目录占用空间（du）

```
# 查看当前目录总占用（在 ~/shell_test 目录执行）
du -sh .
# 查看一级子目录占用并从大到小排序（在 ~/shell_test 目录执行）
du -sh * | sort -rh
# 只看指定目录（任意目录执行）
du -sh ~/shell_test/logs
```

【此处放置截图：du -sh * | sort -rh 输出】
![[Pasted image 20260918234015.png]]

#### 3. 设备挂载查看（lsblk）

```
# 查看块设备树（磁盘、分区、挂载点）（任意目录执行）
lsblk
# 查看挂载详情（含UUID）（任意目录执行）
sudo blkid
```

【此处放置截图：lsblk 输出】
![[Pasted image 20260918234236.png]]


#### 4. 日志过滤（grep）

```
# 生成练习日志（200行，含ERROR/INFO，在 ~/shell_test 目录执行）
mkdir -p ~/shell_test/logs
for i in $(seq 1 200); do
  if [ $((i % 10)) -eq 0 ]; then
    echo "$(date '+%F %T') ERROR 业务系统连接数据库超时" >> ~/shell_test/logs/app.log
  else
    echo "$(date '+%F %T') INFO  请求处理成功" >> ~/shell_test/logs/app.log
  fi
done
# 过滤ERROR行（任意目录执行）
grep "ERROR" ~/shell_test/logs/app.log
# 忽略大小写+显示行号（任意目录执行）
grep -in "error" ~/shell_test/logs/app.log
# 统计错误条数（任意目录执行）
grep -c "ERROR" ~/shell_test/logs/app.log
# 过滤指定时间段的日志（任意目录执行）
grep "$(date '+%F')" ~/shell_test/logs/app.log | grep "ERROR"
```

【此处放置截图：grep 过滤 ERROR 日志输出】
![[Pasted image 20260918235757.png]]

### 故障模拟：磁盘爆满（独立处理）

场景：大文件堆积导致分区使用率接近 100%，服务写日志报 `No space left on device`。

```
# (~/shell_test 目录执行)
# 1.查看当前使用率（记录基线）
df -h /
# 2.制造一个500M大文件模拟日志堆积（用完立即清理）
dd if=/dev/zero of=~/shell_test/logs/big.log bs=1M count=500
# 3.再次查看，确认使用率上升
df -h /
# 4.定位大文件（按占用排序）
du -sh ~/shell_test/logs/* | sort -rh
# 5.确认无保留价值后删除
rm -f ~/shell_test/logs/big.log
# 6.验证使用率回落
df -h /
```

【此处放置截图：磁盘使用率升高现象】
![[Pasted image 20260919000341.png]]
【此处放置截图：du 定位大文件 → rm 删除 → df 回落】
![[Pasted image 20260919000434.png]]
### 本模块避坑

> 1. 磁盘爆满优先用 `du -sh * | sort -rh` 逐层定位，不要盲目 `rm`。
> 2. `df -h` 看空间，`df -i` 看 inode——小文件过多时 `df -h` 显示正常但报"磁盘满"，别漏查 inode。
> 3. 日志文件被进程占用时删除后空间不释放，需要 `> 文件` 清空或重启进程。
> 4. 严禁对系统盘 /dev/sda 执行分区修改操作，仅可操作新增硬盘。

### 本模块最终产出：磁盘、日志排查实操文档

在 Windows 本地 Obsidian 知识库 `01_Linux学习` 目录新建 `02_磁盘日志排查实操.md`，记录磁盘查看命令、日志过滤命令、磁盘爆满故障演练全过程（含截图）。

---

## 模块 3 SSH 远程连接、scp 文件传输（对应 013/014 集）

### 核心知识点

1. ssh：远程登录协议，默认端口 22；CentOS Stream9 自带 openssh-server，默认开机自启
2. 连接三要素：**Linux 主机 IP 地址、用户名、密码**
3. scp：命令行远程文件传输，基于 ssh 协议；`-r` 递归传目录
4. 首次连接需输入 `yes` 确认主机指纹

### 实操命令

#### 1. SSH 远程连接

```
# 查看本机IP地址（远程连接要使用这个IP，任意目录执行）
ip a
# 查看ssh服务状态（任意目录执行）
systemctl status sshd
# 设置ssh开机自启（任意目录执行）
sudo systemctl enable --now sshd
# 从本机远程登录另一台主机（示例：登录192.168.133.100，任意目录执行）
ssh study@192.168.133.100
# 指定端口连接（SSH默认22，若改过端口，任意目录执行）
ssh -p 2222 study@192.168.133.100
# 退出远程会话
exit
```

【此处放置截图：ssh 登录成功与 exit 退出】
![[Pasted image 20260919001957.png]]
![[Pasted image 20260919001823.png]]

#### 2. scp 文件传输

```
# 本地文件 → 远程主机（上传，任意目录执行）
scp ~/shell_test/logs/app.log study@192.168.133.100:/home/study/shell_test/logs/
# 远程主机文件 → 本地（下载，任意目录执行）
scp study@192.168.133.100:/home/study/shell_test/logs/app.log ./
# 递归传输整个目录（任意目录执行）
scp -r ~/shell_test/logs study@192.168.133.100:/home/study/shell_test/
```

【此处放置截图：scp 上传/下载成功输出】

### 本模块避坑

> 1. 连不上优先检查：虚拟机网络模式为 NAT；sshd 服务运行；防火墙放行 22 端口；IP 地址填写正确。
> 2. 不要使用 127.0.0.1，这个是本机回环地址，Windows 访问虚拟机填写虚拟机真实 IP。
> 3. ssh 输入密码无回显，不是卡死，正常输入回车。
> 4. study 普通用户只能读写自己家目录，不能直接传 /root、/etc 系统目录。

### 本模块最终产出：本周全部 Linux 命令汇总文档

在 Windows 本地 Obsidian 知识库 `01_Linux学习` 目录新建 `03_本周Linux命令汇总.md`，按类别汇总：

```
# 本周 Linux 命令汇总手册

## 一、文件与目录类
- pwd / ls / cd / mkdir / rmdir / touch / cp / rm / mv
- cat / more / less / head / tail / echo

## 二、用户与权限类
- useradd / passwd / usermod / userdel / su
- chmod / chown / chgrp / groupadd

## 三、磁盘与进程类
- df / du / lsblk / ps / top / kill / killall
- netstat / ss

## 四、网络与远程类
- ping / ip addr / ssh / scp

## 五、其他实用
- date / cal / history / ln / find / locate / grep

## 六、实操截图
（本周练习的关键截图）
```

---

## 模块 4 systemctl 服务管理、运行级别（对应 050/022 集）

### 核心知识点

1. CentOS7/9 统一使用 `systemctl` 管理系统后台服务，替代旧 service 命令
2. 常用操作：start 启动、stop 停止、restart 重启、status 查看状态、reload 重载配置
3. enable 设置开机自启；disable 取消开机自启；is-enabled 查看自启状态
4. 系统服务操作必须加 sudo 提权
5. 运行级别（target）：`multi-user.target` 等价老 runlevel 3（命令行）；`graphical.target` 等价老 runlevel 5（图形界面）
6. `get-default` 查看当前默认级别；`set-default` 切换默认级别

### 实操命令

#### 1. 服务基本管理

```
# 查看服务状态（任意目录执行）
systemctl status sshd
# 停止/启动/重启服务（任意目录执行）
sudo systemctl stop sshd
sudo systemctl start sshd
sudo systemctl restart sshd
# 重新加载配置（修改配置文件后，任意目录执行）
sudo systemctl reload sshd
# 查看所有已启动服务（任意目录执行）
systemctl list-units --type=service --state=running
```

【此处放置截图：systemctl status sshd 输出】
![[Pasted image 20260920151834.png]]

#### 2. 开机自启配置

```
# 设置开机自启（任意目录执行）
sudo systemctl enable sshd
# 取消开机自启（任意目录执行）
sudo systemctl disable sshd
# 查看某服务自启状态（任意目录执行）
systemctl is-enabled sshd
# 查看所有开机自启服务（任意目录执行）
systemctl list-unit-files --type=service | grep enabled
```

【此处放置截图：enable/disable 与 is-enabled 输出】
![[Pasted image 20260920152323.png]]
![[Pasted image 20260920152507.png]]
#### 3. 运行级别

```
# 查看当前默认运行级别（任意目录执行）
systemctl get-default
# 切换到多用户命令行模式（老runlevel 3，任意目录执行）
sudo systemctl set-default multi-user.target
# 切换回图形界面模式（老runlevel 5，任意目录执行）
sudo systemctl set-default graphical.target
# 查看当前处于哪个target（任意目录执行）
systemctl list-units --type=target | grep -E "multi-user|graphical"
```

【此处放置截图：get-default/set-default 输出】
![[Pasted image 20260920153014.png]]
### 故障模拟：服务启动失败排障（独立排查）

场景：修改 sshd 配置后 `systemctl restart sshd` 失败。

```
# (~/shell_test 目录执行)
# 1.故意改坏配置（追加一行Port制造语法问题）
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "Port 2222" | sudo tee -a /etc/ssh/sshd_config > /dev/null
# 2.重启服务 → 预期失败
sudo systemctl restart sshd
# 3.查看失败原因
systemctl status sshd
# 4.查看详细错误日志
journalctl -u sshd --no-pager | tail -20
# 5.用配置文件检查命令定位问题
sudo sshd -t
# 6.修复（恢复备份）并重启
sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
sudo systemctl restart sshd
# 7.确认恢复正常
systemctl status sshd
```

【此处放置截图：restart 失败报错】

![[Pasted image 20260920160749.png]]
【此处放置截图：sshd -t 检查与修复后恢复正常】
![[Pasted image 20260920160838.png]]
### 本模块避坑

> 1. `systemctl status` 只能看到失败原因一行摘要，详细看 `journalctl -u 服务名`。
> 2. 修改关键服务（sshd）配置前务必备份；改完先 `sshd -t` 语法检查再重启。
> 3. 远程操作 sshd 时改错配置可能导致断连，务必保留一个本地/其他会话兜底。
> 4. systemctl 管理系统服务必须加 sudo，普通用户无启停权限。

### 本模块最终产出：服务管理操作笔记

在 Windows 本地 Obsidian 知识库 `01_Linux学习` 目录新建 `04_服务管理操作笔记.md`，记录 systemctl 常用操作、开机自启配置、运行级别切换及本次排障全过程（含截图）。

---

## 模块 5 crontab 定时任务（对应 039/040 集）

### 核心知识点

1. crond 是 Linux 内置定时任务服务，默认开机自启，每分钟扫描一次任务规则
2. 两类任务：系统级定时任务（日志轮转等）、用户级定时任务（crontab 自定义）
3. ==crontab 常用参数：`-e` 编辑、`-l` 查看、`-r` 清空全部、`-u 用户名 -l` 查看指定用户==
4. ==定时表达式格式：`分 时 日 月 周 执行命令/脚本`==
5. 常用表达式：`* * * * *` 每分钟；`*/5 * * * *` 每5分钟；`0 2 * * *` 每天2点；`30 23 * * 0` 每周日23:30

### 实操命令

#### 1. crontab 基本操作

```
# 查看crond服务状态（任意目录执行）
systemctl status crond
# 设置crond开机自启（任意目录执行）
sudo systemctl enable crond
# 编辑当前用户定时任务（首次选择编辑器选vim，任意目录执行）
crontab -e
# 查看当前用户定时任务（任意目录执行）
crontab -l
# 查看系统级任务（root，任意目录执行）
sudo crontab -l
# 清空当前用户全部定时任务（谨慎，任意目录执行）
crontab -r
```

【此处放置截图：crontab -l 输出】
![[Pasted image 20260920161946.png]]
#### 2. 搭建定时清理日志任务

编写清理脚本：

```
# (~/shell_test 目录执行)
vim ~/shell_test/scripts/cleanup_logs.sh
```

cleanup_logs.sh 内容：

```
#!/bin/bash
# 功能：清理 logs 目录下超过 7 天的日志文件
# 作者：study  日期：$(date +%F)
LOG_DIR="$HOME/shell_test/logs"
KEEP_DAYS=7

# 目录不存在则退出
if [ ! -d "$LOG_DIR" ]; then
    echo "$(date '+%F %T') ERROR: 目录 $LOG_DIR 不存在" >> "$HOME/cleanup_err.log"
    exit 1
fi

# 查找并删除 7 天前的 *.log 文件
find "$LOG_DIR" -name "*.log" -mtime +$KEEP_DAYS -print -delete >> "$HOME/shell_test/logs/cleanup.log" 2>&1

# 清理脚本自身日志超过 30 天的记录（防止日志无限增长）
find "$LOG_DIR" -name "cleanup.log" -mtime +30 -delete 2>/dev/null

echo "$(date '+%F %T') INFO: 清理完成" >> "$HOME/shell_test/logs/cleanup.log"
```

加执行权限并测试：

```
# (~/shell_test 目录执行)
chmod +x ~/shell_test/scripts/cleanup_logs.sh
~/shell_test/scripts/cleanup_logs.sh
# 造一些 8 天前的旧日志再测试
touch -d "8 days ago" ~/shell_test/logs/old1.log ~/shell_test/logs/old2.log
~/shell_test/scripts/cleanup_logs.sh
ls ~/shell_test/logs/
```

【此处放置截图：脚本测试运行与旧日志被清理结果】
![[Pasted image 20260920165258.png]]


配置定时任务：

```
# (~/shell_test 目录执行)
# 编辑定时任务：每天凌晨2点执行清理
crontab -e
# 添加一行（crontab 中必须写绝对路径）
0 2 * * * /home/study/shell_test/scripts/cleanup_logs.sh
# 验证
crontab -l
```

【此处放置截图：crontab -e 添加任务与 crontab -l 验证】
![[Pasted image 20260920170044.png]]
### 故障模拟：定时任务不执行/权限报错（独立排查）

场景：任务到点未执行，或日志中报 `Permission denied` / `command not found`。

```
# (~/shell_test 目录执行)
# 1.查看任务是否在列表中
crontab -l
# 2.查看系统cron日志（是否有执行记录、报错）
sudo tail -50 /var/log/cron
# 3.常见原因检查：
#    - 脚本没有执行权限 → chmod +x
#    - 脚本内用了相对路径 → 改为绝对路径
#    - 环境变量缺失（cron环境极简，PATH只有/usr/bin:/bin）
#    - 脚本首行缺 #!/bin/bash
# 4.手动用cron环境跑一次验证
/bin/bash /home/study/shell_test/scripts/cleanup_logs.sh
```

【此处放置截图：/var/log/cron 查看执行记录】
没有执行记录
![[Pasted image 20260920171602.png]]
重新调整：
![[Pasted image 20260920175532.png]]
### 本模块避坑

> 1. crontab 里的命令必须用绝对路径，环境变量（PATH）是精简的，脚本内也尽量用绝对路径。
> 2. 自定义脚本必须添加 x 执行权限，否则定时无法运行。
> 3. crontab -r 会一次性清空全部任务，删除单条任务请在 crontab -e 内手动删行。
> 4. 排查顺序：`crontab -l` 看配置 → `/var/log/cron` 看执行 → 手动执行看脚本本身。
> 5. 定时表达式中日和周字段不要同时限定条件，容易产生执行冲突。

### 本模块最终产出：搭建定时清理日志任务

完成脚本 `cleanup_logs.sh`（虚拟机 `~/shell_test/scripts/`）+ crontab 配置，验证任务可执行，操作过程记录到 Windows 本地 Obsidian 知识库 `01_Linux学习` 目录的 `05_定时清理日志任务.md`（含脚本、crontab 配置、执行验证截图、避坑点）。

---

## 模块 6 Shell 基础语法：变量、判断 if（对应 Shell 专项 01–10 集）

### 核心知识点

1. Shell 是一个命令行解释器，也是功能强大的编程语言；默认解析器 `bash`
2. `#!/bin/bash` 脚本首行声明解析器
3. 系统变量：`$HOME` `$USER` `$SHELL` `$PWD` `$PATH`
4. 自定义变量：`变量名=值`（等号两边不能有空格）；`unset` 撤销；`readonly` 只读
5. 位置参数：`$0` 脚本名、`$1-$9` 参数、`${10}` 第10个参数；`$#` 参数个数；`$*` 所有参数（整体）；`$@` 所有参数（分开）；`$?` 上条命令退出码
6. 运算符：`$(( 表达式 ))` 整数运算；`$[ 表达式 ]` 老式写法
7. 条件判断 `[ ]`：数值 `-eq -ne -gt -lt -ge -le`；字符串 `= != -z`；文件 `-f -d -e`
8. if 判断：`if [ 条件 ]; then ... elif [ 条件 ]; then ... else ... fi`

### 实操命令

#### 1. HelloWorld 与解析器

```
# 查看当前Shell解析器（任意目录执行）
echo $SHELL
# 查看系统可用解析器（任意目录执行）
cat /etc/shells
# 编写第一个脚本（在 ~/shell_test/scripts 目录执行）
vim ~/shell_test/scripts/hello.sh
```

hello.sh 内容：

```
#!/bin/bash
echo "Hello World!"
```

```
# 赋予执行权限并运行（在 ~/shell_test/scripts 目录执行）
chmod +x ~/shell_test/scripts/hello.sh
./hello.sh
# 或直接调用解析器执行（无需执行权限）
bash ~/shell_test/scripts/hello.sh
```

【此处放置截图：hello.sh 运行输出】
![[Pasted image 20260920173633.png]]
#### 2. 变量

```
# 查看系统变量（任意目录执行）
echo $HOME $USER $SHELL $PWD
# 自定义变量（任意目录执行）
name=study
echo $name
# 撤销变量（任意目录执行）
unset name
# 只读变量（不可撤销，任意目录执行）
readonly version=1.0
echo $version
```

【此处放置截图：系统变量与自定义变量输出】
![[Pasted image 20260920174030.png]]
#### 3. 位置参数与预定义变量

```
# 编写位置参数演示脚本（在 ~/shell_test/scripts 目录执行）
vim args.sh
```

args.sh 内容：

```
#!/bin/bash
echo "脚本名: $0"
echo "第1个参数: $1"
echo "第2个参数: $2"
echo "参数个数: $#"
echo "所有参数(\$*): $*"
echo "所有参数(\$@): $@"
echo "上条命令退出码: $?"
```

```
# 运行位置参数脚本（在 ~/shell_test/scripts 目录执行）
chmod +x args.sh
./args.sh hello shell
```

【此处放置截图：args.sh 带参运行输出】
![[Pasted image 20260920181506.png]]
#### 4. 运算符与条件判断

```
# 整数运算（推荐$(( ))，任意目录执行）
echo $(( 3 + 5 ))
a=10; b=3
echo $(( a * b ))
# 数值比较（任意目录执行）
[ 10 -gt 5 ] && echo "10大于5"
# 文件判断（任意目录执行）
[ -f /etc/passwd ] && echo "文件存在"
[ -d ~/shell_test ] && echo "目录存在"
```

【此处放置截图：运算与条件判断输出】
![[Pasted image 20260920182006.png]]
#### 5. if 判断

```
# 编写if判断脚本（在 ~/shell_test/scripts 目录执行）
vim if_demo.sh
```

if_demo.sh 内容：

```
#!/bin/bash
# 判断传入参数是否为数字
if [ $# -lt 1 ]; then
    echo "用法: $0 <数字>"
    exit 1
fi
if [ $1 -gt 100 ]; then
    echo "$1 大于 100"
elif [ $1 -gt 0 ]; then
    echo "$1 是 1-100 之间的正数"
else
    echo "$1 小于等于 0"
fi
```

```
# 运行if脚本三种情况（在 ~/shell_test/scripts 目录执行）
chmod +x if_demo.sh
./if_demo.sh 50
./if_demo.sh 150
./if_demo.sh
```

【此处放置截图：if_demo.sh 三种情况输出】
![[Pasted image 20260920182711.png]]

### 本模块避坑

> 1. `=` 赋值两边不能有空格；`[ ]` 判断中 `[` 后、`]` 前必须有空格。
> 2. 位置参数 10 以上必须用 `${10}` 写法。
> 3. `$?` 只能取最近一条命令的退出码，取完立即保存到变量。
> 4. 变量加引号 `"$var"` 防止未定义或含空格时报错。

### 本模块最终产出：第一个 Shell 脚本（批量过滤政务系统日志）

编写 `~/shell_test/scripts/filter_gov_log.sh`（虚拟机）：接收日志文件路径参数，过滤 ERROR 日志，支持按关键字统计。完成后上传 GitHub 仓库 `Alice5997/linux-study-notes`。

filter_gov_log.sh 完整内容：

```
#!/bin/bash
# =====================================================
# 功能：批量过滤政务系统日志中的 ERROR 级别记录
# 用法：./filter_gov_log.sh <日志文件> [关键字]
# 示例：./filter_gov_log.sh /home/study/shell_test/logs/app.log "数据库"
# 作者：study  日期：$(date +%F)
# =====================================================

# 参数校验：必须传入日志文件
if [ $# -lt 1 ]; then
    echo "用法: $0 <日志文件> [关键字]"
    exit 1
fi

LOG_FILE="$1"
KEYWORD="${2:-ERROR}"      # 默认过滤 ERROR
OUT_FILE="$HOME/shell_test/logs/filter_result.log"

# 文件存在性判断
if [ ! -f "$LOG_FILE" ]; then
    echo "错误: 日志文件 $LOG_FILE 不存在"
    exit 1
fi

# 过滤日志（忽略大小写，带行号）
grep -in "$KEYWORD" "$LOG_FILE" > "$OUT_FILE"

# 统计条数
COUNT=$(grep -ic "$KEYWORD" "$LOG_FILE")
echo "过滤完成: 共找到 $COUNT 条包含 [$KEYWORD] 的记录"
echo "结果已保存到: $OUT_FILE"
echo "--- 前 10 条预览 ---"
head -10 "$OUT_FILE"
```

测试脚本：

```
# (~/shell_test 目录执行)
chmod +x ~/shell_test/scripts/filter_gov_log.sh
~/shell_test/scripts/filter_gov_log.sh ~/shell_test/logs/app.log
~/shell_test/scripts/filter_gov_log.sh ~/shell_test/logs/app.log "超时"
```

【此处放置截图：filter_gov_log.sh 运行输出与结果文件】
![[Pasted image 20260920210646.png]]

GitHub 上传步骤：

```
# (~/shell_test 目录执行)
# 1.初始化仓库（若还未clone过）
cd ~/shell_test
git init
# 2.配置用户信息（一次性）
git config --global user.name "Alice5997"
git config --global user.email "你的GitHub邮箱"
# 3.添加并提交脚本
git add scripts/filter_gov_log.sh
git commit -m "添加批量过滤政务系统日志脚本"
# 4.关联远程仓库并推送（仓库: Alice5997/linux-study-notes）
git remote add origin https://github.com/Alice5997/linux-study-notes.git
git push -u origin main
```

【此处放置截图：git commit 与 git push 成功输出】


---

## 模块 7 Shell 循环 for/while、脚本读取本地文档批量处理（对应 Shell 专项 11–20 集）

### 核心知识点

1. for 循环两种写法：`for 变量 in 列表; do ... done`；`for ((初值; 条件; 步进)); do ... done`
2. while 循环：`while [ 条件 ]; do ... done`；`((i++))` 自增
3. 读取文件每一行：`while read line; do ... done < 文件`
4. `read` 读取控制台输入：`-p` 提示文字；`-t` 超时时间
5. `basename` 取文件名、`dirname` 取目录（仅字符串切割，不校验真实存在）
6. `case` 多分支：`case 变量 in 值1) ;; 值2) ;; *) ;; esac`

### 实操命令

#### 1. for 循环（两种写法）

```
# 遍历列表（任意目录执行）
for fruit in apple banana orange; do
    echo "水果: $fruit"
done
# 数值循环（C语言风格，任意目录执行）
for ((i=1; i<=5; i++)); do
    echo "第 $i 次循环"
done
# 遍历文件列表（任意目录执行）
for f in ~/shell_test/logs/*.log; do
    echo "处理文件: $f"
done
```

【此处放置截图：for 循环三种方式输出】

#### 2. while 循环

```
# 计数循环（任意目录执行）
i=1
while [ $i -le 5 ]; do
    echo "计数: $i"
    ((i++))
done
# 读取文件每一行（任意目录执行）
while read line; do
    echo "读取到: $line"
done < ~/shell_test/logs/app.log
```

【此处放置截图：while 循环与逐行读文件输出】

#### 3. read 读取输入

```
# 读取单个输入（任意目录执行）
read -p "请输入你的名字: " username
echo "你好, $username"
# 读取多个变量（任意目录执行）
read -p "输入姓名和年龄(空格分隔): " name age
echo "姓名:$name 年龄:$age"
```

【此处放置截图：read 交互输入输出】

#### 4. basename / dirname

```
# 取出文件名（任意目录执行）
basename /home/study/shell_test/scripts/filter_gov_log.sh
# 取出目录（任意目录执行）
dirname /home/study/shell_test/scripts/filter_gov_log.sh
```

【此处放置截图：basename/dirname 输出】

### 本模块避坑

> 1. `for f in 目录/*.log` 无匹配文件时 `$f` 会保留通配符，需要 `[ -f "$f" ] || continue` 跳过。
> 2. `read -t` 超时后变量为空，脚本不会报错，容易忽略。
> 3. while read 逐行读取注意文件末尾无换行的最后一行。

### 本模块最终产出：循环处理文档脚本

编写 `~/shell_test/scripts/process_logs_batch.sh`（虚拟机）：遍历 logs 目录所有 `.log` 文件，逐个统计 ERROR 条数并汇总报告。完成后上传 GitHub。

process_logs_batch.sh 完整内容：

```
#!/bin/bash
# =====================================================
# 功能：循环处理 logs 目录下所有日志文件，统计各文件 ERROR 条数
# 用法：./process_logs_batch.sh [日志目录]
# 作者：study  日期：$(date +%F)
# =====================================================

LOG_DIR="${1:-$HOME/shell_test/logs}"
REPORT="$HOME/shell_test/logs/batch_report.txt"

# 目录校验
if [ ! -d "$LOG_DIR" ]; then
    echo "错误: 目录 $LOG_DIR 不存在"
    exit 1
fi

# 清空旧报告
> "$REPORT"
echo "批量日志处理报告 - $(date '+%F %T')" >> "$REPORT"
echo "==============================" >> "$REPORT"

TOTAL=0
FILE_COUNT=0

# for 循环遍历所有 .log 文件
for f in "$LOG_DIR"/*.log; do
    # 无匹配文件时 $f 会保留通配符，跳过
    [ -f "$f" ] || continue
    FILE_COUNT=$((FILE_COUNT + 1))
    ERR_COUNT=$(grep -ic "ERROR" "$f")
    TOTAL=$((TOTAL + ERR_COUNT))
    echo "$(basename "$f"): ERROR $ERR_COUNT 条" | tee -a "$REPORT"
done

echo "==============================" >> "$REPORT"
echo "共处理 $FILE_COUNT 个日志文件，ERROR 总计 $TOTAL 条" | tee -a "$REPORT"
```

测试脚本：

```
# (~/shell_test 目录执行)
# 造多个日志文件测试
for i in 1 2 3; do
    cp ~/shell_test/logs/app.log ~/shell_test/logs/node$i.log
done
chmod +x ~/shell_test/scripts/process_logs_batch.sh
~/shell_test/scripts/process_logs_batch.sh
cat ~/shell_test/logs/batch_report.txt
```

【此处放置截图：批量处理报告输出】

GitHub 上传：

```
# (~/shell_test 目录执行)
cd ~/shell_test
git add scripts/process_logs_batch.sh
git commit -m "添加循环处理日志脚本"
git push -u origin main
```

【此处放置截图：push 成功输出】

---

## 模块 8 Shell 函数、传参实操 + 脚本运行报错独立排障（对应 Shell 专项 21–26 集）

### 核心知识点

1. 函数定义：`[function] 函数名() { 逻辑代码; [return n;] }`；必须**先定义后调用**
2. 传参：调用函数后面直接跟参数，函数内用 `$1 $2` 获取
3. return 返回值只能是 0‑255 整数；用 `$?` 接收；`local` 定义局部变量
4. 文本处理三剑客：`cut` 按列截取（`-d` 分隔符、`-f` 列号）；`sed` 按行处理（`p` 打印、`d` 删除、`s///g` 替换，`-i` 直接改文件）；`awk` 文本分析（`-F` 分隔符、`$0 $1 NR NF $NF`）；`sort` 排序（`-n` 数字、`-r` 倒序、`-k` 指定列）
5. 管道符 `|`：把前一条命令输出交给后一条命令作为输入

### 实操命令

#### 1. 自定义函数与传参

```
# 编写函数演示脚本（在 ~/shell_test/scripts 目录执行）
vim func_demo.sh
```

func_demo.sh 内容：

```
#!/bin/bash
# 定义函数
function say_hello() {
    echo "你好, $1 !"
}
# 或省略 function 关键字
add() {
    echo "$1 + $2 = $(( $1 + $2 ))"
}
# 调用函数（传参）
say_hello study
add 10 20
# 返回值（0-255，用 $? 获取）
check_file() {
    [ -f "$1" ] && return 0 || return 1
}
check_file /etc/passwd
echo "检查结果(0=存在): $?"
# 全局变量与局部变量
my_var="全局变量"
test_local() {
    local my_var="局部变量"
    echo "函数内: $my_var"
}
test_local
echo "函数外: $my_var"
```

```
# 运行函数脚本（在 ~/shell_test/scripts 目录执行）
chmod +x func_demo.sh
./func_demo.sh
```

【此处放置截图：函数定义调用与局部/全局变量输出】

#### 2. 文本处理工具（cut/sort/awk/sed）

```
# cut按列提取（任意目录执行）
echo "study:1000:1000" | cut -d ":" -f 1
grep "study" /etc/passwd | cut -d ":" -f 1,3
# sort排序（任意目录执行）
echo -e "3\n1\n2" | sort -n
# awk按列处理（任意目录执行）
awk -F ":" '{print $1, $3}' /etc/passwd | head -5
# sed文本替换（-i直接改文件，先预览再改，任意目录执行）
sed -i 's/old/new/g' ~/shell_test/logs/app.log
# 组合应用：提取ERROR日志中的时间列并排序（任意目录执行）
grep "ERROR" ~/shell_test/logs/app.log | awk '{print $1, $2}' | sort | uniq -c
```

【此处放置截图：cut/sort/awk/sed 输出】

### 故障模拟：脚本运行报错独立排障

场景：脚本运行报 `command not found`、`syntax error`、`No such file or directory` 等错误。

```
# (~/shell_test 目录执行)
# 1.用 bash -n 做语法检查（只查语法不执行）
bash -n ~/shell_test/scripts/filter_gov_log.sh && echo "语法OK"
# 2.用 bash -x 跟踪执行（显示每步展开的命令，最常用调试手段）
bash -x ~/shell_test/scripts/filter_gov_log.sh ~/shell_test/logs/app.log
# 3.常见错误对照：
#    - command not found → 命令拼写错 / 未加 #!/bin/bash
#    - syntax error → 少了 then/fi/done、if 条件格式错
#    - No such file → 相对路径问题，改绝对路径
#    - Permission denied → chmod +x
# 4.逐段隔离：把脚本拆开逐步执行，或用 echo 打点
```

【此处放置截图：bash -x 跟踪输出定位错误】

### 本模块避坑

> 1. shell 函数 `return` 只能返回 0‑255 之间数字；大于 255 结果会溢出。
> 2. 函数一定要先定义再调用，顺序写反直接报错。
> 3. `bash -n` 查语法、`bash -x` 跟踪执行，是脚本排障两件套。
> 4. `if [ ]` 判断中 `[` 后、`]` 前必须有空格，`=` 两边不能有空格。
> 5. awk 条件动作部分必须用**单引号**，双引号会被 shell 解析变量导致异常。
> 6. sort 默认字典序，数字排序必须加 `-n`，否则 `10 < 2`。

### 本模块最终产出：封装日志处理函数脚本

编写 `~/shell_test/scripts/log_funcs.sh`（虚拟机）：把日志过滤、统计、备份封装成函数库，供其他脚本 source 调用。上传 GitHub。

log_funcs.sh 完整内容：

```
#!/bin/bash
# =====================================================
# 功能：日志处理函数库（供其他脚本 source 调用）
# 用法：source ~/shell_test/scripts/log_funcs.sh
# 作者：study  日期：$(date +%F)
# =====================================================

# 函数1：过滤日志中指定关键字
# 用法：filter_log <日志文件> <关键字> [结果文件]
filter_log() {
    local log_file="$1"
    local keyword="$2"
    local out_file="${3:-$HOME/shell_test/logs/filter_result.log}"

    if [ ! -f "$log_file" ]; then
        echo "ERROR: 文件 $log_file 不存在"
        return 1
    fi
    grep -in "$keyword" "$log_file" > "$out_file"
    echo "已过滤 [$keyword] 到 $out_file"
    return 0
}

# 函数2：统计日志中关键字出现次数
# 用法：count_log <日志文件> <关键字>
count_log() {
    local log_file="$1"
    local keyword="$2"
    [ -f "$log_file" ] || { echo "ERROR: 文件不存在"; return 1; }
    local count
    count=$(grep -ic "$keyword" "$log_file")
    echo "$count"
}

# 函数3：备份日志（带时间戳）
# 用法：backup_log <日志文件> [备份目录]
backup_log() {
    local log_file="$1"
    local bak_dir="${2:-$HOME/shell_test/backup}"
    [ -f "$log_file" ] || { echo "ERROR: 文件不存在"; return 1; }
    mkdir -p "$bak_dir"
    local base
    base=$(basename "$log_file")
    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    cp "$log_file" "$bak_dir/${base}.${stamp}.bak"
    echo "已备份到 $bak_dir/${base}.${stamp}.bak"
    return 0
}
```

测试调用：

```
# (~/shell_test 目录执行)
# 导入函数库
source ~/shell_test/scripts/log_funcs.sh
# 调用过滤函数
filter_log ~/shell_test/logs/app.log "超时"
# 调用统计函数
ERR_COUNT=$(count_log ~/shell_test/logs/app.log "ERROR")
echo "ERROR 共 $ERR_COUNT 条"
# 调用备份函数
backup_log ~/shell_test/logs/app.log
ls ~/shell_test/backup/
```

【此处放置截图：函数库导入与三个函数调用输出】

GitHub 上传：

```
# (~/shell_test 目录执行)
cd ~/shell_test
git add scripts/log_funcs.sh
git commit -m "添加日志处理函数库"
git push -u origin main
```

【此处放置截图：push 成功输出】

---

## 模块 9 综合复盘 + 完整政务日志自动化处理脚本（回看薄弱章节）

### 核心知识点

1. 综合运用：变量、if 判断、for/while 循环、自定义函数、crontab 定时任务
2. 函数库通过 `source` 导入复用
3. `find 目录 -name "*.log" -mtime +N -delete` 清理 N 天前文件
4. 自动化脚本设计闭环：检查目录 → 过滤统计 → 备份 → 清理 → 定时执行

### 实操：完整政务日志自动化处理脚本

编写 `~/shell_test/scripts/gov_log_auto.sh`（虚拟机），功能：
1. 检查日志目录是否存在（if + 文件判断）
2. 批量过滤 ERROR/WARN 日志并生成日报（for 循环 + 函数）
3. 统计各类错误数量并追加到汇总报告（awk/sort）
4. 自动备份当日日志（函数 + 时间戳）
5. 清理 7 天前旧日志（find）
6. 配合 crontab 每天定时执行

gov_log_auto.sh 完整内容：

```
#!/bin/bash
# =====================================================
# 功能：政务系统日志自动化处理（过滤+统计+备份+清理）
# 用法：./gov_log_auto.sh
# 建议配合 crontab 每日执行：0 1 * * * /home/study/shell_test/scripts/gov_log_auto.sh
# 作者：study  日期：$(date +%F)
# =====================================================

# ---------- 全局配置 ----------
LOG_DIR="$HOME/shell_test/logs"
BAK_DIR="$HOME/shell_test/backup"
REPORT_DIR="$HOME/shell_test/reports"
KEEP_DAYS=7
TODAY=$(date +%F)
REPORT="$REPORT_DIR/gov_log_report_${TODAY}.txt"

# ---------- 导入函数库 ----------
if [ -f "$HOME/shell_test/scripts/log_funcs.sh" ]; then
    source "$HOME/shell_test/scripts/log_funcs.sh"
else
    echo "ERROR: 函数库 log_funcs.sh 不存在"
    exit 1
fi

# ---------- 主流程 ----------
main() {
    # 1. 检查日志目录
    if [ ! -d "$LOG_DIR" ]; then
        echo "ERROR: 日志目录 $LOG_DIR 不存在，请先创建"
        exit 1
    fi
    mkdir -p "$REPORT_DIR" "$BAK_DIR"

    # 2. 生成当日报告头
    > "$REPORT"
    echo "政务系统日志日报 - $TODAY" >> "$REPORT"
    echo "==============================" >> "$REPORT"

    # 3. 遍历所有日志文件：过滤 + 统计 + 备份
    TOTAL_ERROR=0
    TOTAL_WARN=0
    FILE_NUM=0
    for f in "$LOG_DIR"/*.log; do
        [ -f "$f" ] || continue
        FILE_NUM=$((FILE_NUM + 1))
        BASE=$(basename "$f")

        # 统计各级别数量（调用函数库）
        E_CNT=$(count_log "$f" "ERROR")
        W_CNT=$(count_log "$f" "WARN")
        TOTAL_ERROR=$((TOTAL_ERROR + E_CNT))
        TOTAL_WARN=$((TOTAL_WARN + W_CNT))

        # 记录到报告
        echo "$BASE | ERROR:$E_CNT | WARN:$W_CNT" >> "$REPORT"

        # 自动备份（若今日未备份过）
        if [ ! -f "$BAK_DIR/${BASE}.${TODAY}.bak" ]; then
            backup_log "$f" "$BAK_DIR" > /dev/null
        fi
    done

    # 4. 汇总统计
    echo "==============================" >> "$REPORT"
    echo "文件数: $FILE_NUM | ERROR 总计: $TOTAL_ERROR | WARN 总计: $TOTAL_WARN" >> "$REPORT"

    # 5. 清理 7 天前的日志和备份
    find "$LOG_DIR" -name "*.log" -mtime +$KEEP_DAYS -delete 2>/dev/null
    find "$BAK_DIR" -name "*.bak" -mtime +$KEEP_DAYS -delete 2>/dev/null

    # 6. 完成提示
    echo "自动化处理完成，报告: $REPORT"
    echo "--- 报告预览 ---"
    cat "$REPORT"
}

# 执行主流程
main
```

测试运行：

```
# (~/shell_test 目录执行)
chmod +x ~/shell_test/scripts/gov_log_auto.sh
~/shell_test/scripts/gov_log_auto.sh
# 配置每日1点自动执行
crontab -e
# 添加：0 1 * * * /home/study/shell_test/scripts/gov_log_auto.sh
crontab -l
# 验证 crontab 执行（第二天检查 /var/log/cron 与 reports 目录）
```

【此处放置截图：gov_log_auto.sh 运行输出与报告内容】
【此处放置截图：crontab -l 显示每日任务】

### 本模块最终产出：完整自动化脚本上传 GitHub

```
# (~/shell_test 目录执行)
cd ~/shell_test
git add scripts/gov_log_auto.sh
git commit -m "添加政务日志自动化处理完整脚本"
git push -u origin main
```

【此处放置截图：push 成功输出】

---

## 模块 10 全部知识点复盘 + 故障模拟（全量回顾）

### 核心知识点

全量复盘：进程/端口/磁盘/日志/SSH/scp/服务管理/运行级别/定时任务/Shell 变量/判断/循环/函数/三剑客。

### 故障模拟一：服务启动失败（独立排查）

场景：sshd 启动失败。

```
# (~/shell_test 目录执行)
# 1.查看状态与错误
systemctl status sshd
journalctl -u sshd --no-pager | tail -30
# 2.检查配置文件
sudo sshd -t
# 3.修复（回滚备份 / 修正配置）
# 4.重启并验证
sudo systemctl restart sshd
systemctl is-active sshd
```

【此处放置截图：服务启动失败排查全过程】

### 故障模拟二：定时任务失效（独立排查）

场景：crontab 任务到点未执行。

```
# (~/shell_test 目录执行)
# 1.确认任务存在
crontab -l
# 2.查cron执行日志
sudo tail -100 /var/log/cron
# 3.检查脚本权限与语法
ls -l ~/shell_test/scripts/*.sh
bash -n ~/shell_test/scripts/gov_log_auto.sh
# 4.手动执行验证
bash ~/shell_test/scripts/gov_log_auto.sh
# 5.修复后重新测试（可临时把时间改成1分钟后验证）
crontab -e
```

【此处放置截图：定时任务失效排查全过程】

### 本模块避坑

> 1. 服务启动失败优先看 `journalctl -u 服务名`，比 status 信息更全。
> 2. 定时任务失效排查顺序：`crontab -l` → `/var/log/cron` → 手动执行脚本。
> 3. 全量复盘建议对照分集清单自查：每个模块能否不看笔记独立复现命令。

### 本模块最终产出：故障处理完整文档 + 投递记录

在 Windows 本地 Obsidian 知识库 `01_Linux学习` 目录新建 `06_故障处理完整文档.md`：

```
# 故障处理完整文档

## 故障一：sshd 服务启动失败
### 现象
### 排查过程（含命令与截图）
### 根因
### 解决方案
### 避坑点

## 故障二：定时任务未执行
### 现象
### 排查过程（含命令与截图）
### 根因
### 解决方案
### 避坑点

```

---

## 补充：综合练习踩坑记录区域

1. ==kill -9 尽量不用，数据库、Web 服务强制杀死会丢失业务数据==
2. ==top 界面必须输入 q 退出，不能直接关闭终端残留进程==
3. ==磁盘爆满优先 du 定位，别盲目 rm；注意 inode（df -i）也可能耗尽==
4. ==systemctl 管理服务必须加 sudo，普通用户无启停权限==
5. ==crontab 内命令必须绝对路径，脚本必须有 x 权限，脚本内 PATH 精简==
6. ==sed -i 直接改文件，先去掉 -i 预览再写回==
7. ==awk 动作代码必须单引号包裹，双引号会被 shell 解析==
8. ==sort 数字排序必须加 -n，否则 10 < 2==
9. ==bash -n 查语法、bash -x 跟踪执行，是脚本排障两件套==
10. ==shell 函数 return 只能返回 0-255，超范围会溢出==
11. ==端口占用排查：ss -tunlp | grep 端口 → kill -9 PID → 二次确认==
12. ==GitHub 上传前先 git config user.name/email，首次 push 用 -u 关联远程==
13. ==crontab 里面 date 命令的 % 符号是特殊符号，需要转义 \%==
14. ==脚本内明文写数据库密码仅练习使用，生产环境禁止==

## 综合练习自检清单

- [ ] ps、top、kill、killall 管理进程；netstat/ss 查看端口并完成端口冲突故障排查
- [ ] df、du、lsblk 查看磁盘；grep 过滤日志；独立完成磁盘爆满故障处理
- [ ] ssh 远程登录、scp 文件传输；整理本周全部 Linux 命令汇总文档
- [ ] systemctl 启停、设置服务开机自启；理解运行级别并能排障服务启动失败
- [ ] crontab 配置定时任务；掌握定时任务日志排查与权限报错处理；落地定时清理日志任务
- [ ] Shell 变量、位置参数、运算符、if 判断；编写批量过滤政务系统日志脚本并上传 GitHub
- [ ] Shell for/while 循环、read、basename/dirname；编写循环处理文档脚本并上传 GitHub
- [ ] Shell 自定义函数、传参、return 返回值；bash -n/-x 排障；封装日志处理函数脚本
- [ ] 综合编写完整政务日志自动化处理脚本（过滤+统计+备份+清理+crontab）并上传 GitHub
- [ ] 模拟服务启动失败、定时任务失效故障，完成故障处理完整文档
- [ ] CAIE 一级第二章刷题完成并复盘
- [ ] BOSS 直聘投递 6 个岗位并记录

## 产出落地总清单（红框要求）

| #   | 产出物                          | 存放/落地位置                                                                        | 完成状态 |
| --- | ---------------------------- | ------------------------------------------------------------------------------ | ---- |
| 01  | 端口冲突故障解决流程                   | `01_Linux学习/01_端口冲突故障解决流程.md`                                                  | ☐    |
| 02  | 磁盘、日志排查实操文档                  | `01_Linux学习/02_磁盘日志排查实操.md`                                                    | ☐    |
| 03  | 本周全部 Linux 命令汇总文档            | `01_Linux学习/03_本周Linux命令汇总.md`                                                 | ☐    |
| 04  | 服务管理操作笔记                     | `01_Linux学习/04_服务管理操作笔记.md`                                                    | ☐    |
| 05  | 定时清理日志任务（脚本+crontab）         | 脚本 `~/shell_test/scripts/cleanup_logs.sh`（虚拟机）+ 记录 `01_Linux学习/05_定时清理日志任务.md` | ☐    |
| 06  | 第一个 Shell 脚本（过滤政务日志）→ GitHub | `~/shell_test/scripts/filter_gov_log.sh`（虚拟机）→ GitHub                          | ☐    |
| 07  | 循环处理文档脚本 → GitHub            | `~/shell_test/scripts/process_logs_batch.sh`（虚拟机）→ GitHub                      | ☐    |
| 08  | 封装日志处理函数脚本                   | `~/shell_test/scripts/log_funcs.sh`（虚拟机）                                       | ☐    |
| 09  | 完整政务日志自动化脚本 → GitHub         | `~/shell_test/scripts/gov_log_auto.sh`（虚拟机）→ GitHub                            | ☐    |
| 10  | 故障处理完整文档                     | `01_Linux学习/06_故障处理完整文档.md`                                                    | ☐    |

**GitHub 仓库**：`Alice5997/linux-study-notes`（公开仓库，Linux 全套笔记与脚本统一归档于此）

## 实操收尾

```
#练习文件全部保存在 ~/shell_test
#可选：删除练习目录
# rm -rf ~/shell_test
```
