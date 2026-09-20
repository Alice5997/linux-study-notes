#!/bin/bash
# =====================================================
# 功能：循环处理 logs 目录下所有日志文件，统计各文件 ERROR 条数
# 用法：./process_logs_batch.sh [日志目录]
# 作者：study  日期：$(date +%F)
# =====================================================

LOG_DIR="${1:-$HOME/shell_test/logs}"
REPORT="$HOME/shell_test/logs/batch_report.txt"

# 目录校验
if [ ! -d "$LOG_DIR" ]; then
    echo "错误: 目录 $LOG_DIR 不存在"
    exit 1
fi

# 清空旧报告
> "$REPORT"
echo "批量日志处理报告 - $(date '+%F %T')" >> "$REPORT"
echo "==============================" >> "$REPORT"

TOTAL=0
FILE_COUNT=0

# for 循环遍历所有 .log 文件
for f in "$LOG_DIR"/*.log; do
    # 无匹配文件时 $f 会保留通配符，跳过
    [ -f "$f" ] || continue
    FILE_COUNT=$((FILE_COUNT + 1))
    ERR_COUNT=$(grep -ic "ERROR" "$f")
    TOTAL=$((TOTAL + ERR_COUNT))
    echo "$(basename "$f"): ERROR $ERR_COUNT 条" | tee -a "$REPORT"
done

echo "==============================" >> "$REPORT"
echo "共处理 $FILE_COUNT 个日志文件，ERROR 总计 $TOTAL 条" | tee -a "$REPORT"
