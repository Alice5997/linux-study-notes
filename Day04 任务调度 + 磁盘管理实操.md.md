# Linux-Day04 任务调度 + 磁盘管理实操.md

## 一、今日对应视频选集（BV1dW411M7xL）

039 实操篇 任务调度基本说明

040 实操篇 任务调度应用实例

041 实操篇 磁盘分区介绍

042 实操篇 Linux 分区

043 实操篇 给 Linux 添加一块新硬盘

044 实操篇 磁盘查询实用指令

## 二、统一命名规范

所有练习目录、文件、脚本统一前缀：`day04_`

日常操作用户：study，磁盘高危操作加 sudo 提权

## 三、模块 1：crond 任务调度

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

### 实操练习 1：定时文件备份

1. 创建练习目录与测试文件

bash

```
mkdir -p ~/day04_cron_back
touch ~/day04_testfile.txt
echo "Day04定时任务测试内容" > ~/day04_testfile.txt
```

2. 编写备份脚本`day04_backup.sh`

bash

```
vim ~/day04_backup.sh
```

脚本内容：

bash

```
#!/bin/bash
cp /home/study/day04_testfile.txt /home/study/day04_cron_back/day04_bak_$(date +%Y%m%d_%H%M).txt
```

3. 赋予脚本执行权限

bash

```
chmod 755 ~/day04_backup.sh
```

4. 添加定时任务：每 2 分钟执行一次备份

bash

```
crontab -e
# 写入如下规则
*/2 * * * * /home/study/day04_backup.sh
```

5. 验证方式

bash

```
crontab -l          # 查看任务是否写入成功
ls ~/day04_cron_back # 等待2分钟查看自动生成的备份文件
```

### 实操练习 2：定时写入系统时间日志

bash

```
crontab -e
# 新增一行规则：每分钟写入当前时间到日志文件
* * * * * date >> /home/study/day04_time_log.txt
```

### crond 服务状态管理命令

bash

```
systemctl status crond        # 查看服务运行状态
sudo systemctl enable crond   # 设置开机自启
sudo systemctl restart crond  # 重启定时任务服务
```

### 本模块避坑要点

1. 定时任务内的文件、脚本必须写**绝对路径**，相对路径会执行失败
2. 自定义脚本必须添加 x 执行权限
3. crontab -r 会一次性清空全部任务，删除单条任务请在 crontab -e 内手动删行
4. 日和周字段不要同时限定条件，容易产生执行冲突
    
    【截图占位：crontab -l 任务列表、自动生成的备份文件、crond 服务状态截图】

## 四、模块 2：磁盘分区基础理论

### 核心概念

1. 磁盘标识规则：/dev/sda 为第一块硬盘，/dev/sdb 为第二块新增硬盘；sda1、sda2 代表第一块硬盘的不同分区
2. 分区类型：主分区（单硬盘最多 4 个）、扩展分区（占用 1 个主分区位，可划分多个逻辑分区）
3. Linux 无 Windows 盘符概念，分区必须**挂载到空目录**才可读写使用，根目录 / 为系统默认挂载点
4. 磁盘使用完整流程：硬盘分区 → 格式化创建文件系统（xfs/ext4）→ 挂载目录使用

## 五、模块 3：磁盘常用查询指令实操

### 1. lsblk 查看磁盘分区与挂载信息

bash

```
lsblk       # 简洁展示磁盘、分区、挂载点
lsblk -f    # 额外显示文件系统类型、UUID（永久挂载必备）
```

### 2. df 查看已挂载分区使用率

bash

```
df -h       # -h以G/M人性化单位展示容量占用
df -h /     # 单独查看系统根分区占用情况
```

### 3. du 统计文件 / 目录实际占用大小

bash

```
du -sh ~                # 统计当前用户家目录总占用
du -sh /home/*          # 统计所有用户目录占用
du -sh day04_*          # 统计本次day04所有练习文件总大小
```

参数说明：-s 汇总总量、-h 友好容量单位

### 4. 临时挂载与卸载命令

bash

```
# 临时将分区挂载至空目录
sudo mount /dev/sdb1 /mnt/day04_mountdir
# 卸载挂载点（当前目录无读写占用才可正常卸载）
sudo umount /mnt/day04_mountdir
```

【截图占位：lsblk -f 输出、df -h 输出、du 统计结果截图】

## 六、模块 4：虚拟机新增硬盘完整实操

### 前置准备

VMware 虚拟机关机状态下添加一块虚拟硬盘，开机后系统识别为 /dev/sdb

### 步骤 1：fdisk 对新硬盘分区

bash

```
sudo fdisk /dev/sdb
# 交互依次输入指令
n   #新建分区
p   #选择主分区
1   #分区编号1
回车 #默认起始扇区
回车 #占用全部剩余空间
w   #保存分区表退出
sudo partprobe /dev/sdb #刷新内核识别新分区
```

### 步骤 2：格式化分区（CentOS Stream9 默认 xfs 格式）

bash

```
sudo mkfs.xfs /dev/sdb1
```

### 步骤 3：创建空目录并临时挂载

bash

```
sudo mkdir -p /mnt/day04_newdisk
sudo mount /dev/sdb1 /mnt/day04_newdisk
# 校验挂载结果
lsblk /dev/sdb
df -h /mnt/day04_newdisk
```

### 步骤 4：配置开机永久挂载（/etc/fstab）

1. 获取分区 UUID

bash

```
lsblk -f /dev/sdb1
```

2. 编辑系统挂载配置文件

bash

```
sudo vim /etc/fstab
# 文件末尾追加一行，替换为你的实际UUID
UUID=你的UUID值 /mnt/day04_newdisk xfs defaults 0 0
```

字段释义：UUID 挂载目录 文件系统 权限参数 备份标记 自检标记

3. 语法校验（必做，避免系统开机故障）

bash

```
sudo mount -a
```

无输出即代表配置正确

### 高危操作红线

1. 禁止对系统盘 /dev/sda 执行 fdisk 分区修改操作
2. /etc/fstab 配置错误会导致系统无法开机，修改后必须执行 mount -a 校验
3. mount 临时挂载重启失效，写入 fstab 才会永久生效
    
    【截图占位：fdisk 交互全过程、格式化输出、挂载校验、fstab 配置、mount -a 校验截图】

## 七、模块 5：进阶磁盘查询实操

### 1. 查看 inode 占用（inode 耗尽无法新建文件）

bash

```
df -i
```

### 2. blkid 精准查询分区 UUID

bash

```
blkid
blkid /dev/sdb1
```

### 3. 查找大文件清理磁盘空间

bash

```
# 家目录下查找大于500M的文件
find ~ -type f -size +500M -ls
```

【截图占位：df -i、blkid、find 查找大文件结果截图】

## 八、Day04 实操自检清单

✅ 成功配置 crontab 定时备份任务，自动生成备份文件

✅ 熟练使用 lsblk/df/du 三类磁盘查询命令

✅ 完成新增硬盘分区、格式化、临时挂载全流程

✅ 通过 UUID 配置 fstab 永久挂载，mount -a 校验无报错

✅ 掌握 inode 占用排查、大文件查找方法

## 九、当日练习清理命令（可选）

bash

```
crontab -r                     #清空当日定时任务
rm -rf ~/day04_*               #删除当日练习文件
sudo umount /mnt/day04_newdisk #卸载新增硬盘分区
sudo rmdir /mnt/day04_newdisk  #删除挂载目录
```