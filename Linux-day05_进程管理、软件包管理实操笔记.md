# Linux_day05_进程管理、RPM、YUM 软件包实操笔记

## 基础信息：

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh "autolink")

2、今日观看选集：048、049、050、051、052、053

- 048：尚硅谷_Linux 实操篇_进程管理 进程介绍和静态查看
- 049：尚硅谷_Linux 实操篇_进程管理 终止进程
- 050：尚硅谷_Linux 实操篇_进程管理 服务管理
- 051：尚硅谷_Linux 实操篇_进程管理 监控服务
- 052：尚硅谷_Linux 实操篇_RPM 包管理
- 053：尚硅谷_Linux 实操篇_YUM
    
3、系统环境：CentOS Stream9，普通用户 study
    
4、今日练习测试目录、文件等：
    
    当日总目录：~/day05_test01
    
    测试日志文件：day05_monitor_log.txt
    
    后台测试进程：sleep 300
    
    测试软件：tree、firefox
    
5、使用规则：所有命令手动输入，禁止复制；每步执行完成后，在笔记对应标记处插入终端截图

## 一、初始化练习目录（最先执行）

bash

```
# 创建当日专属练习目录并进入
mkdir -p ~/day05_test01
cd ~/day05_test01
# 生成资源监控日志文件
touch day05_monitor_log.txt
echo "进程、软件包实操日志" > day05_monitor_log.txt
```

【此处放置截图：ls 查看目录初始化结果】
![[Pasted image 20260805154154.png]]

## 模块 1 进程介绍和静态查看（对应 048 集）

### 核心知识点

1. 程序：硬盘上静态二进制文件；进程：程序运行后产生动态实例，系统资源调度最小单位
2. 前台进程：占用终端窗口；后台进程：命令末尾加`&`后台运行，不阻塞终端
3. `ps aux`：静态快照查看全部进程，字段含义：用户、PID、CPU 占用、内存占用、运行时间、执行命令
4. 管道`| grep 关键词`过滤指定进程；`pstree`树形展示父子进程依赖关系

（旧版本指令）
![[Pasted image 20260805153113.png]]
![[Pasted image 20260805153707.png]]
![[Pasted image 20260805153326.png]]

![[Pasted image 20260805160722.png]]
![[Pasted image 20260805160635.png]]
### 实操命令

bash

```
# 1.创建后台休眠测试进程（任意目录执行）
sleep 300 &
# 2.查看系统所有进程快照（任意目录执行）
ps aux
# 3.过滤sleep进程，获取PID编号（任意目录执行）
ps aux | grep sleep
# 4.树形展示系统全部进程（任意目录执行）
pstree
```
【此处放置截图：ps aux、pstree 执行输出界面】
![[Pasted image 20260805154435.png]]
![[Pasted image 20260805154455.png]]
## 模块 2 终止进程（对应 049 集）

### 核心知识点

1. kill 默认发送 15 号 SIGTERM 信号：优雅关闭，进程可保存数据、释放资源，优先使用
2. kill -9 发送 SIGKILL 强制杀死：进程无收尾流程，程序卡死、无响应时才使用
3. killall：按进程名称批量终止所有同名进程，无需手动查询 PID

![[Pasted image 20260805155506.png]]
旧版指令
![[Pasted image 20260805155835.png]]
![[Pasted image 20260805160049.png]]



### 实操命令

bash

```
# 1.优雅终止sleep进程，替换为自己查到的PID（任意目录执行）
kill 进程PID
# 重新创建后台进程用于强制杀死测试（任意目录执行）
sleep 300 &
# 2.强制卡死进程，替换为自己查到的PID（任意目录执行）
kill -9 进程PID
# 3.根据进程名批量杀死全部sleep进程（任意目录执行）
killall sleep
```

【此处放置截图：kill、kill -9、killall 执行效果】
![[Pasted image 20260805161202.png]]
## 模块 3 服务管理（对应 050 集）

### 核心知识点

1. ==CentOS7/9 统一使用`systemctl`管理系统后台服务==，替代旧 service 命令
2. 常用服务操作：start 启动、stop 停止、restart 重启、status 查看运行状态
3. enable：设置开机自启；disable：取消开机自启
4. 系统服务操作必须加 sudo 提权，普通用户无权限修改服务状态
5. 服务运行级别有0-6种级别，常用的是是3和5
![[Pasted image 20260805164111.png]]
![[Pasted image 20260805164009.png]]
![[Pasted image 20260805174606.png]]
  ![[Pasted image 20260805174633.png]]
### 实操命令

bash

```
# 1.列出系统所有可用服务单元（任意目录执行）
systemctl list-unit-files --type=service
# 2.以防火墙firewalld为实操案例（任意目录执行）
sudo systemctl start firewalld
sudo systemctl status firewalld
sudo systemctl restart firewalld
sudo systemctl disable firewalld
sudo systemctl enable firewalld
```

【此处放置截图：systemctl status firewalld 状态详情】
![[Pasted image 20260805180047.png]]
![[Pasted image 20260805180222.png]]


## 模块 4 监控服务（对应 051 集）

### 核心知识点

1. top：动态实时监控 CPU、内存、进程负载，交互快捷键：==q 退出、M 按内存排序、P 按 CPU 排序
2. uptime：查看开机时长、1/5/15 分钟系统平均负载（==超过0.7建议更换硬件设备==）
3. free -h：人性化 GB/MB 单位查看物理内存、交换分区占用
4. 负载判断：CPU 核心数为阈值，负载数值大于核心代表系统过载卡顿

![[Pasted image 20260805210628.png]]
![[Pasted image 20260805210825.png]]

![[Pasted image 20260805210844.png]]
![[Pasted image 20260805210946.png]]

5.查看系统网络情况netstat
语法：netstat[选项]
      netstat -anp
      -an 按一定顺序排列输出
      -p显示哪个进程在调用
![[Pasted image 20260805211734.png]]
![[Pasted image 20260805211452.png]]
![[Pasted image 20260805211927.png]]

![[Pasted image 20260805212603.png]]


### 实操命令

bash

```
# 1.实时资源监控界面（任意目录执行）
top
# 2.查看开机时间与系统平均负载（任意目录执行）
uptime
# 3.查看内存、交换分区使用情况（任意目录执行）
free -h
```
【此处放置截图：top 监控界面、uptime+free -h 输出截图】
![[Pasted image 20260805212038.png]]
![[Pasted image 20260805212300.png]]

## 模块 5 RPM 包管理（对应 052 集）

### 核心知识点

1. RPM：RedHat 离线软件包工具，仅本地安装，**无法自动解决软件依赖**
2. 高频参数：
    
    - -qa：查询全部已安装软件
    - -qi：查看软件详细信息
    - -e：卸载软件
    - -ivh：本地 rpm 包安装，显示进度条
    
3. 缺点：缺少依赖时直接报错，需要手动逐层下载安装依赖包
视频说明：
![[Pasted image 20260805213121.png]]
![[Pasted image 20260805213551.png]]
![[Pasted image 20260805214003.png]]
![[Pasted image 20260805214120.png]]
==分页查看用 rpm -qa  | more==

![[Pasted image 20260805214358.png]]

卸载之后安装
![[Pasted image 20260805214541.png]]
1)演示安装firefox.浏览器
旧版本：
步骤先找到firefox的安装rpm 包,你需要挂载上我们安装centos.的iso文件，然后到/media下去找rpm找。
![[Pasted image 20260805215005.png]]

### 实操命令

bash

收起收起

```
# 1.查询系统全部已安装rpm软件（任意目录执行）
rpm -qa
# 2.过滤查询火狐浏览器（任意目录执行）
rpm -qa | grep firefox
# 3.查看firefox安装详情（任意目录执行）
rpm -qi firefox
# 4.卸载软件，无依赖冲突直接执行（任意目录执行）
sudo rpm -e firefox
```
【此处放置截图：rpm 查询命令输出结果】
![[Pasted image 20260805213435.png]]


## 模块 6 YUM（对应 053 集）

### 核心知识点

1. YUM 基于 RPM，在线从官方软件仓库下载软件，**自动下载并补齐全部依赖**，==前提是可以联网==
2. ==高频操作：
	search 搜索
	install 安装
	remove 卸载
	list 查询
	update 系统更新==
3. -y 参数：==自动确认交互提示==，无需手动输入 yes
![[Pasted image 20260805220408.png]]


### 实操命令

bash

```
# 1.在线搜索工具软件（任意目录执行）
yum search tree
# 2.在线安装tree工具（任意目录执行）
sudo yum install tree -y
# 3.过滤查看已安装软件（任意目录执行）
yum list installed | grep tree
# 4.卸载tree工具（任意目录执行）
sudo yum remove tree -y
# 5.一键更新系统所有软件包，生产环境谨慎执行（任意目录执行）
sudo yum update
```

【此处放置截图：yum 安装、卸载执行完整日志】
![[Pasted image 20260805221526.png]]
![[Pasted image 20260805221600.png]]

![[Pasted image 20260805221625.png]]
![[Pasted image 20260805221642.png]]

## 补充：当日踩坑记录区域

1. ==kill -9 尽量不用，数据库、Web 服务强制杀死会丢失业务数据==
2. ==top 界面必须输入 q 退出，不能直接关闭终端残留进程==
3. ==rpm 离线安装极易报依赖错误，日常优先使用 yum 在线安装==
4. ==systemctl 管理系统服务必须加 sudo，普通用户无启停权限==
5. ==yum update 会升级内核与全部软件，服务器生产环境操作前备份==

## ✅当日自检清单

- [ ]  `&`后台运行程序，ps、pstree 查看、过滤进程
- [ ]  区分 kill 正常终止与 kill -9 强制杀死，会使用 killall 批量杀进程
- [ ]  systemctl 启停、查看、设置服务开机自启
- [ ]  top、uptime、free -h 看懂 CPU、内存、系统负载
- [x]  rpm 查询、卸载本地软件，清楚 RPM 无自动依赖的短板
- [x]  yum 搜索、安装、卸载软件，掌握 yum 自动解决依赖优势