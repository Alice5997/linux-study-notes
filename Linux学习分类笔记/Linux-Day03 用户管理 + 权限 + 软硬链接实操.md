# Linux 学习 - 第 3 天 用户管理 + 权限 + 软硬链接实操

## 基础信息

1. 课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh "autolink")
2. 今日严格对应观看选集（按顺序观看，标题完全匹配截图）
    
    017 实操篇 用户管理 创建用户指定密码
    
    018 实操篇 用户管理 删除用户
    
    019 实操篇 用户管理 查询切换用户
    
    020 实操篇 用户管理 组的管理
    
    031 实操篇 实用指令 ln history（软硬链接核心课时）
    
    036 实操篇 权限详细介绍
    
    037 实操篇 权限管理
    
    038 实操篇 权限最佳实践

> ❗避坑标注：045-047 是网络配置、041-044 是磁盘内容，**第三天完全不学**，延后安排

3. 系统环境：CentOS Stream9，登录普通用户 study
4. 全局统一命名规范（和 day01/day02 保持一致）
    
    当日总目录：day03_test01
    
    测试文件：day03_file01.txt、day03_file02.txt、day03_file03.txt
    
    测试目录：day03_dir01、day03_dir02
    
    衍生文件：day03_filexx_hardlink.txt、day03_filexx_softlink.txt
5. 使用规则：所有命令手动输入，禁止复制；每步执行完成后，在笔记对应标记处插入终端截图

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


## 二、模块 1 用户与用户组管理（对应 017/018/019/020 集）

### 1. 用户信息查询实操

bash

```
whoami               # 查看当前登录用户
groups               # 查看当前用户所属用户组
id study             # 查看用户uid、gid、附属组
cat /etc/passwd      # 查看系统所有用户配置
cat /etc/group       # 查看系统所有用户组配置
```

【此处插入截图：whoami、id、passwd/group 文件查看输出】
![[Pasted image 20260804002502.png]]
![[Pasted image 20260804002528.png]]


### 2. 用户组配套理解（020 集知识点）

- 主组：用户创建文件默认归属组
- 附加组：用户额外加入的权限组，用于资源权限分配

> 实操说明：本阶段仅查询现有用户组，不新建系统用户避免环境混乱

## 三、模块 2 用户和组的配置文件（对应 021 集，新增补充）

### 核心知识点

1. 三大核心配置文件分工
    
    - `/etc/passwd`：存储所有用户基础账号信息，系统所有用户可读
    - `/etc/group`：存储全量用户组信息，记录主组 / 附属组关联关系
    - `/etc/shadow`：加密存储用户登录密码，仅 root 可读，**禁止手动 vim 直接编辑**
    
2. 后续权限读写判断的底层依据，全部来源于这三个配置文件

### 补充实操命令（在 day03_test01 目录执行）

bash

```
# 过滤查看当前study用户账号信息
cat /etc/passwd | grep study
# 过滤查看day03相关测试组信息
cat /etc/group | grep day03
# 提权查看加密密码文件（必须sudo）
sudo cat /etc/shadow | grep study
```

【此处插入截图：三条过滤查询命令终端输出】
![[Pasted image 20260804213750.png]]

### 避坑提醒

手动编辑`/etc/shadow`极易格式错乱，直接导致账号无法登录，**仅用系统命令增删改用户和用户组**

---

## 四、模块 3 运行级别和找回 root 密码（对应 022 集，新增补充）

### 核心知识点

1. CentOS Stream9 弃用传统数字运行级别，改用 target 目标模式：
    
    - `graphical.target`：图形化桌面模式（当前虚拟机默认）
    - `multi-user.target`：纯字符命令行模式
    
2. 找回 root 密码属于应急运维操作，日常学习仅了解原理，新手不随意实操

### 安全实操（仅查询，不修改系统默认配置）

bash

```
# 查询当前系统默认启动模式
systemctl get-default

# 可选命令（仅了解，不建议永久修改）
# sudo systemctl set-default multi-user.target   # 切命令行模式
# sudo systemctl set-default graphical.target    # 切回图形桌面模式
```

【此处插入截图：systemctl get-default 查询结果】
![[Pasted image 20260804213816.png]]
### 高危提醒

重置 root 密码需要修改系统启动参数，误操作会造成系统启动失败，非故障场景不实操

---

## 五、模块 4 帮助指令（对应 023 集，新增补充）

### 核心知识点

命令自查优先级：`man 官方手册 > --help简明参数 > shell内置help`

### 实操命令

bash

```
# 最详细官方手册，浏览结束按 q 退出
man ls
man chmod
# 命令自带快速帮助
ls --help
# shell内置专属命令查询
help cd
```

【此处插入截图：man ls 手册界面截图】
![[Pasted image 20260804213842.png]]

### 实用技巧

遇到陌生命令优先用 `man 命令名` 自查，无需死记全部参数

---

## 六、模块 5 ln 软硬链接 + history 历史命令（对应 031 集，新增补充）

### 1. history 历史命令实操

bash

```
# 查看全部历史执行命令
history
# 仅查看最近10条历史命令
history 10
# 谨慎清空当前终端历史（了解即可）
# history -c
# 执行历史列表第N条命令格式：!N
```
![[Pasted image 20260804213913.png]]

### 2. 软硬链接实操（在 day03_test01 目录执行）

bash

```
# 基于已创建的day03_file02.txt制作链接（复用前期文件，不重复新建）
# 创建硬链接
ln day03_file02.txt day03_ln_hard01
# 创建软链接（必须加-s参数）
ln -s day03_file02.txt day03_ln_soft01
# 查看链接属性对比
ls -l
```



### 软硬链接核心区别

1. 硬链接：和源文件共用 inode 节点，删除源文件硬链接仍可正常使用；不能跨分区、不支持目录创建硬链接
2. 软链接：类似 Windows 快捷方式，源文件删除后软链接失效；支持跨分区、支持目录创建软链接
    
    【此处插入截图：ls -l 软硬链接属性对比截图】
![[Pasted image 20260804214122.png]]
---

## 七、模块 6 组管理进阶完整版（对应 035 集，新增补充）

### 核心知识点

`groupadd/groupmod/groupdel/usermod` 完整组生命周期管理，是读懂文件 g 组权限的前置关键

### 实操命令

bash

```
# 新建2个测试用户组
sudo groupadd day03_group01
sudo groupadd day03_group02
# 修改用户组名称
sudo groupmod -n day03_group01_new day03_group01
# 将study用户追加进附属组（必带-a，否则清空原有全部附属组！）
sudo usermod -aG day03_group01_new study
# 验证用户所属组结果
groups study
# 修改已有测试文件的所属用户组
sudo chgrp day03_group01_new day03_file01.txt
ls -l day03_file01.txt
# 删除无成员的空测试组
sudo groupdel day03_group02
```

【此处插入截图：组创建、附属组添加、文件属组修改输出】
![[Pasted image 20260804214404.png]]


### 关键避坑

==`usermod -G 组名` 不加 `-a` 参数会直接覆盖清空用户原有所有附属组，**固定使用 usermod -aG 追加附属组**==


## 八、模块 7 文件权限理论 + 实操（对应 036/037/038 集）

### 核心知识点（036 集理论） 文件权限基础、ls -l 权限解读

r=4 读权限 | w=2 写权限 | x=1 执行权限

权限三段含义：u 所有者、g 所属组、o 其他用户

bash

```
# 查看完整权限、属主、属组
ls -l
# 查看inode编号（区分软硬链接必备）
ls -li
```

【此处插入截图：ls -l 、ls -li 完整输出】
![[Pasted image 20260804214444.png]]

### 1. 数字权限修改（企业常用，037 集实操）

bash

```
# 文件644：所有者读写，组/其他人只读
chmod 644 day03_file01.txt
# 文件764：所有者全部权限，组读写，其他人只读
chmod 764 day03_file02.txt
# 目录递归设置755权限
chmod -R 755 day03_dir01
ls -l
```

【此处插入截图：数字权限修改前后对比】
![[Pasted image 20260804212342.png]]

### 2. 符号权限微调（037 集实操）

bash

```
chmod u+x day03_file03.txt  # 所有者增加执行权限
chmod g-w day03_file03.txt  # 移除组写权限
chmod o+r day03_file03.txt  # 其他用户增加读权限
ls -l
```

【此处插入截图：符号权限修改前后对比】
![[Pasted image 20260804212516.png]]

### 3. 属主属组修改（038 最佳实践）chmod 符号权限、chown 修改属主属组

bash

```
# 仅修改文件所有者
chown study day03_file01.txt
# 同时修改属主+属组
chown study:study day03_file02.txt
# 单独修改目录所属组
chgrp study day03_dir02
# 递归修改目录全部文件属主属组
chown -R study:study day03_dir02
ls -l
```

【此处插入截图：属主属组修改结果】
![[Pasted image 20260804212649.png]]


### 权限最佳实践总结（直接留存，038 集核心）

1. 业务文件优先 644 权限，业务目录优先 755 权限
2. 禁止随意执行`chmod 777`全局开放权限，存在安全隐患
3. 目录必须保留 x 执行权限，否则无法进入目录

## 四、模块 3 软硬链接实操（严格对应 031 集 ln 命令课时）

bash

```
# 创建硬链接（共用inode，ln不加-s）
ln day03_file01.txt day03_file01_hardlink.txt

# 创建软链接（快捷方式，ln加-s参数）
ln -s day03_file02.txt day03_file02_softlink.txt

# 查看inode区分两种链接
ls -li
```

【此处插入截图：创建链接后 ls -li 结果】

![[Pasted image 20260804212920.png]]

### 特性对比测试（必做实操）

bash

```
# 删除原文件day03_file02.txt
rm day03_file02.txt
# 分别读取硬链接、失效软链接，观察差异
cat day03_file01_hardlink.txt
cat day03_file02_softlink.txt
```

【此处插入截图：删除原文件后两种链接访问效果对比】
![[Pasted image 20260804213132.png]]


### 软硬链接文字总结

1. 硬链接：和原文件 inode 编号一致；不能跨分区、不能链接目录；删除原文件，硬链接仍可正常读取
2. 软链接：独立 inode 编号；支持跨分区、可链接目录；原文件删除 / 移动后，软链接失效报错

## 五、当日收尾自检命令

bash

```
# 查看今日全部练习文件、权限、inode
ls -li ~/day03_test01
```

【此处插入截图：当日全部练习文件总览】
![[Pasted image 20260804213220.png]]

## 六、踩坑记录区（实操报错自行补充记录）

1. ==修改目录权限需要加 - R 递归参数，普通文件不要随意递归授权==
2. ==目录缺少 x 权限时，无法执行 cd 进入目录==
3. ==ln 不加 - s 是硬链接，加 - s 才是软链接，参数极易记混==
4. ==软链接依赖原文件路径，原文件移动 / 删除后直接失效；硬链接不受文件移动影响==
5. ==Linux 文件名严格区分大小写，day03_file01 和 Day03_File01 属于两个独立文件==
6. ==分集避坑：041-044 磁盘、045-047 网络、048 + 进程 / RPM 等内容全部延后学习，不打乱节奏==

## 七、新手操作红线（严格禁止执行）

1. ==不使用 sudo chmod 777 全开权限，存在严重安全风险==
2. ==严禁执行 rm -rf / 毁灭性删除命令==
3. ==全程使用普通用户 study 练习，无特殊需求不切换 root 用户==

