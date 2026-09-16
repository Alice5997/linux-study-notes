# Linux_day11_Shell 文本处理三剑客 cut_sed_awk_sort 实操笔记

## 基础信息

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://www.bilibili.com/video/BV1dW411M7xL)
2、今日观看选集（严格对照分集清单标题）

- 073：尚硅谷 Python 定制篇_Ubuntu 安装和配置

> 说明：
> 073‑077 为 Ubuntu 内容，本次 day11 继续 CentOS Shell 三剑客拓展，不学习 Ubuntu；
> Shell 三剑客属于 shell 综合实操，承接 day08‑day10 shell 课程。 Shell 三剑客无独立分集，是 shell 综合实战，基于前面 shell 变量、循环、函数做文本处理综合练习。

3、系统环境：CentOS Stream9，登录普通用户 study 
4、全局统一规范（与 Day1~Day10 模板完全统一）

- 当日练习根目录：`~/day11_test01`
- shell 脚本统一后缀：`.sh`
- 脚本开头必须声明 `#!/bin/bash` 
5、今日练习测试目录、文件等：
- 练习测试文件：`cut_demo.txt`、`sed_demo.txt`、`awk_demo.txt`、`sort_demo.txt`
- 练习脚本：`three_swords_demo.sh`

💡补充实操命令 (默认在 `~/day11_test01` 目录执行，特殊路径单独标注)

```
# (家目录 ~ 执行)
mkdir -p ~/day11_test01
cd ~/day11_test01
```

【此处放置截图：ls 查看 day11_test01 目录初始化结果】
![[Pasted image 20260914154507.png]]
---

## 模块 1 cut 截取工具（Shell 三剑客‑截取列，适合固定分隔符）

### 核心知识点

1. ==`cut`：按**字符、分隔符**截取文本片段，提取指定列==
2. ==常用选项==
    - ==`-d`：指定分隔符==
    - ==`-f`：选取第几列，多列逗号分隔==
    - ==`-c`：按字符位置截取==
3. ==局限性：对**多个连续空格**处理效果差，多空格场景优先使用 awk==

### 实操命令

```
# 生成cut练习测试文本
cat > cut_demo.txt <<EOF
zhangsan,22,beijing
lisi,23,shanghai
wangwu,24,guangzhou
zhaoliu,25,shenzhen
EOF

# 1、逗号为分隔符，提取第1列
cut -d "," -f1 cut_demo.txt

# 2、提取第1、3列
cut -d "," -f1,3 cut_demo.txt

#3、按字符截取1‑5号字符
cut -c1-5 cut_demo.txt

#4、系统实操：从/etc/passwd 提取所有用户名，分隔符为冒号
cut -d ":" -f1 /etc/passwd
```

【此处放置截图：cut 命令各条执行输出截图】
![[Pasted image 20260914160148.png]]
![[Pasted image 20260914155325.png]]

### 本模块避坑

> 1. `-d`后面紧跟分隔符，分隔符有特殊符号要用引号包裹
> 2. cut 无法处理多个连续空格，遇到多空格日志，改用 awk

---

## 模块 2 sed 流编辑器（Shell 三剑客‑行处理，增删改查）

### 核心知识点

1. ==`sed`：流编辑器，**按行处理文本**；默认只输出到终端，不会修改源文件==
2. ==常用选项==
    - ==`-n`：只输出匹配的行==
    - ==`-i`：**直接修改源文件（高危！练习不要直接加‑i，先预览）**==
3. ==动作指令==
    - ==`p`：打印输出匹配行，配合‑n==
    - ==`d`：删除匹配行==
    - ==`s/旧字符串/新字符串/g`：替换，`g`代表全局全部替换==

### 实操命令

```
#复用cut_demo.txt作为sed练习素材，复制一份
cp cut_demo.txt sed_demo.txt

#1、只打印匹配lisi的行（‑n + p组合）
sed -n '/lisi/p' sed_demo.txt

#2、预览删除包含zhangsan的行，源文件不会改动
sed '/zhangsan/d' sed_demo.txt

#3、预览全局替换shanghai→hangzhou
sed 's/shanghai/hangzhou/g' sed_demo.txt

#4、⚠️加‑i，真正修改源文件，把22替换成99
sed -i 's/22/99/g' sed_demo.txt

#查看修改之后文件内容
cat sed_demo.txt
```

【此处放置截图：sed 预览、‑i 修改源文件前后对比截图】
![[Pasted image 20260914161859.png]]
重新载入
![[Pasted image 20260914161918.png]]
### 本模块避坑

> 1. ==**`‑i`谨慎使用！先去掉‑i 在终端预览结果，确认效果后再加‑i 写回磁盘**==
> 2. ==sed 匹配模式用`//`包裹，如果内容包含斜杠 /，可以换成别的分隔符如`s#old#new#g`==

---

## 模块 3 awk 文本分析工具（Shell 三剑客‑列处理，功能最强）

### 核心知识点

1. `==awk`：完整文本分析语言，支持条件判断、变量、内置变量，适合日志解析==
2. ==语法格式：`awk [‑F分隔符] '条件{执行动作}' 文件名==`
3. 高频内置变量
    
    表格
    
    |变量|含义|
    |---|---|
    |`$0`|输出完整一整行|
    |`$1 $2`|第 1 列、第 2 列|
    |`NR`|当前行号|
    |`NF`|当前行总共有多少列，`$NF`取最后一列|
    |`FS`|输入分隔符|
    

### 实操命令

```
cp cut_demo.txt awk_demo.txt

#1、指定逗号分隔，打印第1列、第3列
awk -F "," '{print $1,$3}' awk_demo.txt

#2、打印行号NR + 整行$0
awk '{print NR,$0}' awk_demo.txt

#3、条件过滤：第二列年龄大于23的行输出
awk -F "," '$2>23 {print $0}' awk_demo.txt

#4、打印每一行的最后一列 $NF
awk -F "," '{print $NF}' awk_demo.txt

#5、系统实操：读取/etc/passwd，输出用户名和登录shell
awk -F ":" '{print $1,"--->",$7}' /etc/passwd
```

【此处放置截图：awk 各个案例运行输出截图】
![[Pasted image 20260914160745.png]]

### 本模块避坑

> 1. awk 的处理逻辑代码必须用**单引号**包裹，双引号会造成 shell 变量解析错乱
> 2. 比较表达式两边需要空格；`$2>23`条件可以不加空格，但规范写法保留空格

---

## 模块 4 sort 排序工具

### 核心知识点

1. ==`sort`：对文本行做排序，**默认字典序排序（按字符 ASCII 码）**==
2. ==常用选项==
    - ==`-n`：开启**数字排序**，解决字典序 10<2 的问题==
    - ==`-r`：倒序（降序）==
    - ==`-k`：指定按第几列排序==
    - ==`-t`：指定列分隔符==

### 实操命令

```
cat > sort_demo.txt <<EOF
zhangsan 23
lisi 21
wangwu 25
zhaoliu 19
qianqi 30
EOF

#1、默认字典序排序
sort sort_demo.txt

#2、以第二列为依据，数字升序
sort -k2 -n sort_demo.txt

#3、第二列数字，倒序
sort -k2 -nr sort_demo.txt

#4、三剑客管道组合示例：awk提取名字，再sort排序
awk '{print $1}' sort_demo.txt | sort
```

【此处放置截图：sort 字典序、数字升序、倒序输出截图】
![[Pasted image 20260914162918.png]]

### 本模块避坑

> ==不加`‑n`时数字按字典排序，`10`会排在`2`前面；**数字排序务必带上‑n 参数**。==

---

## 模块 5 Shell 三剑客综合脚本练习

> 模块执行目录：`~/day11_test01`

### 核心知识点

==管道符`|`：把前一条命令输出，交给后一条命令作为输入；cut/sed/awk/sort 大量配合管道完成复杂文本过滤。==

### 实操命令

```
vim three_swords_demo.sh
```

脚本`three_swords_demo.sh`完整内容：

```
#!/bin/bash
#三剑客综合练习脚本
FILE=cut_demo.txt

echo "=====1.awk筛选年龄大于23的用户名===="
awk -F "," '$2>23 {print $1}' $FILE | sort

echo "=====2.sed过滤，只保留北京、上海用户===="
sed -n '/beijing\|shanghai/p' $FILE

echo "=====3.cut提取第三列城市，再sort排序===="
cut -d "," -f3 $FILE | sort
```

```
chmod u+x three_swords_demo.sh
./three_swords_demo.sh
```

【此处放置截图：综合脚本执行输出截图】
![[Pasted image 20260914164635.png]]
Xshell
![[Pasted image 20260914164701.png]]

---

## 补充：当日踩坑记录区域

1. ==cut 适合简单固定分隔符；**多个连续空格优先用 awk，cut 处理会错乱**。==
2. ==sed `-i`参数直接修改磁盘文件，练习阶段**先去掉‑i 预览，确认输出再写回源文件**。==
3. ==awk 条件动作部分必须用**单引号**，双引号会被 shell 解析变量导致脚本异常==。
4. ==sort 默认字典序，处理数字大小排序，必须加`‑n`，否则`10 < 2`。==
5. ==管道符`|`是把标准输出传递给下一条命令，错误 stderr 输出不会被管道传递。==

## 当日自检清单

- [ ] ==掌握 cut：`‑d`分隔符、`‑f`列选择、`‑c`按字符截取==
- [ ] ==掌握 sed：打印 p、删除 d、替换 s///g，分清预览模式和‑i 修改源文件==
- [ ] ==掌握 awk：`‑F`指定分隔符；内置变量`$0 $1 NR NF $NF`；条件过滤==
- [ ] ==掌握 sort：`‑n`数字排序、`‑r`倒序、`‑k`指定排序列==
- [ ] ==可以使用管道`|`串联 cut/sed/awk/sort 完成综合文本过滤任务==

## 实操收尾

```
#练习文件全部保存在 ~/day11_test01
#可选：删除练习目录
# rm -rf ~/day11_test01
```