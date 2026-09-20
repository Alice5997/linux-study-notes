#!/bin/bash
# =====================================================
# 功能：批量过滤政务系统日志中的 ERROR 级别记录
# 用法：./filter_gov_log.sh <日志文件> [关键字]
# 示例：./filter_gov_log.sh /home/study/shell_test/logs/app.log "数据库"
# 作者：study  日期：$(date +%F)
# =====================================================

# 参数校验：必须传入日志文件
if [ $# -lt 1 ]; then
    echo "用法: $0 <日志文件> [关键字]"
    exit 1
fi

LOG_FILE="$1"
KEYWORD="${2:-ERROR}"      # 默认过滤 ERROR
OUT_FILE="$HOME/shell_test/logs/filter_result.log"

# 文件存在性判断
if [ ! -f "$LOG_FILE" ]; then
    echo "错误: 日志文件 $LOG_FILE 不存在"
    exit 1
fi

# 过滤日志（忽略大小写，带行号）
grep -in "$KEYWORD" "$LOG_FILE" > "$OUT_FILE"

# 统计条数
COUNT=$(grep -ic "$KEYWORD" "$LOG_FILE")
echo "过滤完成: 共找到 $COUNT 条包含 [$KEYWORD] 的记录"
echo "结果已保存到: $OUT_FILE"
echo "--- 前 10 条预览 ---"
head -10 "$OUT_FILE"
