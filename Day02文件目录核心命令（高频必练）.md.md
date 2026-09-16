### 专属实操命令（CentOS9 适配）

### Linux目录结构

==树状目录结构==，在此结构中的最上层是根目录"/"，然后在此目录下再创建其他的目录。
==在Linux世界里，一切皆文件。==

bash

```
cd ~         # 回到家目录
cd /         # 进入根目录
mkdir test01 # 创建文件夹test01
rmdir test01 # 删除空文件夹
touch a.txt  # 创建空文件
cp a.txt ./test01/  # 复制文件
mv a.txt ./test01/  # 移动/重命名文件
rm a.txt     # 删除文件
tree ~       # 树形展示家目录（已提前安装tree工具）
```

### 避坑提醒：Linux 严格区分大小写，文件名不要用中文