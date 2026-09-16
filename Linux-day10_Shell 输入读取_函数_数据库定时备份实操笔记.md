# Linux_day10_Shell 输入读取_函数_数据库定时备份实操笔记

## 基础信息

1、课程地址：[https://www.bilibili.com/video/BV1dW411M7xL](https://link.wtturl.cn/?target=https%3A%2F%2Fwww.bilibili.com%2Fvideo%2FBV1dW411M7xL&scene=im&aid=582478&lang=zh) 
2、今日观看选集：069、070、071、072

- 069：尚硅谷_大数据定制篇_Shell 读取控制台输入
- 070：尚硅谷_大数据定制篇_Shell 系统函数简介
- 071：尚硅谷_大数据定制篇_Shell 自定义函数
- 072：尚硅谷_大数据定制篇_Shell 定时维护数据库

3、系统环境：CentOS Stream9，普通用户 study 
4、今日练习测试目录、文件等：

- 当日总目录：`~/day10_test01`
- 备份存放目录：`~/day10_test01/db_backup`
- 测试脚本：`read_demo.sh`、`sys_func_demo.sh`、`self_func_demo.sh`、`db_backup.sh`

5、使用规则：所有命令手动输入，禁止复制；每步执行完成后，在笔记对应标记处插入终端截图。

💡补充实操命令 (默认在 `~/day10_test01` 目录执行，特殊路径单独标注)

```
# (家目录 ~ 执行)
mkdir -p ~/day10_test01/db_backup
cd ~/day10_test01
```

【此处放置截图：ls 查看 day10_test01 目录初始化结果】

---
![[Pasted image 20260911183550.png]]

## 模块 1 Shell 读取控制台输入（对应 069 集）

### 核心知识点

1. `read`命令读取控制台键盘输入；
2. `read [选项] 变量名`
    - `-p`：提示文字；
    - 
    - `-t`：设置等待输入超时时间（秒），超时自动结束；
3. 用户输入内容赋值给 shell 变量。

### 实操命令

```
vim read_demo.sh
```

read_demo.sh 写入内容：

```
#!/bin/bash
#读取控制台输入
read -p "请输入您的姓名：" username
echo "您输入的姓名是：$username"

#带超时时间，10秒不输入自动退出
read -t 10 -p "请输入年龄(10秒内输入)：" age
echo "您的年龄：$age"
```

```
chmod u+x read_demo.sh
./read_demo.sh
```

【此处放置截图：read_demo.sh 脚本内容、控制台输入交互输出截图】
![[Pasted image 20260911185131.png]]
### 本模块避坑

> `-t`超时之后，变量为空；执行脚本等待输入时，无输入不要一直卡住，记住超时机制。

---

## 模块 2 Shell 系统函数简介（对应 070 集）

### 核心知识点

1. `basename`：获取路径中的文件名；`basename 路径 [后缀]`，可以切掉文件后缀
2. `dirname`：获取路径中的目录部分，去掉文件名
3. 系统函数直接在脚本或者命令行调用，不需要自己定义。

### 实操命令

```
vim sys_func_demo.sh
```

sys_func_demo.sh 脚本内容：

```
#!/bin/bash
filepath="/home/study/day10_test01/test.txt"

#获取文件名
filename=`basename $filepath`
echo "文件全名：$filename"

#获取文件名，去掉后缀.txt
name2=`basename $filepath .txt`
echo "去掉后缀文件名：$name2"

#获取目录路径
dirpath=`dirname $filepath`
echo "文件所在目录：$dirpath"
```

```
chmod u+x sys_func_demo.sh
./sys_func_demo.sh
```

【此处放置截图：sys_func_demo.sh 运行输出截图】
![[Pasted image 20260911190250.png]]
正确输出：
![[Pasted image 20260911190438.png]]
错误原因 ：这里的引号不是引号，是反引号
### 本模块避坑

> basename、dirname 只做字符串切割，**不会去校验文件是否真实存在**，仅仅处理文本字符串。

---

## 模块 3 Shell 自定义函数（对应 071 集）

### 核心知识点

1. 函数定义格式：

```
[function] 函数名[()]
{
    逻辑代码;
    [return n;]
}
```

2. 函数必须**先定义，后调用**；写在脚本开头。
3. return 返回值，只能是 0‑255 整数；调用函数后用`$?`接收返回状态。
4. 给函数传参：调用函数后面直接跟参数，函数内部使用`$1 $2`获取参数。

### 实操命令

```
vim self_func_demo.sh
```

self_func_demo.sh 脚本：

```
#!/bin/bash
#定义求和函数
function sum(){
    s=$[$1 + $2]
    echo "两数之和：$s"
    return $s
}

#调用函数，传入两个参数 10 20
sum 10 20
#获取函数return返回值
echo "函数return返回值：$?"
```

```
chmod u+x self_func_demo.sh
./self_func_demo.sh
```

【此处放置截图：self_func_demo.sh 运行输出截图】
![[Pasted image 20260911204110.png]]

### 本模块避坑

1. shell 函数`return`只能返回 0‑255 之间数字；大于 255 结果会溢出。
2. 函数一定要先定义再调用，顺序写反直接报错。

---

## 模块 4 Shell 定时维护数据库（对应 072 集）

### 核心知识点

1. `mysqldump`数据库备份命令，mariadb 自带； `mysqldump -u用户名 -p密码 数据库名 > 备份文件路径`
2. 结合`date`命令生成带时间戳的备份文件名，防止备份覆盖旧文件；
3. 使用`crontab`定时任务，定时执行备份脚本，实现定时数据库备份。
4. 备份目录提前创建，避免路径不存在备份失败。

### 实操命令

```
vim db_backup.sh
```

db_backup.sh 完整脚本：

```
#!/bin/bash
#数据库定时备份脚本
#备份存放目录
BACKUP_DIR=/home/study/day10_test01/db_backup
#数据库信息
DB_USER=root
DB_PASSWD="Root@123456"
DB_NAME=testdb

#获取当前时间作为备份文件名
TIME=$(date +%Y%m%d_%H%M%S)

#执行备份
mysqldump -u$DB_USER -p$DB_PASSWD $DB_NAME > $BACKUP_DIR/${DB_NAME}_${TIME}.sql

echo "数据库备份完成，备份文件：${BACKUP_DIR}/${DB_NAME}_${TIME}.sql"
```

> ⚠️注意：把脚本中 DB_PASSWD 修改为你自己 mariadb 的 root 密码。

```
chmod u+x db_backup.sh
#手动执行一次，测试备份是否正常
./db_backup.sh
#查看备份目录是否生成sql备份文件
ls ~/day10_test01/db_backup
```

【此处放置截图：db_backup.sh 脚本、手动执行备份、查看备份文件截图】
![[Pasted image 20260911211903.png]]
![[Pasted image 20260911212000.png]]
![[Pasted image 20260911211929.png]]
![[Pasted image 20260911212013.png]]
优化脚本：增加命令返回值判断（解决【报错了还提示备份完成】这个 bug）

```
#执行备份
mysqldump -u$DB_USER -p$DB_PASSWD $DB_NAME > $BACKUP_DIR/${DB_NAME}_${TIME}.sql

#判断mysqldump执行结果
if [ $? -eq 0 ];then
  echo "✅数据库备份完成，备份文件：${BACKUP_DIR}/${DB_NAME}_${TIME}.sql"
else
  echo "❌数据库备份失败！"
fi
```
![[Pasted image 20260911212558.png]]




### 设置 crontab 定时任务（任意目录执行）

```
#编辑当前study用户定时任务
crontab -e
```

写入内容（示例：每天凌晨 2 点执行数据库备份脚本）

```
0 2 * * * /home/study/day10_test01/db_backup.sh >> /home/study/day10_test01/backup.log
```

```
#查看已配置定时任务
crontab -l
```

【此处放置截图：crontab 编辑、crontab‑l 查看定时任务截图】
![[Pasted image 20260911213013.png]]

### 本模块避坑

1. mysqldump 密码写脚本属于练习环境；生产环境不建议脚本明文写数据库密码。
2. crontab 执行脚本尽量写**绝对路径**，避免环境变量缺失脚本执行失败。
3. date 时间格式`%Y%m%d`不要写错，百分号在 crontab 里面需要转义。

---

## 补充：当日踩坑记录区域

1. `read -t`超时后变量为空，脚本不会报错，容易忽略。
2. basename、dirname 仅做字符串切割，不校验文件真实存在。
3. shell 自定义函数 return 返回值范围只能 0‑255，超过会溢出。
4. 函数必须先定义后调用，顺序颠倒脚本执行异常。
5. mysqldump 备份脚本，crontab 定时调用全部使用绝对路径，防止定时任务环境变量缺失。
6. crontab 里面 date 命令的`%`符号是特殊符号，需要转义`\%`。
7. 脚本内明文写数据库密码仅练习使用，生产环境禁止。

## 当日自检清单

- [ ] 使用`read`完成控制台读取输入，掌握`‑p`提示、`‑t`超时参数
- [ ] 会使用系统函数`basename`、`dirname`切割路径文件名
- [ ] 能够编写自定义 shell 函数，传参调用，接收 return 返回值
- [ ] 使用`mysqldump`手动完成 mariadb 数据库备份，生成带时间戳备份文件
- [ ] 使用`crontab -e`配置定时任务，实现定时执行备份脚本

## 实操收尾

```
#练习文件全部保存在 ~/day10_test01
#可选：删除练习目录
# rm -rf ~/day10_test01
```