#!/bin/bash
# oci_retry.sh - SRE 自動化搶占腳本

# 檢查 terraform 是否在路徑中
if ! command -v terraform &> /dev/null; then
    echo "錯誤: 找不到 terraform 指令，請確認已安裝。"
    exit 1
fi

echo "開始自動搶占任務... 結束請按 Ctrl+C"
count=0
# 無限循環直到成功
while true; do
    echo "--------------------------------------------------"
    echo "執行時間: $(date)"
    echo "嘗試申請 Oracle 東京區 ARM 實例..."
    
    # 執行 terraform apply，並記錄輸出
    # 使用 -auto-approve 避免互動式確認
    terraform apply -auto-approve
    
    # 檢查結束狀態 ($? 是上一個指令的結束代碼)
    if [ $? -eq 0 ]; then
        echo "=================================================="
        echo "恭喜！VM 資源已成功搶占並建立完成。"
        echo "=================================================="
        # 如果是 Mac，執行完畢會發出聲音提醒你
        if [[ "$OSTYPE" == "darwin"* ]]; then say "Deployment successful"; fi
        break
    fi

    echo "目前資源不足 (Out of capacity)，60 秒後進行下一次嘗試..."
    echo "總共執行次數: $((++count))"
    sleep 60
done
