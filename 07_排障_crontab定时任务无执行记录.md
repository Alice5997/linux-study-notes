# 排障记录 07：crontab 定时任务没有执行记录

> 模块 5（crontab 定时任务）实操排障
> 日期：2026-09-20
> 环境：CentOS Stream9 / 用户 study / 主机 linux-study01

---

## 一、故障现象

按笔记配置了"每天凌晨 2 点执行 cleanup_logs.sh"，但：

1. 到 `/var/log/cron` 里查不到 cleanup_logs.sh 的任何执行记录
2. 手动执行脚本直接报错：

```
[study@localhost ~]$ bash /home/study/shell_test/scripts/cleanup_logs.sh
bash: /home/study/shell_test/scripts/cleanup_logs.sh: 没有那个文件或目录
```

【此处放置截图：bash 手动执行报错"没有那个文件或目录"】
路径写错了
![[Pasted image 20260920180526.png]]
---

## 二、排查过程

### 步骤 1：查 cron 日志，看任务到底跑没跑

```
# (任意目录执行)
sudo tail -50 /var/log/cron
```

观察到的关键信息（2026-09-20 16:58 ~ 17:11）：

```
Sep 20 17:01:01 localhost CROND[42423]: (study) CMDEND (/home/study/day04_test01/day04_backup.sh)
Sep 20 17:01:01 localhost CROND[42419]: (study) CMDEND (date >> /home/study/day04_test01/day04_time_log.txt)
Sep 20 17:02:01 localhost CROND[42469]: (study) CMDEND (/home/study/day04_test01/day04_backup.sh)
...（每分钟都是 day04 的两个旧任务）
```

**结论**：日志里**没有一行**是 cleanup_logs.sh；但 day04 的任务每分钟准点执行。

【此处放置截图：/var/log/cron 输出，全是 day04 旧任务】
![[Pasted image 20260920180609.png]]
### 步骤 2：确认脚本文件是否存在

```
# (任意目录执行)
ls -l ~/shell_test/scripts/
ls -l ~/shell_test/
```

**结论**：脚本其实是存在的（`ls -l ~/shell_test/scripts/` 能看到 `cleanup_logs.sh`，696 字节），但权限是 `-rw-r--r--`，**没有执行权限（x）**，所以 cron 直接执行该脚本路径时报 Permission denied。

【此处放置截图：ls -l 查看 cleanup_logs.sh 权限为 -rw-r--r--】
![[Pasted image 20260920180823.png]]

### 步骤 3：确认 crontab 里到底有什么任务

```
# (任意目录执行)
crontab -l
```

**结论**：crontab 里其实已经有 `0 2 * * * /home/study/shell_test/scripts/cleanup_logs.sh` 这一行（之前 day04 的旧任务也在）。任务是**凌晨 2 点**执行，而查日志的时间是下午 17:xx——**还没到执行时间**，所以日志里当然没有它的记录。

【此处放置截图：crontab -l 已包含 cleanup 任务，表达式为 0 2 * * *】
![[Pasted image 20260920180652.png]]
---

## 三、根因

不是 cron 服务故障，是两个原因叠加：

| # | 问题 | 说明 |
|---|---|---|
| 1 | **脚本没有执行权限** | `cleanup_logs.sh` 权限是 `-rw-r--r--`，缺少 x 权限。crontab 直接写脚本绝对路径，cron 执行时需要 x 权限，否则 Permission denied |
| 2 | **查日志时还没到执行时间** | 任务表达式是 `0 2 * * *`（凌晨 2 点），下午 17:xx 查日志，当然没有它的执行记录 |

cron 服务本身完全正常（day04 任务每分钟都准点跑），不需要重启 crond。

---

## 四、解决方案（按顺序执行）

```
# ① 重新创建脚本（完整粘贴笔记里的 cleanup_logs.sh 内容）
# (~/shell_test 目录执行)
vim ~/shell_test/scripts/cleanup_logs.sh
#   按 i 进入插入模式，粘贴脚本内容
#   按 Esc，输入 :wq 保存退出
chmod +x ~/shell_test/scripts/cleanup_logs.sh

# ② 手动执行，验证脚本本身没语法错误
bash ~/shell_test/scripts/cleanup_logs.sh
echo $?              # 应输出 0
ls ~/shell_test/logs/   # cleanup.log 应该生成

# ③ 追加定时任务（crontab -e 是"编辑现有文件"，不要把 day04 旧任务删掉）
crontab -e
# 在末尾新增一行：
0 2 * * * /home/study/shell_test/scripts/cleanup_logs.sh

# ④ 验证任务已写入
crontab -l

# ⑤ 不等凌晨2点，临时改成"每分钟执行一次"快速验证
crontab -e
# 把 0 2 改成：
* * * * * /home/study/shell_test/scripts/cleanup_logs.sh

# ⑥ 等 1~2 分钟后查日志，应该能看到 cleanup_logs.sh 的执行记录
sudo tail -20 /var/log/cron
# 预期看到：
# CROND[xxxx]: (study) CMDEND (/home/study/shell_test/scripts/cleanup_logs.sh)

# ⑦ 验证通过后，改回凌晨2点
crontab -e
# 把 * * * * * 改回：
0 2 * * * /home/study/shell_test/scripts/cleanup_logs.sh

# ⑧ 最终确认
crontab -l
```

【此处放置截图：步骤 ② 手动执行成功输出】
【此处放置截图：步骤 ④ crontab -l 已包含 cleanup 任务】
【此处放置截图：步骤 ⑥ /var/log/cron 出现 cleanup_logs.sh 执行记录】
【此处放置截图：步骤 ⑧ 最终 crontab -l 恢复为 0 2 * * *】

最终解决过程
![[Pasted image 20260920180733.png]]
---

## 五、避坑点

1. **脚本必须有执行权限（x）**：crontab 里直接写脚本绝对路径时，cron 需要 x 权限才能执行；`chmod u+x 脚本` 或 `chmod +x 脚本` 即可。没有 x 权限会 Permission denied。
2. **cron 日志里没有任务记录 ≠ cron 服务坏了**。先看日志里有没有其他任务在跑——如果有（比如 day04 任务每分钟在跑），说明服务正常，问题出在"你压根没配这条任务"。
3. **`crontab -e` 是编辑当前文件，不是新建空文件**。之前 day04 配的任务还在，追加新行即可，别误删旧任务。
4. **crontab 里的路径必须是绝对路径**，不能写 `~/shell_test/...`，要写 `/home/study/shell_test/...`。
5. **不要等凌晨 2 点才验证**。临时把表达式改成 `* * * * *`（每分钟跑），1~2 分钟就能看到日志，验证完再改回 `0 2 * * *`。
6. **脚本必须有执行权限**：`chmod +x`，否则 cron 会报 Permission denied。
7. **排查顺序**：`crontab -l` 看任务在不在 → `ls -l` 看脚本在不在 → 手动 `bash 脚本` 看脚本能不能跑 → `/var/log/cron` 看执行记录。不要一上来就重启 crond。
8. **vim 保存退出**：`i` 插入 → `Esc` → `:wq` 保存退出；如果只是 `:q!` 就是没保存。

---

## 六、最终结论

- 故障根因：① 脚本缺少执行权限（-rw-r--r--，没 x）；② crontab 表达式是凌晨 2 点，下午查日志时还没到执行时间
- 解决：`chmod u+x cleanup_logs.sh` 加权限 → crontab 临时改成 `* * * * *` 每分钟执行 → 1~2 分钟后 `/var/log/cron` 看到 CMD/CMDEND 记录 → 改回 `0 2 * * *`
- 状态：☑ 已解决（17:48、17:49、17:50 每分钟均有执行记录）
