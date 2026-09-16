# Linux 第二天目录结构与基础文件操作实操清单（CentOS Stream9）

要求：全部手动敲命令，禁止复制；做完一条观察输出，理解作用

登录用户：study（普通用户，不要随便切 root）

## 一、核心理论知识点

1. 根目录 `/`
    
    Linux 文件系统最顶层，`ls /`查看一级目录：bin boot dev etc home lib lib64 media mnt opt proc root run srv sys tmp usr var
    
    新版文件管理器【其他位置 - 文件系统】等价老系统桌面 “计算机”
2. 家目录 `~` = `/home/study`，所有练习统一创建在家目录避免权限问题
3. 绝对路径：/ 开头完整路径；相对路径：以当前目录为起点简写路径
![[Pasted image 20260803103855.png]]
![[Pasted image 20260803103926.png]]
![[Pasted image 20260803104103.png]]
![[Pasted image 20260803105412.png]]

![[Pasted image 20260803110629.png]]

![[Pasted image 20260803105618.png]]
![[Pasted image 20260803112052.png]]

## 二、基础目录切换实操命令（每步搭配 pwd 验证 + 截图）

pwd # 初始路径截图
![[Pasted image 20260804150108.png]]

cd /

pwd # 根路径截图
![[Pasted image 20260802230034.png]]
cd ~

pwd # 家目录截图
![[Pasted image 20260802230056.png]]
cd ..

pwd
![[Pasted image 20260802230116.png]]
cd -
![[Pasted image 20260802230141.png]]
## 三、目录查看拓展命令

ls
![[Pasted image 20260802230226.png]]
ls -l # 截图留存
![[Pasted image 20260802230248.png]]
ls -lh
![[Pasted image 20260802230306.png]]
ls -a
![[Pasted image 20260802230337.png]]
tree ~ # 树形展示家目录层级并截图
![[Pasted image 20260802230401.png]]
## 四、标准化创建测试文件夹（day02_testXX 格式）

mkdir ~/day02_test01
![[Pasted image 20260802230523.png]]
mkdir -p ~/day02_test01/sub01
![[Pasted image 20260802230610.png]]
mkdir ~/day02_test02
![[Pasted image 20260802230717.png]]
cd ~/day02_test01
![[Pasted image 20260802230803.png]]
## 五、标准化创建空白测试文件（day02_fileXX.txt 格式）

touch day02_file01.txt day02_file02.txt
这里文件数字输错数字day01，应该是02
![[Pasted image 20260802231001.png]]
## 六、文件与文件夹复制实操

cp day02_file01.txt day02_file01_bak01.txt
![[Pasted image 20260802231203.png]]
![[Pasted image 20260802231536.png]]
cp -r sub01 sub01_bak01
![[Pasted image 20260802231756.png]]
## 七、移动 / 重命名文件、文件夹

mv day02_file02.txt day02_file02_rename.txt
![[Pasted image 20260802231844.png]]
mv day02_file01_bak01.txt ~/day02_test02/
![[Pasted image 20260802232010.png]]
![[Pasted image 20260802232027.png]]

## 八、删除文件与文件夹（删除不可恢复，谨慎操作）

rm day02_file01.txt
这里删除前面建错的文件day01_file01.txt
rm day01_file01.txt
![[Pasted image 20260802232143.png]]
rmdir sub01
![[Pasted image 20260802232213.png]]

rm -r sub01_bak01
![[Pasted image 20260802232259.png]]

## 九、磁盘分区查看辅助命令

df -h # 截图保存磁盘挂载与使用率
![[Pasted image 20260802232420.png]]
## 十、今日踩坑记录区（Obsidian 单独区块）

1. ==复制文件夹不加 -r 会报错==

2.rm 删除无回收站，执行前核对文件名

3. ==多层目录创建必须加 -p==

4==.Linux 区分大小写==，day02_test01 和 Day02_test01 是两个不同对象

⚠️ 永久红线：严禁执行`rm -rf /`，全程优先用 study 普通用户练习

实操过程截图
![[Pasted image 20260802233341.png]]


## 新增补充模块 1：015 vi 和 vim 编辑器实操（核心必学）

### 1. 核心模式区分（视频重点）

- 命令模式：打开 vim 默认进入，用于复制、删除、跳转行
- 插入模式：按`i/a/o`进入，可编辑文字；按`Esc`退回命令模式
- 底行模式：==命令模式==输入`:`进入，用于保存、退出、搜索替换

普通模式：
插入模式
命令模式
![[Pasted image 20260803113824.png]]

bash

```
# 进入练习目录
cd ~/day02_test01
# 用vim创建并打开测试文件
vim day02_vim_test.txt
```

【此处插入截图：vim 初始命令模式界面】
![[Pasted image 20260803113308.png]]
![[Pasted image 20260803113337.png]]

### 2. 高频实操按键（逐一键位练习）

#### 命令模式常用操作

plaintext

```
yy   # 复制当前行
p    # 粘贴复制内容
dd   # 删除当前行
5dd  # 连续删除5行
G    # 跳转到文件最后一行
gg   # 跳转到文件第一行
u    # 撤销上一步操作
```

#### 进入插入模式按键

plaintext

```
i  # 在光标当前位置插入（最常用）
a  # 在光标后一位插入
o  # 在光标下方新建一行插入
```

#### 底行模式保存退出（关键必记）

plaintext

```
:w    # 保存不退出
:q    # 正常退出（文件未修改时可用）
:wq   # 保存并退出
:w!   # 强制保存
:q!   # 不保存强制退出
:wq!  # 强制保存退出
```

【此处插入截图：分别演示保存、强制退出的终端结果】
:w 
![[Pasted image 20260803121238.png]]
:wq!
![[Pasted image 20260803121418.png]]


### 3. 实操任务

1. vim 打开`day02_vim_test.txt`，输入 3 行学习笔记文字
2. 练习复制一行、删除一行、撤销操作
3. 分别用`:wq`正常保存退出、再次打开用`:q!`不退出尝试修改作废

### 踩坑补充

- 忘记按 Esc 直接输入文字会乱码，必须先 Esc 回到命令模式才能输冒号进底行模式
- 后续配置 yum 源、编写脚本全程依赖 vim，务必熟练这套基础操作

---

## 新增补充模块 2：016 关机重启注销命令实操

### 1. 安全关机 / 重启命令（禁止直接强制断电）

bash

```
# 推荐延时关机，给进程预留退出时间
sudo shutdown -h 10    # 10分钟后关机
sudo shutdown -h now  # 立即关机
sudo shutdown -r 10    # 10分钟后重启
sudo shutdown -r now   # 立即重启（等价reboot）
sudo shutdown -c      # 取消已设置的定时关机/重启

reboot                 # 安全重启，普通用户可执行
halt                   # 停机关机
poweroff               # 断电关机
```

【此处插入截图：执行 shutdown -c 取消定时命令示例】
![[Pasted image 20260803122158.png]]

### 2. 注销与用户退出

bash

```
logout    # 退出当前终端登录会话
exit      # 退出当前shell会话/终端窗口
```

### 关键知识点

1. Linux 服务器优先用命令优雅关机重启，强制断电极易损坏系统文件
2. `shutdown`需要 sudo 提权，`reboot`普通用户可直接执行
3. 日常虚拟机练习优先用`reboot`重启、`poweroff`关机即可

---

## 二、当日收尾自检命令（补充后完整版）

bash

```
# 查看第二天全部练习文件
ls -li ~/day02_test01
# 验证vim文件内容
cat ~/day02_test01/day02_vim_test.txt
```

【此处插入截图：当日全部练习文件总览】
![[Pasted image 20260803122405.png]]

## 三、新增踩坑记录区（可自行补充报错）

1. vim 模式混淆是新手最高频报错，牢记「==编辑完先 Esc 再保存退出==」
2. 不要频繁强制关闭虚拟机窗口代替命令关机，长期会导致系统源、配置文件异常
3. `shutdown -h now`和`poweroff`效果接近，==优先用 shutdown 更安全==

## 四、新手操作红线（补充新增）

1. 严禁在 vim 误操作后直接强制关闭终端，优先用`:q!`安全放弃修改
2. 禁止频繁强制断电关机，必须使用本章学习的标准关机重启命令
3. 013、014 远程工具章节暂时不实操，不提前安装 XShell/Xftp 打乱当前学习节奏