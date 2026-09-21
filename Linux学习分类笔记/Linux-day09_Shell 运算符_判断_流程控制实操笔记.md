# Linux_day09_Shell 运算符_判断_流程控制实操笔记

> 完全对齐 Day07 笔记模板风格，分集严格对照 77 集清单：063、064、065、066、067、068

## 基础信息

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh) 
2、今日观看选集：063、064、065、066、067、068

- 063：尚硅谷_大数据定制篇_Shell 运算符
- 064：尚硅谷_大数据定制篇_Shell 判断语句
- 065：尚硅谷_大数据定制篇_Shell 流程控制 if
- 066：尚硅谷_大数据定制篇_Shell 流程控制 case
- 067：尚硅谷_大数据定制篇_Shell 流程控制 for
- 068：尚硅谷_大数据定制篇_Shell 流程控制 while

3、系统环境：CentOS Stream9，普通用户 study 
4、今日练习测试目录、文件等：

- 当日总目录：`~/day09_test01`
- 测试脚本：`calc.sh`、`judge.sh`、`if_demo.sh`、`case_demo.sh`、`for_demo.sh`、`while_demo.sh`

5、使用规则：所有命令手动输入，禁止复制；每步执行完成后，在笔记对应标记处插入终端截图。
吃的。
💡补充实操命令 (默认在 `~/day09_test01` 目录执行，特殊路径单独标注)

```
# (家目录 ~ 执行)
mkdir -p ~/day09_test01
cd ~/day09_test01
```

【此处放置截图：ls 查看 day09_test01 目录初始化结果】
![[Pasted image 20260820222549.png]]

## 模块 1 Shell 运算符（对应 063 集）

### 核心知识点

1. shell 中算术运算不能直接`+ - * /`，使用 `$((运算式))` 或者 `$[运算式]`做整数运算
2. ==`expr`==命令运算，运算符两侧==**必须有空格**==，乘法`*`需要转义`\*`
3. shell 只支持整数运算，不支持小数浮点数

### 实操命令

```
vim calc.sh
```

calc.sh 写入内容：

```
#!/bin/bash
#expr方式运算
res1=`expr 2 + 3`
echo "2+3=$res1"

res2=`expr 5 \* 4`
echo "5*4=$res2"

# $[] 方式运算
res3=$[10-2]
echo "10-2=$res3"

# $(())方式运算
res4=$((6/2))
echo "6/2=$res4"
```

```
chmod u+x calc.sh
./calc.sh
```

【此处放置截图：calc.sh 脚本内容、运算输出结果截图】
![[Pasted image 20260820223323.png]]
### 本模块避坑

> 1. ==expr 运算符两边必须空格；乘法符号`*`必须写成`\*`==，否则报错
> 2. shell 原生==只支持整数计算==，小数计算需要借助 bc 工具

---

## 模块 2 Shell 判断语句（对应 064 集）

### 核心知识点

1. 判断语法：==`[ 条件 ]`，**中括号两边必须留空格**==，高频踩坑
2. 数值比较：
	 ==`-eq`等于==
	 ==`-ne`不等于==
	 ==`-gt`大于==
	 ==`-ge`大于等于==
	 ==`-lt`小于==
	 ==`-le`小于等于==
3. 字符串比较：
	 ==`=`相等==
	 ==`!=`不相等==
4. 文件权限判断：
	 ==`-r`读权限==
	 ==`-w`写权限==
	 ==`-x`执行权限==
5. 文件存在判断：
	==`-f`普通文件==
	==`-d`目录==
	==`-e`文件存在==

### 实操命令

```
vim judge.sh
```

judge.sh 脚本内容：

```
#!/bin/bash
a=10
b=20

#数值判断 a是否小于b
if [ $a -lt $b ]
then
  echo "$a 小于 $b"
fi

#字符串判断 字符串abc是否等于abc
if [ "abc" = "abc" ]
then
  echo "字符串相等"
fi

#判断文件是否存在
if [ -e ./calc.sh ]
then
  echo "calc.sh 文件存在"
fi
```

```
chmod u+x judge.sh
./judge.sh
```

【此处放置截图：judge.sh 运行输出截图】
![[Pasted image 20260820224553.png]]
### 本模块避坑

> `[ 条件 ]` 中括号内侧**必须有空格**，少空格直接语法报错。

---

## 模块 3 流程控制 if 判断（对应 065 集）

### 核心知识点

1. if 语法格式，分单分支、双分支、多分支
2. `if [];then` 可以分多行写，也可以；同行分隔
3. ==elif 是 shell 关键字==，不能写成 else if

```
if [条件]
then
  逻辑
elif [条件]
then
  逻辑
else
  逻辑
fi
```

### 实操命令

```
vim if_demo.sh
```

if_demo.sh 脚本：

```
#!/bin/bash
#接收传入第一个参数做分数判断
score=$1
if [ $score -ge 90 ]
then
  echo "优秀"
elif [ $score -ge 60 ]
then
  echo "及格"
else
  echo "不及格"
fi
```

```
chmod u+x if_demo.sh
./if_demo.sh 95
./if_demo.sh 70
./if_demo.sh 40
```

【此处放置截图：if 多分支脚本，不同参数运行结果截图】
![[Pasted image 20260820225138.png]]
### 本模块避坑

> ==elif 连写，不能分开写 else if；if 语句结尾必须写 fi 闭合。==

---

## 模块 4 流程控制 case 分支（对应 066 集）

### 核心知识点

1. case 匹配语法，变量匹配不同模式==；`*)`相当于 default 默认分支==
2. 每个匹配项==结尾 `;;`== 不能省略
3. case 格式：

```
case $变量 in
"值1")
  命令
;;
"值2")
  命令
;;
*)
  默认执行命令
;;
esac
```

### 实操命令

```
vim case_demo.sh
```

case_demo.sh 脚本：

```
#!/bin/bash
case $1 in
"1")
  echo "输入的是1"
;;
"2")
  echo "输入的是2"
;;
*)
  echo "其他数字"
;;
esac
```

```
chmod u+x case_demo.sh
./case_demo.sh 1
./case_demo.sh 5
```

【此处放置截图：case 脚本执行输出截图】
![[Pasted image 20260820225648.png]]
### 本模块避坑

> 每个 case 分支==后面必须加`;;`==；case 结构必须以==`esac`结尾闭合==。

---

## 模块 5 for 循环（对应 067 集）

### 核心知识点

1. for 第一种格式：`for 变量 in 值1 值2 值3...`
2. for 第二种 C 语言风格格式：`((i=1;i<=10;i++))`
3. `$*`与`$@`在 for 循环加双引号之后行为差异重点练习

### 实操命令

```
vim for_demo.sh
```

for_demo.sh 完整脚本：

```
#!/bin/bash
#方式1 in遍历
for i in 1 2 3 4
do
 echo "数字=$i"
done

echo "===========C风格for循环==========="
#计算1~10累加和
sum=0
for((i=1;i<=10;i++))
do
 sum=$[$sum+$i]
done
echo "1到10总和=$sum"
```

```
chmod u+x for_demo.sh
./for_demo.sh
```

【此处放置截图：for 循环运行输出截图】
![[Pasted image 20260820230305.png]]
### 本模块避坑

> ==C 语言风格 for 循环是双小括号`(( ))`==，不要和`[ ]`判断括号搞混。

---

## 模块 6 while 循环（对应 068 集）

### 核心知识点

1. while 循环语法：`while [ 条件 ] ; do 循环体 done`
2. ==条件为 true 就一直循环==，注意自增变量防止死循环

### 实操命令

```
vim while_demo.sh
```

while_demo.sh 脚本：

```
#!/bin/bash
#while实现1~10求和
i=1
sum=0
while [ $i -le 10 ]
do
 sum=$[$sum+$i]
 i=$[$i+1]
done
echo "while计算1~10总和：$sum"
```

```
chmod u+x while_demo.sh
./while_demo.sh
```

【此处放置截图：while 循环求和输出截图】
![[Pasted image 20260820231042.png]]
### 本模块避坑

> ==循环内部一定要做变量自增，忘记自增会进入死循环==；死循环终端按`Ctrl+C`终止。

---

## 补充：当日踩坑记录区域

1. ==`[ 条件 ]` 中括号内侧必须保留空格，缺少空格直接语法报错。==
2. ==expr 做算术运算，运算符两边要有空格，乘法`*`必须转义`\*`。==
3. ==shell 只原生支持整数运算，不能直接计算小数。==
4. ==if 多分支关键字是`elif`，不能写成`else if`；if 结尾必须 fi 闭合。==
5. ==case 每个分支末尾`;;`不能漏，结尾必须 esac 闭合。==
6. ==while 循环记得变量自增，否则死循环，`Ctrl+C`退出死循环脚本。==

## 当日自检清单

- [ ] 使用`expr`、`$[]`、`$(())`完成整数算术运算
- [ ] 掌握`[ ]`条件判断：数值比较、字符串、文件状态判断
- [ ] 会写 if 单分支、双分支、多分支 elif 流程
- [ ] case 多分支匹配，掌握`;;`、`*)`默认分支
- [ ] 两种 for 循环写法：in 遍历、C 语言双括号 for 循环
- [ ] while 循环实现循环求和，会避免死循环

## 实操收尾

```
#练习文件全部保存在 ~/day09_test01
#可选：删除练习目录
# rm -rf ~/day09_test01
```