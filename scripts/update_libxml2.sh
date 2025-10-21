#!/bin/bash

# 設定基本參數
LOG_FILE="/var/log/libxml2_update.log"
BACKUP_DIR="/var/backups/libxml2"
REQUIRED_VERSION="2.13.9-r0"

# 錯誤處理
set -euo pipefail

# 記錄開始時間
echo "開始更新 libxml2: $(date)" | tee -a "$LOG_FILE"

# 版本檢查
current_version=$(dpkg -l libxml2 | grep libxml2 | awk '{print $3}')
echo "當前版本: $current_version" | tee -a "$LOG_FILE"

# 建立備份
mkdir -p "$BACKUP_DIR"
dpkg --get-selections > "$BACKUP_DIR/package_selection_$(date +%Y%m%d_%H%M%S)"

# 更新套件
apt-get update
apt-get install --only-upgrade libxml2

# 確認更新
new_version=$(dpkg -l libxml2 | grep libxml2 | awk '{print $3}')
echo "更新後版本: $new_version" | tee -a "$LOG_FILE"

# 檢查相依服務
echo "檢查受影響的服務："
lsof | grep libxml2 || true

echo "更新完成，請檢查服務狀態"
