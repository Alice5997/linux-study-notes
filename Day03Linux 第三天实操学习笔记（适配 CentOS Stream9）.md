# Linux 第三天实操学习笔记（适配 CentOS Stream9）

## 对应剧集清单（基准版）

017_尚硅谷_Linux 实操篇_用户管理 创建用户指定密码

018_尚硅谷_Linux 实操篇_用户管理 删除用户

019_尚硅谷_Linux 实操篇_用户管理 查询切换用户

020_尚硅谷_Linux 实操篇_用户管理 组的管理

021_尚硅谷_Linux 实操篇_用户管理 用户和组的配置文件

022 运行级别和找回 root 密码

023 帮助指令

031_尚硅谷_Linux 实操篇_实用指令 ln history

035_尚硅谷_Linux 实操篇_组管理

036_尚硅谷_Linux 实操篇_权限详细介绍

037_尚硅谷_Linux 实操篇_权限管理

038_尚硅谷_Linux 实操篇_权限最佳实践

## 一、初始化练习目录（最先执行）

bash

```
# 创建第三天专属练习文件夹并进入
mkdir -p ~/day03_test01
cd ~/day03_test01

# 创建标准化测试文件、目录
touch day03_file01.txt day03_file02.txt day03_file03.txt
mkdir day03_dir01 day03_dir02

# 写入中文测试文本
echo "Linux第三天权限与用户学习" > day03_file01.txt
echo "软链接与硬链接区分练习" > day03_file02.txt
echo "chmod数字权限、符号权限实操" > day03_file03.txt
```

【此处插入截图：初始化目录、文件执行结果 ls 输出】
![[Pasted image 20260803234804.png]]
![[Pasted image 20260803234904.png]]
![[Pasted image 20260803234945.png]]
![[Pasted image 20260803234957.png]]



## 二、用户管理模块（017–021）

### 017 创建用户 + 设置密码

bash

```
# 创建测试用户
sudo useradd day03_user01
# 设置登录密码
sudo passwd day03_user01
# 查看用户uid/gid
id day03_user01
```

要点：新建用户会自动生成同名私有主组，输入密码屏幕无显示，正常两次确认即可。
密码：day03@123
![[Pasted image 20260804150551.png]]

### 018 删除用户

bash

```
# 仅删用户，保留家目录
sudo userdel day03_user01
# 彻底删除用户+家目录（测试收尾用）
# sudo userdel -r day03_user01
```

避坑：用户正在登录时无法删除，需要先 exit 退出用户。
![[Pasted image 20260804150817.png]]
手动删除家目录
![[Pasted image 20260804151134.png]]

### 019 查询、切换用户

bash

```
whoami                  # 当前登录用户
su - day03_user01       # 完整切换用户（加载环境变量）
exit                    # 切回原用户
cat /etc/passwd         # 查看系统全部用户
groups                  # 查看当前用户所属组
```
![[Pasted image 20260804151640.png]]

### 020 用户基础组管理

bash

```
sudo groupadd day03_group01               # 创建组
sudo usermod -aG day03_group01 day03_user01 # 用户加入附属组
cat /etc/group | grep day03               # 过滤查看测试组
sudo groupdel day03_group01               # 删除空组
```
![[Pasted image 20260804152035.png]]
### 021 用户和组三大核心配置文件

bash

```
less /etc/passwd   # 所有用户基础信息，全部用户可读
less /etc/group    # 系统所有用户组信息
sudo less /etc/shadow # 加密密码文件，仅root可读，禁止手动编辑
```
![[Pasted image 20260804152349.png]]

![[Pasted image 20260804152417.png]]
![[Pasted image 20260804152513.png]]


避坑：不要直接 vim 修改 shadow，极易造成账号无法登录，只用 useradd/groupadd 等命令管理。



## 三、运行级别 & root 密码找回（022）

![[Pasted image 20260804143602.png]]

### 核心知识点

CentOS Stream9 抛弃传统数字运行级别，使用 target 目标模式：

1. `graphical.target`：图形桌面模式（虚拟机默认）
2. `multi-user.target`：纯字符命令行模式

### 实操（仅查询，不修改默认启动项）

bash

```
# 查看当前默认启动模式
systemctl get-default

# 切换命令行（仅了解，不建议永久修改）
# sudo systemctl set-default multi-user.target
# 切回图形桌面
# sudo systemctl set-default graphical.target
```

![[Pasted image 20260804152619.png]]



高危提醒：找回 root 密码需要修改开机启动项，新手日常不用实操，仅了解应急原理即可。
![[Pasted image 20260804144848.png]]
![[Pasted image 20260804144800.png]]



## 四、帮助指令（023，全程通用工具）

三种查命令用法方式，优先级 `man > --help > help`

bash

```
man ls          # 官方完整手册，按q退出
man chmod
ls --help       # 命令自带简易帮助
help cd         # shell内置命令专用查询
```

![[Pasted image 20260804152749.png]]
![[Pasted image 20260804152831.png]]
![[Pasted image 20260804152916.png]]
![[Pasted image 20260804153055.png]]

实用技巧：以后遇到陌生权限、组管理命令，优先用 man 自查参数，不用死记。

## 五、ln 软硬链接 + history 历史命令（031）

### 1. 准备测试文件

bash

```
cd ~
touch day03_file01.txt
echo "软硬链接测试内容" > day03_file01.txt
```


### 2. 硬链接

bash

```
ln day03_file01.txt day03_hard01.txt
```

特点：共用 inode，删除源文件硬链接仍能读取内容；不支持目录、不能跨分区。
![[Pasted image 20260804172925.png]]
### 3. 软链接（快捷方式）

bash
给源文件创建一个软链接
==命令格式：ln -s 【源文件或者目录】【软链接名】==

```
ln -s day03_file01.txt day03_soft01.txt
ls -l
```
![[Pasted image 20260804154824.png]]

删除软链接：
==rm -rf【软链接名】==
![[Pasted image 20260804154908.png]]


特点：源文件删除后软链接失效；支持目录、可跨分区。

### 4. history 历史命令

查看已经执行过厉史命令，也可以执行历史指令
bash

```
history       # 全部历史命令
history 10    # 最近10条
!50           # 执行历史第50条命令
# history -c  # 清空当前终端历史（谨慎执行）
```
![[Pasted image 20260804154446.png]]
![[Pasted image 20260804154507.png]]
![[Pasted image 20260804154557.png]]
![[Pasted image 20260804154715.png]]

## ==六、进阶组管理（035）==

bash

```
# 新建两组
sudo groupadd day03_g1
sudo groupadd day03_g2
# 修改组名称
sudo groupmod -n day03_g1_new day03_g1
# 追加附属组（-a必带，否则覆盖原有所有组）
sudo usermod -aG day03_g1_new study
groups study
# 修改文件所属组
sudo chgrp day03_g1_new day03_file01.txt
ls -l day03_file01.txt
# 删除无成员空组
sudo groupdel day03_g2
```
![[Pasted image 20260804174028.png]]

关键避坑：`usermod -G` 不加 `-a` 会清空用户原有附属组，永久使用 `-aG` 追加。
![[Pasted image 20260804161055.png]]


## 七、权限全套内容（036/037/038）

### 036 权限基础 ls -l 解读

bash

```
ls -l day03_file01.txt
```

权限三段：属主 u、属组 g、其他 o；

权限数值：r=4，w=2，x=1。

![[Pasted image 20260804174149.png]]

![[Pasted image 20260804161905.png]]
![[Pasted image 20260804162117.png]]
![[Pasted image 20260804162931.png]]

### 037 chmod 数字权限修改
第一种方式：

![[Pasted image 20260804163352.png]]
![[Pasted image 20260804163755.png]]
![[Pasted image 20260804163726.png]]
![[Pasted image 20260804163639.png]]
![[Pasted image 20260804163929.png]]
![[Pasted image 20260804164017.png]]
![[Pasted image 20260804163938.png]]
![[Pasted image 20260804164115.png]]

第二种方式：

![[Pasted image 20260804164338.png]]
![[Pasted image 20260804164517.png]]
![[Pasted image 20260804164615.png]]
![[Pasted image 20260804165037.png]]
![[Pasted image 20260804165258.png]]

![[Pasted image 20260804165330.png]]
![[Pasted image 20260804165452.png]]
![[Pasted image 20260804165529.png]]

bash

```
# 设置文件权限644：u读写 g读 o读
chmod 644 day03_file01.txt
# 文件夹递归授权（谨慎使用-R）
# chmod -R 755 day03_test_dir/
```
![[Pasted image 20260804174303.png]]

### 038 权限最佳实践 chown 修改属主属组

bash

```
# 仅修改文件属主
sudo chown day03_user01 day03_file01.txt
# 同时修改属主+属组
sudo chown day03_user01:day03_g1_new day03_file01.txt
```
![[Pasted image 20260804175751.png]]


规范建议：普通文件 644、目录 755，严禁随意 777 全开权限。


![[Pasted image 20260804165905.png]]
![[Pasted image 20260804170206.png]]
![[Pasted image 20260804170232.png]]
![[Pasted image 20260804170332.png]]
![[Pasted image 20260804170523.png]]
![[Pasted image 20260804170826.png]]
![[Pasted image 20260804171427.png]]
![[Pasted image 20260804171624.png]]
![[Pasted image 20260804171713.png]]


## 今日实操截图占位清单

1. /etc/passwd、/etc/group、/etc/shadow 查询结果
2. systemctl get-default 运行级别查询
3. man ls 帮助手册界面
4. ls -l 软硬链接对比截图
5. groups 查看用户附属组、chgrp 修改属组结果
6. chmod、chown 修改权限前后 ls -l 对比