#!/bin/bash
# =====================================================
# 功能：日志处理函数库（供其他脚本 source 调用）
# 用法：source ~/shell_test/scripts/log_funcs.sh
# 作者：study  日期：$(date +%F)
# =====================================================

# 函数1：过滤日志中指定关键字
# 用法：filter_log <日志文件> <关键字> [结果文件]
filter_log() {
    local log_file="$1"
    local keyword="$2"
    local out_file="${3:-$HOME/shell_test/logs/filter_result.log}"

    if [ ! -f "$log_file" ]; then
        echo "ERROR: 文件 $log_file 不存在"
        return 1
    fi
    grep -in "$keyword" "$log_file" > "$out_file"
    echo "已过滤 [$keyword] 到 $out_file"
    return 0
}

# 函数2：统计日志中关键字出现次数
# 用法：count_log <日志文件> <关键字>
count_log() {
    local log_file="$1"
    local keyword="$2"
    [ -f "$log_file" ] || { echo "ERROR: 文件不存在"; return 1; }
    local count
    count=$(grep -ic "$keyword" "$log_file")
    echo "$count"
}

# 函数3：备份日志（带时间戳）
# 用法：backup_log <日志文件> [备份目录]
backup_log() {
    local log_file="$1"
    local bak_dir="${2:-$HOME/shell_test/backup}"
    [ -f "$log_file" ] || { echo "ERROR: 文件不存在"; return 1; }
    mkdir -p "$bak_dir"
    local base
    base=$(basename "$log_file")
    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    cp "$log_file" "$bak_dir/${base}.${stamp}.bak"
    echo "已备份到 $bak_dir/${base}.${stamp}.bak"
    return 0
}
