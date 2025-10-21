#!/bin/bash

# 設定錯誤處理
set -euo pipefail

# 設定日誌
LOG_FILE="/var/log/pcre2_update.log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

echo "開始 PCRE2 安全性更新 - $(date)"

# 檢查當前版本
current_version=$(dpkg -l | grep pcre2 | awk '{print $3}')
echo "當前版本：$current_version"

# 建立備份
backup_dir="/var/backups/pcre2/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"
dpkg --get-selections > "$backup_dir/package_selections"

# 更新系統
echo "更新套件清單..."
apt-get update

# 更新 PCRE2
echo "安裝 PCRE2 更新..."
apt-get install --only-upgrade \
    libpcre2-8-0 \
    libpcre2-16-0 \
    libpcre2-32-0 \
    libpcre2-dev

# 確認更新
new_version=$(dpkg -l | grep pcre2 | awk '{print $3}')
echo "更新後版本：$new_version"

# 檢查相依服務
echo "檢查相依服務..."
lsof | grep -i pcre2 || true

echo "完成更新 - $(date)"
