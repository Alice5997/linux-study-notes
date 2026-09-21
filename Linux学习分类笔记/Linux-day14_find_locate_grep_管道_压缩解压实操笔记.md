# Linux_day14_find_locate_grep_管道_压缩解压实操笔记

## 基础信息

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://www.bilibili.com/video/BV1dW411M7xL) 
2、今日观看选集（严格匹配分集清单标题）

- 033_尚硅谷_Linux 实操篇实用指令 find locate grep 管道符
- 034_尚硅谷_Linux 实操篇实用指令 压缩和解压

3、系统环境：CentOS Stream9，登录普通用户 study 
4、全局统一规范（与 Day1~Day12 模板完全统一）

- 当日练习根目录：`~/day14_test01`
- Shell 脚本统一后缀：`.sh`
- 脚本开头声明 `#!/bin/bash` 
5、今日练习测试目录、文件等：
- 测试文件：`log01.txt`、`log02.txt`、`test_archive.txt`
- 测试目录：`sub_dir01`
- 压缩包练习：`test_all.tar.gz`、`demo.zip`

💡补充实操命令 (默认在 `~/day14_test01` 目录执行，特殊路径单独标注)

```
# (家目录 ~ 执行)
mkdir -p ~/day14_test01/sub_dir01
cd ~/day14_test01
# 创建练习文本文件
echo "error: connection failed" > log01.txt
echo "info: service start ok" > log02.txt
echo "find locate grep tar zip练习内容" > test_archive.txt
```

【此处放置截图：ls 查看 day14_test01 目录初始化结果】
![[Pasted image 20260915174312.png]]
---

## 模块 1 find 查找文件命令（对应 033 集）

### 核心知识点

1. ==`find`：**实时磁盘遍历查找文件**，查询真实磁盘，结果准确；速度相对慢==
2. ==基础语法：`find 查找路径 [选项] 匹配条件`==
3. ==常用选项==
    - ==`-name`：按文件名查找，支持通配符 `* ?`==
    - ==`-user`：按文件所属用户查找==
    - ==`-size`：按文件大小查找；`+n`大于、`-n`小于、`n`等于==
    - ==`-type`：按文件类型查找；`f`普通文件，`d`目录==

### 实操命令

```
# 1. 在当前目录查找名字以txt结尾的所有文件
find . -name "*.txt"

# 2. 家目录下查找属于study用户的全部文件
find ~ -user study

# 3. 查找大于1M的普通文件
find ~ -size +1M -type f

# 4. 系统实操：/etc目录下查找以host开头的配置文件
sudo find /etc -name "host*"
```

【此处放置截图：find 各条件查找输出截图】
![[Pasted image 20260915174947.png]]
![[Pasted image 20260915175040.png]]


### 本模块避坑

> 1. `-name`匹配文件名，通配符`*`必须用双引号包裹，防止 shell 提前解析
> 2. 查找系统目录 `/etc`、`/root` 需要加 sudo，否则很多文件提示权限拒绝
> 3. find 是实时扫描磁盘，文件数量巨大时执行耗时会变长

---

## 模块 2 locate 快速查找（对应 033 集）

### 核心知识点

1. `locate`：**数据库索引查找**，速度极快；不扫描磁盘，读取系统文件数据库
2. 原理：系统后台定时更新数据库；新建文件不会立刻被 locate 检索到
3. CentOS Stream9 默认未安装，包名 `plocate`
4. `updatedb`：手动刷新文件索引数据库

- 优点：查询速度远快于 find
- 缺点：数据库不会实时更新，新建文件需要手动更新数据库才能查到；无法检索临时目录。

> ==CentOS Stream9 软件包名称：**mlocate**（不是 plocate，plocate 为 Fedora 使用）==

💡实操命令 (默认在～/day14_test01 目录执行，特殊路径单独标注)

```
# (~/day14_test01 目录执行)
# 安装mlocate软件包
sudo dnf install mlocate -y

# 初始化/更新文件索引数据库（安装后必须执行）
sudo updatedb

# 测试：查找passwd相关文件
locate passwd

# 查找hostname相关文件
locate hostname

# 只输出前5条检索结果
locate passwd | head -5
```

【此处放置截图：mlocate 安装 + updatedb+locate 查询结果】
![[Pasted image 20260915180142.png]]
![[Pasted image 20260915180209.png]]

![[Pasted image 20260915180231.png]]



### 本模块避坑

> 1. 刚创建的文件 locate 搜不到，执行`sudo updatedb`刷新索引库
> 2. locate 是模糊匹配，只要路径包含关键词就输出；不能按大小、用户做复杂条件筛选
> 3. 临时目录 /tmp 内容不会录入 locate 数据库，搜不到 /tmp 下文件

---

## 模块 3 grep + 管道符 |（对应 033 集）

### 核心知识点

1. ==grep：在文件内容中匹配关键词，过滤文本行；支持正则。 语法：`grep [选项] "关键词" 文件`==
2. ==常用选项==
    - ==`-n`：输出匹配行同时显示行号==
    - ==`-i`：忽略大小写匹配==
    - ==`-v`：反向匹配，输出**不匹配**的行==
3. ==管道符 `|`：把前面命令标准输出，交给后面命令当做输入，组合多个工具。==

### 实操命令

```
# 1. 在log01.txt搜索error字符串，显示行号
grep -n "error" log01.txt

# 2. 忽略大小写搜索INFO
grep -i "info" log02.txt

# 3. 反向过滤，输出不含info的行
grep -v "info" log02.txt

# 4. 管道组合：ls -l输出交给grep过滤txt结尾文件
ls -l | grep txt

# 5. 系统实操：查看/etc/passwd，过滤study用户行
cat /etc/passwd | grep study
```

【此处放置截图：grep、管道符组合执行输出截图】
![[Pasted image 20260915181120.png]]
### 本模块避坑

> 1. 管道只传递**标准输出 stdout**；报错 stderr 错误信息不会经过管道
> 2. `-v`反向筛选，排查日志排除无用行非常常用

---

## 模块 4 压缩和解压 tar（对应 034 集，linux 最常用）

### 核心知识点

1. ==`tar`：打包压缩工具；打包 = 把多个文件合成一个文件；压缩 = 减小体积==
2. ==常用参数（**tar 参数前面可以不加横杠`-`**）==
    - ==`-c` 创建压缩包==
    - ==`-z` 使用 gzip 算法压缩，后缀`.tar.gz`==
    - ==`-v` 显示过程（verbose，看输出日志，练习用；生产去掉减少输出）==
    - ==`-f` 指定压缩包文件名，**必须写在参数最后**==
    - ==`-x` 解压==
    - ==`-C` 指定解压到哪个目标目录==

### 实操命令

```
# 1. 将当前目录全部txt文件打包压缩 test_all.tar.gz
tar -zcvf test_all.tar.gz *.txt

# 查看压缩包里面内容（不解压，只看包内文件列表）
tar -ztvf test_all.tar.gz

# 2. 解压到当前目录
tar -zxvf test_all.tar.gz

# 3. 解压到指定子目录 sub_dir01
tar -zxvf test_all.tar.gz -C ./sub_dir01
```

【此处放置截图：tar 打包、查看包内容、指定目录解压截图】
案例：
![[Pasted image 20260915172055.png]]
![[Pasted image 20260915172118.png]]
![[Pasted image 20260915172158.png]]

![[Pasted image 20260915203417.png]]


### 本模块避坑

> 1. `-f`参数必须放最后，`-zcvf test_all.tar.gz`，f 后面紧跟包名字，顺序错直接报错
> 2. `-C`大写！用来指定解压目标目录，目录必须提前存在
> 3. 生产环境脚本中 tar 去掉`-v`，避免输出大量无关日志

---

## 模块 5 zip /unzip 压缩解压（对应 034 集）

### 核心知识点

1. ==zip：windows、linux 通用压缩格式，后缀`.zip`==
2. ==CentOS Stream9 默认没有安装 zip、unzip 工具，需要 dnf 安装==
3. ==zip：打包压缩；unzip：解压 zip 包==

### 实操命令

```
# 安装zip unzip工具
sudo dnf install zip unzip -y

# 压缩：把txt文件压缩为demo.zip
zip demo.zip *.txt

# 查看zip包内容
unzip -l demo.zip

# 解压zip包到当前目录
unzip demo.zip

# 解压zip包到指定目录 sub_dir01
unzip demo.zip -d ./sub_dir01
```

【此处放置截图：zip 压缩、unzip 解压输出截图】

![[Pasted image 20260915204120.png]]

### 本模块避坑

> 1. zip 压缩命令格式：`zip 输出包名 源文件列表`，顺序不要写反
> 2. unzip 指定输出目录参数是小写`-d`，和 tar 大写`‑C`区分，不要搞混

---

## 📌day14 当日踩坑记录区域

1. find 命令通配符`*`必须加双引号，否则 shell 提前解析通配符造成查找异常；系统目录查找加 sudo。
2. locate 新创建文件搜不到，执行`sudo updatedb`手动刷新索引数据库；`/tmp`目录文件不会录入索引。
3. 管道`|`只传递正常输出，错误信息不会向后传递；grep `-v`反向过滤在排查日志高频使用。
4. tar 命令 `-f` 参数必须写在所有参数末尾，后面紧跟压缩包文件名，参数顺序错误直接破坏文件。
5. tar 解压指定目录大写`‑C`；unzip 解压指定目录是小写`‑d`，两个不要记混。
6. zip/unzip 工具 CentOS 默认不带，需要 dnf 手动安装。

## 当日自检清单

- [ ] find：掌握按名字、用户、大小、文件类型查找文件
- [ ] locate：知道索引库原理，会使用 updatedb 刷新数据库
- [ ] grep：会内容过滤，掌握`‑n`行号、`‑i`忽略大小写、`‑v`反向匹配；会搭配管道符`|`
- [ ] tar：掌握`.tar.gz`打包压缩、查看包、解压、指定目录解压
- [ ] zip/unzip：通用 zip 格式压缩解压，分清 tar `-C` 和 unzip `-d`参数

## 实操收尾

```
#练习文件全部保存在 ~/day14_test01
#可选：删除练习目录
# rm -rf ~/day14_test01
```