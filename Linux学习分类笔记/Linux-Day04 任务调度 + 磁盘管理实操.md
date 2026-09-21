
# Linux 学习 - 第 4 天 任务调度 + 磁盘管理实操

## 基础信息

1. 课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh "autolink")
2. 今日严格对应观看选集（按顺序观看，标题完全匹配截图）
    
    039 实操篇 任务调度基本说明
    
    040 实操篇 任务调度应用实例
    
    041 实操篇 磁盘分区介绍
    
    042 实操篇 Linux 分区
    
    043 实操篇 给 Linux 添加一块新硬盘
    
    044 实操篇 磁盘查询实用指令
    
    ⚠️避坑标注：045-047 是网络配置内容，第四天完全不学，延后安排
3. 系统环境：CentOS Stream9，登录普通用户 study
4. 全局统一命名规范（和 day01/day02/day03 保持一致）
    
    当日总目录：day04_test01
    
    测试文件：day04_file01.txt、day04_file02.txt、day04_file03.txt
    
    测试目录：day04_dir01、day04_dir02
    
    衍生文件：day04_bak_xxx.txt、day04_time_log.txt
5. 使用规则：所有命令手动输入，禁止复制；每步执行完成后，在笔记对应标记处插入终端截图

## 一、初始化练习目录（最先执行）

bash

bash

```
# 创建第四天专属练习文件夹并进入
mkdir -p ~/day04_test01
cd ~/day04_test01

# 创建标准化测试文件、目录
touch day04_file01.txt day04_file02.txt day04_file03.txt
mkdir day04_dir01 day04_dir02

# 写入中文测试文本
echo "Linux第四天任务调度学习" > day04_file01.txt
echo "crontab定时备份实操" > day04_file02.txt
echo "磁盘分区挂载实操练习" > day04_file03.txt
```

【此处插入截图：初始化目录、文件执行结果 ls 输出】
![[Pasted image 20260804234202.png]]
## 二、模块 1 crond 任务调度（对应 039/040 集）

### 核心知识点

1. crond 是 Linux 内置定时任务服务，默认开机自启，每分钟扫描一次任务规则
2. 两类任务：系统级定时任务（日志轮转等系统自动维护）、用户级定时任务（crontab 自定义）
3. crontab 常用参数

bash

```
crontab -e   # 编辑当前用户定时任务
crontab -l   # 查看当前用户定时任务
crontab -r   # 清空当前用户所有定时任务（谨慎使用）
crontab -u 用户名 -l # 查看指定用户定时任务
```

4. 定时表达式格式：`分 时 日 月 周 执行命令/脚本`
![[Pasted image 20260805140507.png]]

5. crond 是 ==Linux 内置定时任务服务==，默认开机自启，每分钟扫描一次任务规则
6. 两类任务：系统级定时任务（日志轮转等系统自动维护）、用户级定时任务（crontab 自定义）
7. crontab 常用参数说明
![[Pasted image 20260804225233.png]]
![[Pasted image 20260804222158.png]]
![[Pasted image 20260804223032.png]]
![[Pasted image 20260804222559.png]]
![[Pasted image 20260804223227.png]]
![[Pasted image 20260804223307.png]]
![[Pasted image 20260804222953.png]]
![[Pasted image 20260804223433.png]]
![[Pasted image 20260804224004.png]]
![[Pasted image 20260804224315.png]]
![[Pasted image 20260804224717.png]]
![[Pasted image 20260804225038.png]]

### 补充实操命令（默认在～/day04_test01 目录执行，特殊路径单独标注）

bash

```
# 1.查看crond服务状态（家目录任意位置执行）
systemctl status crond
# 2.设置crond开机自启（家目录任意位置执行）
sudo systemctl enable crond
# 3.重启定时任务服务（家目录任意位置执行）
sudo systemctl restart crond

# 4.编写定时备份脚本（在 ~/day04_test01 目录执行）
vim day04_backup.sh
```

脚本 day04_backup.sh 写入内容：

bash

```
#!/bin/bash
cp /home/study/day04_test01/day04_file01.txt /home/study/day04_test01/day04_dir01/day04_bak_$(date +%Y%m%d_%H%M).txt
```

bash

```
# 5.赋予脚本执行权限（在 ~/day04_test01 目录执行）
chmod 755 day04_backup.sh

# 6.编辑定时任务（全局用户级命令，任意目录执行）
crontab -e
# 写入规则：每2分钟执行一次备份脚本
*/2 * * * * /home/study/day04_test01/day04_backup.sh

# 7.查看已添加的定时任务（任意目录执行）
crontab -l

# 8.新增定时写入时间日志任务（任意目录执行）
crontab -e
# 追加一行规则：每分钟写入时间日志
* * * * * date >> /home/study/day04_test01/day04_time_log.txt

# 9.查看定时生成的备份与日志文件（在 ~/day04_test01 目录执行）
ls day04_dir01
ls day04_time_log.txt
```

### 避坑提醒

1. 定时任务内文件、脚本必须写绝对路径，相对路径会执行失败
2. ==自定义脚本必须添加 x 执行权限==，否则定时无法运行
3. crontab -r 会一次性清空全部任务，删除单条任务请在 crontab -e 内手动删行
4. 定时表达式中日和周字段不要同时限定条件，容易产生执行冲突
    
    【此处插入截图：crontab -l 任务列表、定时生成备份文件、crond 服务状态输出】
![[Pasted image 20260804234855.png]]
![[Pasted image 20260804234910.png]]

## 三、模块 2 磁盘分区基础理论（对应 041 集）

### 核心知识点

1. 磁盘标识规则：/dev/sda 为第一块系统硬盘，/dev/sdb 为第二块新增硬盘；sda1、sda2 代表第一块硬盘不同分区
2. 分区类型：==主分区==（单硬盘==最多 4 个==）、==扩展分区==（占用 ==1 个主分区==位，可划分多个逻辑分区）
3. Linux 无 Windows 盘符概念，分区必须挂载到空目录才可读写使用，==根目录 / 为系统默认挂载点==
4. 磁盘使用完整流程：硬盘分区 → 格式化创建文件系统（xfs/ext4）→ 挂载目录使用
![[Pasted image 20260804225623.png]]

### 安全实操（仅查询，不修改系统默认配置，任意目录执行）

bash

```
# 查看系统已识别磁盘列表
lsblk
# 查看磁盘分区文件系统与UUID信息
lsblk -f
```
==lsblk（老师不离开）==
### 高危提醒

==严禁对系统盘 /dev/sda 执行分区修改操作，仅可操作后续新增的 /dev/sdb 硬盘==

【此处插入截图：lsblk、lsblk -f 初始磁盘信息输出】
![[Pasted image 20260804234950.png]]
## 四、模块 3 磁盘常用查询指令（对应 042/044 集）

### 核心知识点

1. lsblk：查看磁盘、分区、挂载点整体结构
2. df：查看已挂载分区容量使用率
3. du：统计单文件 / 指定目录实际磁盘占用大小

![[Pasted image 20260804230526.png]]
![[Pasted image 20260804230416.png]]
![[Pasted image 20260804231224.png]]
![[Pasted image 20260804231152.png]]
### 补充实操命令（默认在～/day04_test01 目录执行，特殊路径单独标注）

bash

```
# 1.查看全局磁盘容量占用（任意目录执行）
df -h
# 2.查看系统根分区占用情况（任意目录执行）
df -h /
# 3.统计当日练习目录总大小（在 ~/day04_test01 目录执行）
du -sh ~/day04_test01
# 4.统计家目录所有day04开头文件总大小（家目录~执行）
du -sh ~/day04_*
# 5.查看inode占用情况（任意目录执行）
df -i
# 6.查看所有分区UUID信息（任意目录执行）
blkid
# 7.查找家目录大于500M文件（家目录~执行）
find ~ -type f -size +500M -ls
```

### 实用技巧

-h 参数可将容量自动转为 G/M 友好单位；-s 参数只输出汇总总量，不遍历子文件

【此处插入截图：df -h、du 统计结果、df -i、blkid 命令输出】
![[Pasted image 20260804235457.png]]
## 五、模块 4 新增硬盘分区格式化 + 挂载实操（对应 043 集）

### 前置说明

VMware 虚拟机关机状态下添加一块虚拟硬盘，开机后系统识别为 /dev/sdb；所有分区操作任意目录执行，挂载目录提前创建

![[Pasted image 20260804235847.png]]
![[Pasted image 20260804235919.png]]
![[Pasted image 20260804235931.png]]
![[Pasted image 20260805000249.png]]
![[Pasted image 20260805000220.png]]
![[Pasted image 20260805000417.png]]


由于练习用的cetOS9版本镜像系统，所以这里添加硬盘不成功，使用==在线热添加硬盘==方式添加（系统启动状态下，网络适配器**保持==取消启动时连接**==）：
VMware 顶部菜单栏：虚拟机 → 设置 → 添加 → 硬盘 → 选之前的 10G 磁盘文件
1. 看 VMware 窗口顶部菜单栏，点击 **虚拟机 (M)** → 下拉选择 **设置**
2. 在弹出的虚拟机设置窗口，点右下角 **添加 (A)...**
3. 硬件向导：选择「硬盘」→下一步
4. 选择 **使用现有虚拟磁盘**，找到你之前创建好的 10G 磁盘 vmdk 文件，确认
5. 一路下一步完成，**全程不要关闭虚拟机，系统保持开机状态**

 ✨关键点：系统正在运行的时候添加磁盘，这块盘只会作为数据盘，**不会进入 BIOS 启动顺序，不会抢第一启动项，重启也不会再出现 DHCP 网络启动报错**。
添加
![[Pasted image 20260805122007.png]]
> ⚠️注意：`.lck`结尾的全部是锁文件，**不能选**，虚拟机运行时生成的，不要碰。

你这里：

- `CentOS9‑Train.vmdk`、`‑0.vmdk`：是 40G 系统盘，**不要选**，选了就把系统盘重复挂载，会出问题。
- `CentOS9‑Train‑1.vmdk` / `‑2.vmdk`：就是你之前创建的 10G 练习磁盘。

选：**CentOS9‑Train‑2.vmdk**，点击打开。
![[Pasted image 20260805122033.png]]
回到 CentOS 终端执行：没有看到`sdb`，热添加没识别出来。
![[Pasted image 20260805122137.png]]
- 如果硬件列表**已经出现磁盘，但 lsblk 看不到**：执行下面这条命令，刷新系统磁盘识别：
    ![[Pasted image 20260805122239.png]]
硬件列表里已经有 **硬盘 (SCSI)‑10GB**，VMware 这边添加成功，只是 CentOS 系统还没扫描识别到。

执行这条刷新 SCSI 扫描命令
bash

```
sudo echo "- - -" | sudo tee /sys/class/scsi_host/host0/scan
```

部分机器不止`host0`，需要扫描全部 scsi host。
依次复制执行：

bash

```
sudo echo "- - -" | sudo tee /sys/class/scsi_host/host0/scan
sudo echo "- - -" | sudo tee /sys/class/scsi_host/host1/scan
sudo echo "- - -" | sudo tee /sys/class/scsi_host/host2/scan
```

再查看磁盘：

bash

```
lsblk
```
![[Pasted image 20260805122406.png]]
出现 ==**sda 10G**==，就是我们练习用的磁盘。
注意：不是 sdb，识别成`sda`，后面所有磁盘练习操作目标设备写 **`/dev/sda`**。
接着：
回到 VMware 虚拟机设置，把网络适配器的「启动时连接」勾选上，恢复网络
整个执行过程：
![[Pasted image 20260805123033.png]]

### 核心知识点

1. fdisk 交互式完成硬盘分区
2. CentOS Stream9 默认文件系统为 xfs，使用 mkfs.xfs 格式化
3. mount 为临时挂载（重启失效），写入 /etc/fstab 为永久开机自动挂载

![[Pasted image 20260804231630.png]]
![[Pasted image 20260804231755.png]]
![[Pasted image 20260804233016.png]]



### 分步实操命令（按顺序执行）

bash

```
# 步骤1：对新增硬盘分区（任意目录执行）
sudo fdisk /dev/sda
# 交互依次输入：n → p → 1 → 两次回车 → w
# 刷新内核识别新分区
sudo partprobe /dev/sda

# 步骤2：格式化sda1分区（任意目录执行）
sudo mkfs.xfs /dev/sda1

# 步骤3：创建挂载空目录（/mnt路径下执行）
sudo mkdir -p /mnt/day04_newdisk
# 临时挂载分区（任意目录执行）
sudo mount /dev/sda1 /mnt/day04_newdisk

# 步骤4：校验临时挂载结果（任意目录执行）
lsblk /dev/sda
df -h /mnt/day04_newdisk

# 步骤5：获取分区UUID用于永久挂载（任意目录执行）
lsblk -f /dev/sda1

# 步骤6：编辑开机自动挂载配置（任意目录执行）
sudo vim /etc/fstab
# 文件末尾追加一行，替换为你的实际UUID：UUID=xxx /mnt/day04_newdisk xfs defaults 0 0

# 步骤7：fstab语法校验（必做防开机故障，任意目录执行）
sudo mount -a
```
### 高危提醒

1. /etc/fstab 配置错误会导致系统无法开机，修改后必须执行 mount -a 校验
2. 不要手动修改系统原有 sda 相关 fstab 配置，仅新增 sdb1 挂载行
3. umount 卸载时不能处于挂载目录内，需切换到其他目录再执行卸载命令
    
    【此处插入截图：fdisk 交互全过程、格式化输出、挂载校验、fstab 配置、mount -a 校验结果】

![[Pasted image 20260805124749.png]]
![[Pasted image 20260805124807.png]]


## 六、当日实操自检清单

1. ✅ ~/day04_test01 初始化目录文件全部创建完成
2. ✅ crontab 定时备份、定时日志任务配置生效，自动生成对应文件
3. ✅ lsblk/df/du/blkid/df -i 常用磁盘查询命令熟练区分使用场景
4. ✅ 完成新增硬盘分区、格式化、临时挂载全流程
5. ✅ 通过 UUID 配置 fstab 永久挂载，mount -a 校验无报错
6. ✅ 明确区分临时挂载与永久挂载的差异和风险点

## 七、当日练习清理命令（可选执行，任意目录执行）

bash

```
#清空当日定时任务
crontab -r
#卸载新增硬盘分区
sudo umount /mnt/day04_newdisk
#删除挂载目录
sudo rmdir /mnt/day04_newdisk
#删除当日所有day04练习文件目录
rm -rf ~/day04_*
```

## 八、踩坑笔记

 1、VMware BIOS Hard Drive 分组内部存在多块磁盘，**外层 Boot 顺序设置 Hard Drive 第一还不够，必须把 NVMe 系统盘调整到 SCSI 练习磁盘之上，否则依旧报 Operating System not found**。

 ==笔记本快捷键：BIOS 上移`shift +=`；保存退出`Fn+F10`。==

2、BIOS Hard Drive 是一个分组，里面有多块硬盘，**必须进入 Hard Drive 按回车展开，调整分组内部磁盘顺序，系统盘放最上方**，仅调整外层 Boot 顺序不够。

新增硬盘分区格式化 + 挂载实操之后虚拟机重启不成功
![[Pasted image 20260805131346.png]]

# 故障原因

`Operating System not found`

虚拟机 BIOS 启动顺序乱掉了，优先尝试 PXE 网络启动，**没有去找 nvme0n1 系统盘**，不是系统损坏。

## 修复步骤

1. 虚拟机窗口顶部菜单：**虚拟机 (M) → 电源 → 打开电源时进入固件 (Firmware)**

> 需要先关机，再点这个选项，开机瞬间按也可以。

2. 进入 BIOS 界面 → Boot（启动）选项卡
    
    调整启动顺序，优先级从上到下：
    
3. `Hard Drive`（硬盘，就是你的 40G nvme 系统盘）
    
4. CD‑ROM
    
5. Network Boot（PXE 网络启动放到**最底部**）
    
6. F10 保存退出 BIOS，虚拟机重启。

![[Pasted image 20260805131602.png]]
![[Pasted image 20260805131615.png]]
![[Pasted image 20260805131710.png]]
![[Pasted image 20260805131735.png]]

之后还是启动不了
![[Pasted image 20260805131748.png]]



保存 BIOS 之后，依旧弹出 `Operating System not found`，还是跑 PXE 网络启动，**BIOS 的 Hard Drive 内部子顺序出错了**。

> Hard Drive 这一大项里面包含两块磁盘：40G 系统 nvme 盘 + 10G 练习 sda 盘，现在虚拟机把 10G 练习盘放到硬盘组的第一位，它没有操作系统，所以启动失败。

## 修复步骤

1. 虚拟机完全关机。
2. 菜单：`虚拟机(M)` → `电源` → **打开电源时进入固件 (Firmware)**，再次进入 BIOS。
3. 来到`Boot`页面，选中 `Hard Drive`，按下 **Enter 回车键**，展开硬盘子列表。

> 里面会看到两个磁盘：
> 
> - NVMe 40G（真正 CentOS 系统盘）
> - SCSI 10G（我们做练习的空磁盘）

4. 使用 `shift + =`（加号），**把 NVMe40G 系统盘挪到 Hard Drive 分组内部的第一行**。
5. 按 `Fn+F10` → Yes 保存退出。

> 关键点：不光要 Hard Drive 在总顺序第一，**Hard Drive 内部子列表，系统盘必须排在练习磁盘前面**。之前只调了外层，内部子项顺序错了，依旧会从空练习盘启动报错。

![[Pasted image 20260805131951.png]]
![[Pasted image 20260805132009.png]]
![[Pasted image 20260805132029.png]]


## 九、本次故障完整复盘

> **故障：Operating System not found**
> 
> 触发条件：虚拟机新增第二块 SCSI 练习磁盘
> 
> 根因：VMware BIOS Hard Drive 分组内部磁盘顺序错乱，优先从无系统的 10G 练习盘启动
> 
> 解决步骤：
> 
> 1. 虚拟机 → 电源 → 打开电源时进入固件
> 2. Boot 选项卡，选中`Hard Drive`按回车展开内部磁盘列表
> 3. 使用`shift + =`把 NVMe 系统盘挪到 SCSI 练习盘上方
> 4. 笔记本按`Fn+F10`，选择 Yes 保存 BIOS
> 5. 开机后执行`df -h`校验磁盘自动挂载

> ⚠️重要提醒：不要删除这块 10G 练习磁盘硬件，保留即可，避免再次打乱 BIOS 启动顺序。