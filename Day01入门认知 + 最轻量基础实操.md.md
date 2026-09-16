Day01入门认知 + 最轻量基础实操

### 看课集数

001、002、003、004（倍速 1.5 倍，行业 / 学习思路）→005（Linux 介绍）→006（Linux 与 UNIX 关系）→007（Linux 与 Windows 区别）

### 今日虚拟机实操命令（入门感知，无难度）

bash

```
pwd          # 查看当前所在目录
ls           # 列出当前目录文件
ls -l        # 详细列表展示
uname -r     # 查看系统内核版本
cat /etc/os-release  # 确认CentOS Stream9系统版本

```

### ![[Pasted image 20260802212337.png|691]]笔记要点

记录 Linux 和 Windows 目录结构、文件系统核心差异，截图系统版本验证结果。

补充：vmtools工具安装
open-vm-tools 功能完全覆盖旧 vmtools：支持虚拟机与主机剪贴板互通、窗口自适应分辨率、文件拖拽、时间同步这些核心能力，适配 CentOS Stream9；
```
sudo dnf install -y open-vm-tools open-vm-tools-desktop
```
![[Pasted image 20260802213659.png]]