#!/bin/bash

# 設定錯誤處理
set -euo pipefail

# 設定日誌檔案
LOG_FILE="/var/log/pcre2_update.log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

echo "開始更新 PCRE2 - $(date)"

# 檢查目前版本
current_version=$(dpkg -l | grep pcre2 | awk '{print $3}')
echo "目前版本：$current_version"

# 建立備份
echo "建立套件清單備份..."
mkdir -p /var/backups/pcre2
dpkg --get-selections > "/var/backups/pcre2/packages_$(date +%Y%m%d_%H%M%S)"

# 更新套件
echo "更新套件清單..."
apt-get update

echo "安裝 PCRE2 更新..."
apt-get install --only-upgrade libpcre2-8-0 libpcre2-16-0 libpcre2-32-0 libpcre2-dev

# 驗證更新
new_version=$(dpkg -l | grep pcre2 | awk '{print $3}')
echo "更新後版本：$new_version"

# 檢查相依服務
echo "檢查受影響的服務..."
lsof | grep pcre2 || true

echo "更新完成 - $(date)"
