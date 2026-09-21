# Linux 第一天入门实操清单（CentOS9）

要求：全部手动敲命令，禁止复制；做完一条观察输出，理解作用

登录用户：study（普通用户，不要随便切 root）

## 一、基础目录浏览命令

## 1. 查看当前所在位置

pwd
![[Pasted image 20260802222613.png]]

## 2. 列出当前目录文件

ls
![[Pasted image 20260802222646.png]]
## ls -l  详细信息（权限、大小、时间）
![[Pasted image 20260802222729.png]]
## ls -lh  文件大小人性化显示
![[Pasted image 20260802222801.png]]
## ls -a  显示隐藏文件
![[Pasted image 20260802222817.png]]
## 3. 切换目录

### cd /  进入根目录
![[Pasted image 20260802222845.png]]
### cd ~  回到自己家目录 /home/study
![[Pasted image 20260802222905.png]]
### cd ..  回到上一级目录
![[Pasted image 20260802222920.png]]
### cd -  在最近两个目录来回跳转
![[Pasted image 20260802222935.png]]
## 二、文件夹 / 文件创建、删除、复制、移动

## 1. 在家目录创建当日总练习文件夹 day01_test01

mkdir ~/day01_test01

![[Pasted image 20260802223050.png]]
![[Pasted image 20260802223429.png]]# 创建多层嵌套目录 day01_test01/demo/test

mkdir ==-p== ~/day01_test01/demo/test
![[Pasted image 20260802223142.png]]
![[Pasted image 20260802223513.png]]2. 进入主练习文件夹

cd ~/day01_test01
![[Pasted image 20260802223220.png]]
### 3. touch创建空白测试文件

touch day01_file01.txt day01_file02.txt
![[Pasted image 20260802223316.png]]
![[Pasted image 20260802223536.png]]4. cp复制文件

cp day01_file01.txt day01_file01_bak01.txt
![[Pasted image 20260802223653.png]]
![[Pasted image 20260802223724.png]]# 复制文件夹（必须加 -r）

cp -r demo demo_bak01
![[Pasted image 20260802223820.png]]
### 5. mv移动 / 重命名

mv day01_file02.txt day01_file02_rename.txt
![[Pasted image 20260802224004.png]]
### 6. rm删除文件（谨慎使用！）

rm day01_file02_rename.txt
![[Pasted image 20260802224056.png]]
# 删除文件夹

rm -r demo_bak01
![[Pasted image 20260802224150.png]]
## 三、文件查看命令

# 创建一段测试文本

echo "hello linux 运维学习" > day01_file03.txt
![[Pasted image 20260802224528.png]]
cat day01_file03.txt # 一次性查看全部内容
![[Pasted image 20260802224616.png]]
more day01_file03.txt # 分页查看（空格翻页 q 退出）

less day01_file03.txt # 增强分页（推荐）
![[Pasted image 20260802224726.png]]
# 追加文字 >>

echo "第二行内容" >> day01_file03.txt
![[Pasted image 20260802224944.png]]
## 四、vim 极简操作（重中之重，运维必备）

vim day01_file03.txt

操作步骤：

1. 按下 i 进入编辑模式

2. 随便输入文字

3. 按 Esc

4. 输入:wq 保存并退出

拓展: :q! 不保存强制退出
![[Pasted image 20260802225330.png]]![[Pasted image 20260802225455.png]]