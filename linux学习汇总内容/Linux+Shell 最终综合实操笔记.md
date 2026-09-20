# Linux + Shell 最终综合实操笔记

> 本笔记整合「8月第1周（8.4–8.6）」与「8月第2周（8.8–8.14）」学习计划中红框标注的全部内容，按「学习目标 → 对应视频选集 → 核心知识点 → 实操命令 → 故障模拟 → 最终产出」组织。请严格按模块顺序完成最终练习与汇总，并落地红框要求的全部产出。
>
> **学习环境**：CentOS Stream 9 ｜ 普通用户 `study` ｜ 家目录 `/home/study` ｜ 练习根目录 `~/shell_test` ｜ 主机名 `linux-study01` ｜ 网卡 `ens160`（NAT：`192.168.133.0/24`，网关 `192.168.133.2`，静态 IP `192.168.133.100`）
>
> **目录约定**：所有练习统一在 `~/shell_test` 下进行；脚本统一放在 `~/shell_test/scripts/`；日志练习数据放在 `~/shell_test/logs/`。

---

## 学习计划总览（红框内容）

| 日期 | 学习内容 | 对应视频选集 | 红框要求的产出 |
|---|---|---|---|
| 8.4 | 进程管理 ps/top/kill、端口查看 netstat/ss、模拟端口占用故障独立排查 | 048 进程介绍和静态查看、049 终止进程、051 监控服务 | 记录端口冲突故障解决流程 |
| 8.5 | 磁盘管理 df/du、日志查看 grep 过滤日志、模拟磁盘爆满故障处理 | 041 磁盘分区介绍、042 Linux 分区、043 添加新硬盘、044 磁盘查询实用指令 | 磁盘、日志排查实操文档 |
| 8.6 | SSH 远程连接、scp 文件传输、本周所有命令综合复盘实操 | 013 远程登录 XShell5、014 远程上传下载 XFTP5 | 整理本周全部 Linux 命令汇总文档 |
| 8.8 | systemctl 服务管理、开机自启配置；系统运行级别、服务启停排障 | 050 服务管理、022 运行级别和找回 root 密码 | 服务管理操作笔记 |
| 8.9 | crontab 定时任务配置；定时任务日志排查、权限报错处理 | 039 任务调度基本说明、040 任务调度应用实例 | 搭建定时清理日志任务 |
| 8.10 | Shell 脚本基础语法：变量、判断 if；编写脚本：批量过滤政务系统日志 | Shell 专项 01–10 集（课程介绍→$?案例） | 第一个 Shell 脚本上传 GitHub |
| 8.11 | Shell 循环 for/while；脚本读取本地文档批量处理 | Shell 专项 11–20 集（运算符→BaseName&DirName） | 循环处理文档脚本上传 GitHub |
| 8.12 | Shell 函数、传参实操；模拟脚本运行报错独立排障 | Shell 专项 21–26 集（自定义函数→企业真题） | 封装日志处理函数脚本 |
| 8.13 | Linux 服务、定时任务、Shell 全套复盘；综合编写完整政务日志自动化处理脚本 | 回看薄弱章节 | 完整自动化脚本上传 GitHub |
| 8.14 | 全部知识点复盘，模拟服务启动失败、定时任务失效故障；CAIE 刷题；BOSS 投递 6 岗 | 全量回顾 | 故障处理完整文档、投递记录 |

---

# 模块一（8.4）：进程管理与端口占用故障排查

## 学习目标
掌握进程的静态查看、实时监控、终止操作；掌握端口查看方法；能独立完成「端口被占用」故障的定位与解决。

## 对应视频选集
- 048_尚硅谷_Linux 实操篇_进程管理 进程介绍和静态查看
- 049_尚硅谷_Linux 实操篇_进程管理 终止进程
- 051_尚硅谷_Linux 实操篇_进程管理 监控服务

## 实操命令

### 1. 静态查看进程（ps）

```bash
# (~/shell_test 目录执行)
# 查看当前终端进程
ps
# 查看所有进程（BSD 风格，USER PID %CPU %MEM 等）
ps aux
# 查看所有进程（System V 风格，含父进程 PPID）
ps -ef
# 按用户名过滤
ps aux | grep study
# 配合管道精确查找某进程
ps aux | grep sshd
```
【此处放置截图：ps aux 与 ps -ef 输出对比】

### 2. 实时监控进程（top）

```bash
# (~/shell_test 目录执行)
# 进入 top 实时界面，按 q 退出
top
# 显示完整命令行（top 界面内按 c）
# 按 CPU 排序（top 界面内按 P），按内存排序（按 M）
```
【此处放置截图：top 实时监控界面】

### 3. 终止进程（kill / killall）

```bash
# (~/shell_test 目录执行)
# 先启动一个测试进程（持续 600 秒的 sleep）
sleep 600 &
# 找到该进程 PID
ps aux | grep sleep
# 温和终止（默认发 SIGTERM，15）
kill <PID>
# 强制终止（SIGKILL，9）—— 用于无法正常退出的进程
kill -9 <PID>
# 按名称终止所有匹配进程
killall sleep
```
【此处放置截图：kill 前后 ps 对比，进程已消失】

### 4. 端口查看（netstat / ss）

```bash
# (~/shell_test 目录执行)
# 查看所有监听端口及对应进程（netstat 需先安装 net-tools）
sudo dnf install -y net-tools
netstat -tunlp
# 查看指定端口（如 SSH 22）
netstat -tunlp | grep 22
# ss 为内置命令，功能更轻量
ss -tunlp
# 查看某端口被哪个进程占用
ss -tunlp | grep 8080
```
【此处放置截图：netstat -tunlp 与 ss -tunlp 输出】

## 故障模拟：端口被占用（独立排查）

### 场景
启动服务 A 占用 8080 端口后，再尝试启动服务 B 绑定同一端口，出现 `Address already in use`。

### 模拟步骤

```bash
# (~/shell_test 目录执行)
# 1. 用一个 python 简易 HTTP 服务模拟"服务 A"占用 8080 端口
python3 -m http.server 8080 &
# 2. 再启动第二个，模拟"服务 B"绑定同端口 → 预期报错
python3 -m http.server 8080
# 3. 确认服务 A 的 PID
ss -tunlp | grep 8080
# 4. 终止占用进程（-9 强制）
kill -9 <上一步查到的 PID>
# 5. 验证端口已释放，可重新绑定
ss -tunlp | grep 8080
python3 -m http.server 8080 &
```
【此处放置截图：报错 Address already in use 现象】
【此处放置截图：ss 查 PID → kill → 端口释放全过程】

### 排障要点（避坑）
1. 普通用户监听 1024 以下端口会报 `Permission denied`，练习用 8080 等高位端口。
2. `ss -tunlp` 的 `-p` 显示进程，普通用户可能看不到他人进程，必要时加 `sudo`。
3. kill 后务必用 `ss -tunlp | grep 8080` 二次确认端口真正释放，不要凭感觉。

## 最终产出：端口冲突故障解决流程文档

在 `~/shell_test/产出文档/` 下新建 `01_端口冲突故障解决流程.md`，按以下框架记录（截图使用上面占位符位置的实拍图）：

```markdown
# 端口冲突故障解决流程

## 一、故障现象
（描述：启动服务提示 Address already in use，端口 8080 无法绑定）

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

---

# 模块二（8.5）：磁盘管理与日志排查

## 学习目标
掌握磁盘使用情况查看（df/du）、设备挂载查看（lsblk）；掌握 grep 过滤日志；能独立完成「磁盘爆满」故障的定位与处理。

## 对应视频选集
- 041_尚硅谷_Linux 实操篇_磁盘分区介绍
- 042_尚硅谷_Linux 实操篇_Linux 分区
- 043_尚硅谷_Linux 实操篇_给 Linux 添加一块新硬盘
- 044_尚硅谷_Linux 实操篇_磁盘查询实用指令

## 实操命令

### 1. 磁盘使用情况（df）

```bash
# (~/shell_test 目录执行)
# 查看文件系统整体使用情况（人性化单位）
df -h
# 只看根分区
df -h /
# 查看 inode 使用情况（小文件过多会耗尽 inode）
df -i
```
【此处放置截图：df -h 输出】

### 2. 目录占用空间（du）

```bash
# (~/shell_test 目录执行)
# 查看当前目录总占用
du -sh .
# 查看一级子目录占用并从大到小排序
du -sh * | sort -rh
# 只看指定目录
du -sh ~/shell_test/logs
```
【此处放置截图：du -sh * | sort -rh 输出】

### 3. 设备挂载查看（lsblk）

```bash
# (~/shell_test 目录执行)
# 查看块设备树（磁盘、分区、挂载点）
lsblk
# 查看挂载详情（含 UUID）
sudo blkid
```
【此处放置截图：lsblk 输出】

### 4. 日志过滤（grep）

```bash
# (~/shell_test 目录执行)
# 先造一份练习日志（模拟系统日志格式）
mkdir -p ~/shell_test/logs
for i in $(seq 1 200); do
  if [ $((i % 10)) -eq 0 ]; then
    echo "$(date '+%F %T') ERROR 业务系统连接数据库超时" >> ~/shell_test/logs/app.log
  else
    echo "$(date '+%F %T') INFO  请求处理成功" >> ~/shell_test/logs/app.log
  fi
done
# 过滤 ERROR 行
grep "ERROR" ~/shell_test/logs/app.log
# 忽略大小写 + 显示行号
grep -in "error" ~/shell_test/logs/app.log
# 统计错误条数
grep -c "ERROR" ~/shell_test/logs/app.log
# 过滤指定时间段的日志
grep "$(date '+%F')" ~/shell_test/logs/app.log | grep "ERROR"
```
【此处放置截图：grep 过滤 ERROR 日志输出】

## 故障模拟：磁盘爆满

### 场景
写入大文件导致根分区或练习分区使用率接近 100%，服务写日志报 `No space left on device`。

### 模拟步骤（注意：用完立即清理，勿真把磁盘写满）

```bash
# (~/shell_test 目录执行)
# 1. 查看当前使用率（记录基线）
df -h /
# 2. 制造一个 500M 大文件模拟日志堆积
dd if=/dev/zero of=~/shell_test/logs/big.log bs=1M count=500
# 3. 再次查看，确认使用率上升
df -h /
# 4. 定位大文件（按占用排序）
du -sh ~/shell_test/logs/* | sort -rh
# 5. 确认无保留价值后删除
rm -f ~/shell_test/logs/big.log
# 6. 验证使用率回落
df -h /
```
【此处放置截图：磁盘使用率升高现象】
【此处放置截图：du 定位大文件 → rm 删除 → df 回落】

### 排障要点（避坑）
1. 磁盘爆满优先用 `du -sh * | sort -rh` 逐层定位，不要盲目 `rm`。
2. `df -h` 看空间，`df -i` 看 inode——小文件过多时 `df -h` 显示正常但报"磁盘满"，别漏查 inode。
3. 日志文件被进程占用时删除后空间不释放，需要 `> 文件` 清空或重启进程。

## 最终产出：磁盘、日志排查实操文档

在 `~/shell_test/产出文档/` 下新建 `02_磁盘日志排查实操.md`：

```markdown
# 磁盘、日志排查实操文档

## 一、磁盘使用查看命令汇总
- df -h：文件系统整体使用
- df -i：inode 使用
- du -sh * | sort -rh：定位大目录/大文件
- lsblk：设备与挂载点

## 二、日志过滤命令汇总
- grep -i：忽略大小写
- grep -c：统计条数
- grep 结合管道二次过滤

## 三、磁盘爆满故障演练记录
1. 现象：No space left on device
2. 定位：du -sh * | sort -rh → 找到 big.log
3. 处理：rm 删除 → df -h 验证
4. 避坑：inode 检查、被占用日志文件需清空而非删除

## 四、截图
（粘贴练习截图）
```

---

# 模块三（8.6）：SSH 远程连接、scp 传输与本周命令汇总

## 学习目标
掌握 ssh 远程登录、scp 文件上传下载；对本周（8.1–8.6）全部 Linux 命令做一次综合复盘，形成命令手册。

## 对应视频选集
- 013_尚硅谷_Linux 实操篇_远程登录 XShell5
- 014_尚硅谷_Linux 实操篇_远程上传下载文件 XFTP5

## 实操命令

### 1. SSH 远程连接

```bash
# (~/shell_test 目录执行)
# 从本机远程登录另一台主机（示例：登录 192.168.133.100，用户名 study）
ssh study@192.168.133.100
# 指定端口连接（SSH 默认 22，若改过端口）
ssh -p 2222 study@192.168.133.100
# 退出远程会话
exit
```
【此处放置截图：ssh 登录成功与 exit 退出】

### 2. scp 文件传输

```bash
# (~/shell_test 目录执行)
# 本地文件 → 远程主机（上传）
scp ~/shell_test/logs/app.log study@192.168.133.100:/home/study/shell_test/logs/
# 远程主机文件 → 本地（下载）
scp study@192.168.133.100:/home/study/shell_test/logs/app.log ./
# 递归传输整个目录
scp -r ~/shell_test/logs study@192.168.133.100:/home/study/shell_test/
```
【此处放置截图：scp 上传/下载成功输出】

### 排障要点（避坑）
1. ssh/scp 需要目标机开启 sshd 服务：`sudo systemctl status sshd`。
2. 首次连接会提示确认主机指纹，输入 `yes` 回车。
3. 连接被拒绝时先排查：防火墙（`sudo systemctl status firewalld`）、IP 是否可达（`ping`）、sshd 是否启动。

## 最终产出：本周全部 Linux 命令汇总文档

在 `~/shell_test/产出文档/` 下新建 `03_本周Linux命令汇总.md`，按类别汇总本周所有命令：

```markdown
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
- ping / ifconfig(ip addr) / ssh / scp

## 五、其他实用
- date / cal / history / ln / find / locate / grep

## 六、实操截图
（本周练习的关键截图）
```

---

# 模块四（8.8）：systemctl 服务管理与开机自启

## 学习目标
掌握 systemd 服务管理（start/stop/restart/status/enable/disable）；理解系统运行级别；能对服务启动失败独立排障。

## 对应视频选集
- 050_尚硅谷_Linux 实操篇_进程管理 服务管理
- 022_尚硅谷_Linux 实操篇_实用指令 运行级别和找回 root 密码

## 实操命令

### 1. 服务基本管理

```bash
# (~/shell_test 目录执行)
# 查看服务状态
systemctl status sshd
# 停止/启动/重启服务
sudo systemctl stop sshd
sudo systemctl start sshd
sudo systemctl restart sshd
# 重新加载配置（修改配置文件后）
sudo systemctl reload sshd
# 查看所有已启动服务
systemctl list-units --type=service --state=running
```
【此处放置截图：systemctl status sshd 输出】

### 2. 开机自启配置

```bash
# (~/shell_test 目录执行)
# 设置开机自启
sudo systemctl enable sshd
# 取消开机自启
sudo systemctl disable sshd
# 查看某服务自启状态
systemctl is-enabled sshd
# 查看所有开机自启服务
systemctl list-unit-files --type=service | grep enabled
```
【此处放置截图：enable/disable 与 is-enabled 输出】

### 3. 运行级别

```bash
# (~/shell_test 目录执行)
# 查看当前默认运行级别（target）
systemctl get-default
# 切换到多用户命令行模式（等价于老 runlevel 3）
sudo systemctl set-default multi-user.target
# 切换到图形界面模式（老 runlevel 5）
sudo systemctl set-default graphical.target
# 查看当前处于哪个 target
systemctl list-units --type=target | grep -E "multi-user|graphical"
```
【此处放置截图：get-default 与 set-default 输出】

## 故障模拟：服务启动失败排障

### 场景
修改 sshd 配置后 `systemctl restart sshd` 失败，需独立排查并恢复。

### 模拟步骤

```bash
# (~/shell_test 目录执行)
# 1. 故意改坏配置（注释掉 Port 行制造语法问题）
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "Port 2222" | sudo tee -a /etc/ssh/sshd_config > /dev/null
# 2. 重启服务 → 预期失败
sudo systemctl restart sshd
# 3. 查看失败原因
systemctl status sshd
# 4. 查看详细错误日志
journalctl -u sshd --no-pager | tail -20
# 5. 用配置文件检查命令定位问题
sudo sshd -t
# 6. 修复（恢复备份）并重启
sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
sudo systemctl restart sshd
# 7. 确认恢复正常
systemctl status sshd
```
【此处放置截图：restart 失败报错】
【此处放置截图：sshd -t 检查与修复后恢复正常】

### 排障要点（避坑）
1. `systemctl status` 只能看到失败原因的一行摘要，详细看 `journalctl -u 服务名`。
2. 修改关键服务（sshd）配置前务必备份；改完先 `sshd -t` 语法检查再重启。
3. 远程操作 sshd 时改错配置可能导致断连，务必保留一个本地/其他会话兜底。

## 最终产出：服务管理操作笔记

在 `~/shell_test/产出文档/` 下新建 `04_服务管理操作笔记.md`，记录 systemctl 常用操作、开机自启配置、运行级别切换及本次排障全过程（含截图）。

---

# 模块五（8.9）：crontab 定时任务

## 学习目标
掌握 crontab 定时任务配置（分时日月周）；掌握定时任务日志查看与权限报错处理；落地「定时清理日志」任务。

## 对应视频选集
- 039_尚硅谷_Linux 实操篇_任务调度基本说明
- 040_尚硅谷_Linux 实操篇_任务调度应用实例

## 实操命令

### 1. crontab 基本操作

```bash
# (~/shell_test 目录执行)
# 编辑当前用户定时任务（首次选择编辑器选 vim）
crontab -e
# 查看当前用户定时任务
crontab -l
# 删除当前用户全部定时任务
crontab -r
# 查看系统级任务（root）
sudo crontab -l
```
【此处放置截图：crontab -l 输出】

### 2. 时间表达式速查

| 表达式 | 含义 |
|---|---|
| `* * * * *` | 每分钟 |
| `*/5 * * * *` | 每 5 分钟 |
| `0 2 * * *` | 每天 2 点 |
| `30 23 * * 0` | 每周日 23:30 |
| `0 1 1 * *` | 每月 1 日 1 点 |

## 实操：搭建定时清理日志任务

### 第 1 步：编写清理脚本

```bash
# (~/shell_test 目录执行)
# 建脚本目录并编写清理脚本
mkdir -p ~/shell_test/scripts
vim ~/shell_test/scripts/cleanup_logs.sh
```

`cleanup_logs.sh` 内容：

```bash
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

```bash
# (~/shell_test 目录执行)
# 第 2 步：加执行权限并测试运行
chmod +x ~/shell_test/scripts/cleanup_logs.sh
~/shell_test/scripts/cleanup_logs.sh
# 第 3 步：造一些 8 天前的旧日志再测试
touch -d "8 days ago" ~/shell_test/logs/old1.log ~/shell_test/logs/old2.log
~/shell_test/scripts/cleanup_logs.sh
ls ~/shell_test/logs/
```
【此处放置截图：脚本测试运行与旧日志被清理结果】

### 第 3 步：配置定时任务

```bash
# (~/shell_test 目录执行)
# 编辑定时任务：每天凌晨 2 点执行清理
crontab -e
# 添加一行（注意 crontab 中需用绝对路径）
0 2 * * * /home/study/shell_test/scripts/cleanup_logs.sh
# 验证
crontab -l
```
【此处放置截图：crontab -e 添加任务与 crontab -l 验证】

## 故障模拟：定时任务不执行/权限报错

### 场景
任务到点未执行，或日志中报 `Permission denied` / `command not found`。

### 排查流程

```bash
# (~/shell_test 目录执行)
# 1. 查看任务是否在列表中
crontab -l
# 2. 查看系统 cron 日志（是否有执行记录、报错）
sudo tail -50 /var/log/cron
# 3. 常见原因检查：
#    - 脚本没有执行权限 → chmod +x
#    - 脚本内用了相对路径 → 改为绝对路径
#    - 环境变量缺失（cron 环境极简，PATH 只有 /usr/bin:/bin）
#    - 脚本首行缺 #!/bin/bash
# 4. 手动用 cron 环境跑一次验证
/bin/bash /home/study/shell_test/scripts/cleanup_logs.sh
```
【此处放置截图：/var/log/cron 查看执行记录】

### 排障要点（避坑）
1. crontab 里的命令必须用绝对路径，环境变量（PATH）是精简的，脚本内也尽量用绝对路径。
2. 脚本没有执行权限会静默失败，务必 `chmod +x`。
3. 排查顺序：`crontab -l` 看配置 → `/var/log/cron` 看执行 → 手动执行看脚本本身。
4. 输出默认通过邮件发送（本地无邮件服务则丢弃），调试期把输出重定向到日志文件。

## 最终产出：搭建定时清理日志任务
完成脚本 `cleanup_logs.sh` + crontab 配置，验证任务可执行，并将操作过程记录到 `05_定时清理日志任务.md`（含脚本、crontab 配置、执行验证截图、避坑点）。

---

# 模块六（8.10）：Shell 基础语法（变量、判断 if）+ 批量过滤政务系统日志

## 学习目标
掌握 Shell 脚本入门、系统/自定义变量、位置参数与预定义变量、运算符、条件判断、if 语句；编写第一个可交付脚本：批量过滤政务系统日志。

## 对应视频选集（Shell 专项 BV1hW41167NW）
- 01_尚硅谷_Shell_课程介绍
- 02_尚硅谷_Shell_概述
- 03_尚硅谷_Shell_解析器
- 04_尚硅谷_Shell_HelloWorld案例
- 05_尚硅谷_Shell_多命令操作案例
- 06_尚硅谷_Shell_系统变量和自定义变量案例
- 07_尚硅谷_Shell_$n案例
- 08_尚硅谷_Shell_$#案例
- 09_尚硅谷_Shell_$*$@案例
- 10_尚硅谷_Shell_$?案例

## 实操命令

### 1. HelloWorld 与解析器

```bash
# (~/shell_test 目录执行)
# 查看当前 Shell 解析器
echo $SHELL
# 查看系统可用解析器
cat /etc/shells
# 编写第一个脚本
vim ~/shell_test/scripts/hello.sh
```

`hello.sh`：

```bash
#!/bin/bash
echo "Hello World!"
```

```bash
# (~/shell_test 目录执行)
chmod +x ~/shell_test/scripts/hello.sh
~/shell_test/scripts/hello.sh
# 或直接调用解析器执行（无需执行权限）
bash ~/shell_test/scripts/hello.sh
```
【此处放置截图：hello.sh 运行输出】

### 2. 变量

```bash
# (~/shell_test 目录执行)
# 系统变量（部分）：$HOME $USER $SHELL $PWD $PATH
echo $HOME $USER $SHELL $PWD
# 自定义变量：变量名=值（等号两边不能有空格）
name=study
echo $name
# 撤销变量
unset name
# 只读变量（不可撤销）
readonly version=1.0
echo $version
```
【此处放置截图：系统变量与自定义变量输出】

### 3. 位置参数与预定义变量

```bash
# (~/shell_test 目录执行)
# $n：第 n 个参数（$0 是脚本名，$1-$9 是参数，10+ 用 ${10}）
# $#：参数个数  $*：所有参数（整体）  $@：所有参数（分开）  $?：上条命令退出码
cat > ~/shell_test/scripts/args.sh << 'EOF'
#!/bin/bash
echo "脚本名: $0"
echo "第1个参数: $1"
echo "第2个参数: $2"
echo "参数个数: $#"
echo "所有参数(\$*): $*"
echo "所有参数(\$@): $@"
echo "上条命令退出码: $?"
EOF
chmod +x ~/shell_test/scripts/args.sh
~/shell_test/scripts/args.sh hello shell
```
【此处放置截图：args.sh 带参运行输出】

### 4. 运算符与条件判断

```bash
# (~/shell_test 目录执行)
# 整数运算（推荐 $(( ))）
echo $(( 3 + 5 ))
a=10; b=3
echo $(( a * b ))
# 条件判断 [ ]
[ 10 -gt 5 ] && echo "10大于5"
# 字符串判断
[ "$name" = "study" ] && echo "相等"
# 文件判断
[ -f /etc/passwd ] && echo "文件存在"
[ -d ~/shell_test ] && echo "目录存在"
```
【此处放置截图：运算与条件判断输出】

### 5. if 判断

```bash
# (~/shell_test 目录执行)
cat > ~/shell_test/scripts/if_demo.sh << 'EOF'
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
EOF
chmod +x ~/shell_test/scripts/if_demo.sh
~/shell_test/scripts/if_demo.sh 50
~/shell_test/scripts/if_demo.sh 150
~/shell_test/scripts/if_demo.sh
```
【此处放置截图：if_demo.sh 三种情况输出】

## 最终产出：第一个 Shell 脚本（批量过滤政务系统日志）

编写 `~/shell_test/scripts/filter_gov_log.sh`，功能：接收日志文件路径参数，过滤出 ERROR 级别日志，支持按错误关键字统计，输出结果到指定文件。完成后上传 GitHub 仓库 `Alice5997/linux-study-notes`。

`filter_gov_log.sh`：

```bash
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

```bash
# (~/shell_test 目录执行)
# 测试脚本
chmod +x ~/shell_test/scripts/filter_gov_log.sh
~/shell_test/scripts/filter_gov_log.sh ~/shell_test/logs/app.log
~/shell_test/scripts/filter_gov_log.sh ~/shell_test/logs/app.log "超时"
```
【此处放置截图：filter_gov_log.sh 运行输出与结果文件】

### GitHub 上传步骤

```bash
# (~/shell_test 目录执行)
# 1. 初始化仓库（若还未 clone 过）
cd ~/shell_test
git init
# 2. 配置用户信息（一次性）
git config --global user.name "Alice5997"
git config --global user.email "你的GitHub邮箱"
# 3. 添加并提交脚本
git add scripts/filter_gov_log.sh
git commit -m "添加批量过滤政务系统日志脚本"
# 4. 关联远程仓库并推送（仓库: Alice5997/linux-study-notes）
git remote add origin https://github.com/Alice5997/linux-study-notes.git
git push -u origin main
```
【此处放置截图：git commit 与 git push 成功输出】

---

# 模块七（8.11）：Shell 循环 for/while + 脚本读取本地文档批量处理

## 学习目标
掌握 for 循环（列表方式/数值方式）、while 循环、read 读取输入；编写脚本读取本地文档批量处理。

## 对应视频选集（Shell 专项 BV1hW41167NW）
- 11_尚硅谷_Shell_运算符
- 12_尚硅谷_Shell_条件判断案例
- 13_尚硅谷_Shell_回顾
- 14_尚硅谷_Shell_if案例
- 15_尚硅谷_Shell_Case案例
- 16_尚硅谷_Shell_For1案例
- 17_尚硅谷_Shell_For2案例
- 18_尚硅谷_Shell_While案例
- 19_尚硅谷_Shell_Read案例
- 20_尚硅谷_Shell_BaseName&DirName案例

## 实操命令

### 1. for 循环（两种写法）

```bash
# (~/shell_test 目录执行)
# 写法一：遍历列表
for fruit in apple banana orange; do
    echo "水果: $fruit"
done
# 写法二：数值循环（C 语言风格）
for ((i=1; i<=5; i++)); do
    echo "第 $i 次循环"
done
# 遍历文件列表
for f in ~/shell_test/logs/*.log; do
    echo "处理文件: $f"
done
```
【此处放置截图：for 循环三种方式输出】

### 2. while 循环

```bash
# (~/shell_test 目录执行)
# 计数循环
i=1
while [ $i -le 5 ]; do
    echo "计数: $i"
    ((i++))
done
# 读取文件每一行（方式一：while read）
while read line; do
    echo "读取到: $line"
done < ~/shell_test/logs/app.log
```
【此处放置截图：while 循环与逐行读文件输出】

### 3. read 读取输入

```bash
# (~/shell_test 目录执行)
read -p "请输入你的名字: " username
echo "你好, $username"
# 读取多个变量
read -p "输入姓名和年龄(空格分隔): " name age
echo "姓名:$name 年龄:$age"
```
【此处放置截图：read 交互输入输出】

### 4. basename / dirname

```bash
# (~/shell_test 目录执行)
# 取出文件名
basename /home/study/shell_test/scripts/filter_gov_log.sh
# 取出目录
dirname /home/study/shell_test/scripts/filter_gov_log.sh
```
【此处放置截图：basename/dirname 输出】

## 最终产出：循环处理文档脚本

编写 `~/shell_test/scripts/process_logs_batch.sh`：遍历 `logs` 目录下所有 `.log` 文件，逐个统计 ERROR 条数并汇总报告。完成后上传 GitHub。

`process_logs_batch.sh`：

```bash
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

```bash
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

```bash
# GitHub 上传（复用模块六的流程）
cd ~/shell_test
git add scripts/process_logs_batch.sh
git commit -m "添加循环处理日志脚本"
git push -u origin main
```
【此处放置截图：push 成功输出】

---

# 模块八（8.12）：Shell 函数、传参实操 + 脚本报错独立排障

## 学习目标
掌握自定义函数、函数传参与返回值、函数内变量作用域；掌握 cut/sed/awk/sort 文本处理工具；能对脚本运行报错独立排障（bash -x 调试）。

## 对应视频选集（Shell 专项 BV1hW41167NW）
- 21_尚硅谷_Shell_自定义函数案例
- 22_尚硅谷_Shell_Cut案例
- 23_尚硅谷_Shell_Sed案例
- 24_尚硅谷_Shell_Awk案例
- 25_尚硅谷_Shell_Sort案例
- 26_尚硅谷_Shell_企业真题讲解

## 实操命令

### 1. 自定义函数与传参

```bash
# (~/shell_test 目录执行)
cat > ~/shell_test/scripts/func_demo.sh << 'EOF'
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
EOF
chmod +x ~/shell_test/scripts/func_demo.sh
~/shell_test/scripts/func_demo.sh
```
【此处放置截图：函数定义调用与局部/全局变量输出】

### 2. 文本处理工具

```bash
# (~/shell_test 目录执行)
# cut：按列提取（-d 分隔符 -f 列号）
echo "study:1000:1000" | cut -d ":" -f 1
grep "study" /etc/passwd | cut -d ":" -f 1,3
# sort：排序
echo -e "3\n1\n2" | sort -n
# awk：按列处理
awk -F ":" '{print $1, $3}' /etc/passwd | head -5
# sed：文本替换/删除（-i 直接改文件）
sed -i 's/old/new/g' ~/shell_test/logs/app.log
# 组合应用：提取 ERROR 日志中的时间列并排序
grep "ERROR" ~/shell_test/logs/app.log | awk '{print $1, $2}' | sort | uniq -c
```
【此处放置截图：cut/sort/awk/sed 输出】

## 故障模拟：脚本运行报错独立排障

### 场景
脚本运行报 `command not found`、`syntax error`、`No such file or directory` 等错误，需独立定位并修复。

### 排查流程

```bash
# (~/shell_test 目录执行)
# 1. 用 bash -n 做语法检查（只查语法不执行）
bash -n ~/shell_test/scripts/filter_gov_log.sh && echo "语法OK"
# 2. 用 bash -x 跟踪执行（显示每步展开的命令，最常用调试手段）
bash -x ~/shell_test/scripts/filter_gov_log.sh ~/shell_test/logs/app.log
# 3. 常见错误对照：
#    - command not found → 命令拼写错 / 未加 #!/bin/bash
#    - syntax error → 少了 then/fi/done、if 条件格式错
#    - No such file → 相对路径问题，改绝对路径
#    - Permission denied → chmod +x
# 4. 逐段隔离：把脚本拆开逐步执行，或用 echo 打点
```
【此处放置截图：bash -x 跟踪输出定位错误】

### 排障要点（避坑）
1. `bash -n` 查语法、`bash -x` 跟踪执行，是脚本排障两件套。
2. `if [ ]` 判断中 `[` 后、`]` 前必须有空格，`=` 两边不能有空格。
3. 变量加引号 `"$var"` 防止未定义或含空格时报错。

## 最终产出：封装日志处理函数脚本

编写 `~/shell_test/scripts/log_funcs.sh`：把日志过滤、统计、备份封装成函数库，供其他脚本调用。上传 GitHub。

`log_funcs.sh`：

```bash
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

```bash
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

```bash
# GitHub 上传
cd ~/shell_test
git add scripts/log_funcs.sh
git commit -m "添加日志处理函数库"
git push -u origin main
```
【此处放置截图：push 成功输出】

---

# 模块九（8.13）：综合复盘 + 完整政务日志自动化处理脚本

## 学习目标
对 Linux 服务管理、定时任务、Shell 编程做全套复盘；综合运用变量、if、for/while、函数、crontab，编写完整的政务日志自动化处理脚本。

## 对应视频选集
回看薄弱章节（建议回看 050 服务管理、039/040 任务调度、Shell 专项 01–26 集中薄弱部分）。

## 最终产出：完整自动化脚本

编写 `~/shell_test/scripts/gov_log_auto.sh`，实现政务日志自动化处理闭环：
1. 检查日志目录是否存在（if + 文件判断）
2. 批量过滤 ERROR/WARN 日志并生成日报（for 循环 + 函数）
3. 统计各类错误数量并追加到汇总报告（awk/sort）
4. 自动备份当日日志（函数 + 时间戳）
5. 清理 7 天前旧日志（find）
6. 配合 crontab 每天定时执行

`gov_log_auto.sh`：

```bash
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

```bash
# (~/shell_test 目录执行)
# 测试运行
chmod +x ~/shell_test/scripts/gov_log_auto.sh
~/shell_test/scripts/gov_log_auto.sh
# 配置每日 1 点自动执行
crontab -e
# 添加：0 1 * * * /home/study/shell_test/scripts/gov_log_auto.sh
crontab -l
# 验证 crontab 执行（第二天检查 /var/log/cron 与 reports 目录）
```
【此处放置截图：gov_log_auto.sh 运行输出与报告内容】
【此处放置截图：crontab -l 显示每日任务】

```bash
# GitHub 上传
cd ~/shell_test
git add scripts/gov_log_auto.sh
git commit -m "添加政务日志自动化处理完整脚本"
git push -u origin main
```
【此处放置截图：push 成功输出】

---

# 模块十（8.14）：全部知识点复盘 + 故障模拟 + CAIE 刷题 + 求职投递

## 学习目标
全量复盘两周知识点；模拟「服务启动失败」「定时任务失效」两类典型故障独立排查；完成 CAIE 一级第二章刷题；BOSS 直聘投递 6 个岗位。

## 故障模拟一：服务启动失败

```bash
# (~/shell_test 目录执行)
# 场景：sshd 启动失败
# 1. 查看状态与错误
systemctl status sshd
journalctl -u sshd --no-pager | tail -30
# 2. 检查配置文件
sudo sshd -t
# 3. 修复（回滚备份 / 修正配置）
# 4. 重启并验证
sudo systemctl restart sshd
systemctl is-active sshd
```
【此处放置截图：服务启动失败排查全过程】

## 故障模拟二：定时任务失效

```bash
# (~/shell_test 目录执行)
# 场景：crontab 任务到点未执行
# 1. 确认任务存在
crontab -l
# 2. 查 cron 执行日志
sudo tail -100 /var/log/cron
# 3. 检查脚本权限与语法
ls -l ~/shell_test/scripts/*.sh
bash -n ~/shell_test/scripts/gov_log_auto.sh
# 4. 手动执行验证
bash ~/shell_test/scripts/gov_log_auto.sh
# 5. 修复后重新测试（可临时把时间改成 1 分钟后验证）
crontab -e
```
【此处放置截图：定时任务失效排查全过程】

## 最终产出：故障处理完整文档 + 投递记录

在 `~/shell_test/产出文档/` 下新建 `06_故障处理完整文档.md`，记录两个故障的完整排错过程（现象 → 排查 → 定位 → 解决 → 避坑），格式统一：

```markdown
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

## 附录：CAIE 一级第二章刷题记录
（记录刷题正确率、错题复盘）

## 附录：BOSS 投递记录（6 岗）
| 公司 | 岗位 | 投递日期 | 状态 |
|---|---|---|---|
| 待填 | 待填 | 待填 | 待填 |
```

---

# 产出落地总清单（红框要求）

| # | 产出物 | 存放/落地位置 | 完成状态 |
|---|---|---|---|
| 01 | 端口冲突故障解决流程 | `~/shell_test/产出文档/01_端口冲突故障解决流程.md` | ☐ |
| 02 | 磁盘、日志排查实操文档 | `~/shell_test/产出文档/02_磁盘日志排查实操.md` | ☐ |
| 03 | 本周全部 Linux 命令汇总文档 | `~/shell_test/产出文档/03_本周Linux命令汇总.md` | ☐ |
| 04 | 服务管理操作笔记 | `~/shell_test/产出文档/04_服务管理操作笔记.md` | ☐ |
| 05 | 定时清理日志任务（脚本+crontab） | `~/shell_test/scripts/cleanup_logs.sh` + crontab | ☐ |
| 06 | 第一个 Shell 脚本（过滤政务日志）→ GitHub | `~/shell_test/scripts/filter_gov_log.sh` | ☐ |
| 07 | 循环处理文档脚本 → GitHub | `~/shell_test/scripts/process_logs_batch.sh` | ☐ |
| 08 | 封装日志处理函数脚本 | `~/shell_test/scripts/log_funcs.sh` | ☐ |
| 09 | 完整政务日志自动化脚本 → GitHub | `~/shell_test/scripts/gov_log_auto.sh` | ☐ |
| 10 | 故障处理完整文档 | `~/shell_test/产出文档/06_故障处理完整文档.md` | ☐ |
| 11 | CAIE 一级第二章刷题记录 | 附于 06 文档附录 | ☐ |
| 12 | BOSS 投递 6 岗记录 | 附于 06 文档附录 | ☐ |

**GitHub 仓库**：`Alice5997/linux-study-notes`（公开仓库，Linux 全套笔记与脚本统一归档于此）

**归档规范**：全部产出文档为 Markdown，统一归档至 Obsidian 知识库 `01_Linux学习` 目录；每个脚本与文档附带实际截图。

---

*笔记整理完成：学习模块均严格对齐视频选集标题，实操命令适配 CentOS Stream9 / study 用户 / ~/shell_test 环境，产出按红框要求逐项落地。*
