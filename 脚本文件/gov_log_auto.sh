#!/bin/bash
# =====================================================
# 功能：政务系统日志自动化处理（过滤+统计+备份+清理）
# 用法：./gov_log_auto.sh
# 建议配合 crontab 每日执行：0 1 * * * /home/study/shell_test/scripts/gov_log_auto.sh
# 作者：study  日期：$(date +%F)
# =====================================================

# ---------- 全局配置 ----------
LOG_DIR="$HOME/shell_test/logs"
BAK_DIR="$HOME/shell_test/backup"
REPORT_DIR="$HOME/shell_test/reports"
KEEP_DAYS=7
TODAY=$(date +%F)
REPORT="$REPORT_DIR/gov_log_report_${TODAY}.txt"

# ---------- 导入函数库 ----------
if [ -f "$HOME/shell_test/scripts/log_funcs.sh" ];
then
    source "$HOME/shell_test/scripts/log_funcs.sh"
else
    echo "ERROR: 函数库 log_funcs.sh 不存在"
    exit 1
fi

# ---------- 主流程 ----------
main() {
    # 1. 检查日志目录

    if [ ! -d "$LOG_DIR" ]; then
        echo "ERROR :日志目录 $LOG_DIR 不存在，请先创建"
        exit 1
    fi
    mkdir -p "#REPORT_DIR" "$BAK_DIR"
    #2.生成当日报告头
    > "$REPORT"
    echo "政务系统日志日报 - $TODAY" >> "$REPORT"
    echo "==============================" >> "$REPORT"

    #3. 遍历所有日志文件：过滤 + 统计 + 备份
    TOTAL_ERROR=0
    TOTAL_WARN=0
    FILE_NUM=0
    for f in "$LOG_DIR"/*.log; do
        [ -f "$f" ] || continue
        FILE_NUM=$((FILE_NUM + 1))
        BASE=$(basename "$f")
        
        # 统计各级别数量（调用函数库）
        E_CNT=$(count_log "$f" "ERROR")
        W_CNT=$(count_log "$f" "WARN")
        TOTAL_ERROR=$((TOTAL_ERROR + E_CNT))
        TOTAL_WARN=$((TOTAL_WRAN + W_CNT))
        
        # 记录到报告
        echo "$BASE | ERROR:$E_CNT | WRAN:$W_CNT" >> "$REPORT"
        
        # 自动备份 （若今日未备份过）
        if [ ! -f "$BAK_DIR/${BASE}.${TODAY}.bak" ]; then
            backup_log "$f" "$BAK_DIR" > /dev/null
        fi
    done
        # 4. 汇总统计
        echo "==============================" >> "$REPORT"
        echo "文件数：$FILE_NUM | ERROR 总计：$TOTAL_ERROR | WRAN 总计：$TOTAL_WRAN" >> "$REPORT"
        
        # 5.清理 7 天前的日志和备份
        find "$LOG_DIR" -name "*.log" -mtime +$KEEP_DAYS -delete 2>/dev/null
        find "$BAK_DIR" -name "*.bak" -mtime +$KEEP_DAYS -delete 2>/dev/null
            
        # 6. 完成提示
        echo "自动化处理完成，报告: $REPORT"
        echo "--- 报告预览 ---"
        cat "$REPORT"
}

# 执行主流程
main
   
