# Terraform — Oracle (OCI) 範例

🔧 **簡短說明**

本目錄示範如何在 Oracle Cloud (OCI) 使用 Terraform 建置基礎網路與 VM（以東京區及 ARM 實例為範例），並包含常用操作腳本與範本，方便用於 SRE 練習與自動化。適合用來練習 IaC、跨雲自動化與可重複部署流程。

---

## 檔案一覽與說明

- `Makefile` — 封裝常用命令（`init`、`fmt`、`plan`、`apply`、`destroy`），快速執行 Terraform 工作流程。
- `provider.tf` — OCI Provider、資料來源（availability domains）與 Terraform backend 設定（state 存放於 OCI bucket）。
- `backend.conf` — Backend / 認證示例（請勿直接提交真實金鑰）。
- `variables.tf` — 變數定義（tenancy、user、fingerprint、private_key_path、compartment、ssh key 等）。
- `terraform.tfvars` — 範例變數值（示意用途，請用環境注入或安全方式替換）。
- `infra.tf` — 網路資源（VCN、Internet Gateway、Route Table、Security List、Subnet）。
- `resource.tf` — VM 建立範例（動態搜尋 Image、shape 設定、SSH key、lifecycle 忽略 image 變更等）。
- `oci_retry.sh` — 自動重試 `terraform apply` 的腳本；當服務容量不足（Out of capacity）時會定期重試直到成功。
- `test.txt` — 測試或佔位檔案。
- `tf_service_bot-*.pem` — 注意：這是私鑰檔案（敏感），不應該放在版本庫中。

---

## 快速上手（操作步驟）

1. 進入目錄：

   ```bash
   cd terraform/oracle
   ```

2. 初始化（設定 backend）：

   ```bash
   make init
   # 或: terraform init -backend-config=backend.conf
   ```

3. 檢查格式：

   ```bash
   make fmt
   ```

4. 預覽變更：

   ```bash
   make plan
   ```

5. 部署資源：

   ```bash
   make apply
   # 或在容量不足時使用重試腳本
   chmod +x oci_retry.sh
   ./oci_retry.sh
   ```

---

## 安全與最佳實務 ⚠️

- **不要將私鑰或敏感變數提交到 Git**。若已誤提交，請立即移除並換發金鑰：
  - 移除檔案但保留歷史：
    ```bash
    git rm --cached terraform/oracle/tf_service_bot-2025-12-27T05_05_39.566Z.pem
    echo "terraform/oracle/*.pem" >> .gitignore
    git add .gitignore
    git commit -m "remove sensitive key and ignore pem files"
    ```
  - 完整清理歷史請使用 `git filter-repo` 或 `BFG`（請小心操作）。
- 建議使用環境變數或 CI 的秘密管理系統（Vault、Secrets Manager、CI Secrets）注入敏感資訊。
- 使用後端（state backend）與 state locking 來避免多人同時修改 state 的衝突。
- 在自動重試腳本中加入最大嘗試次數與通知（Slack/Email）會比較安全與可觀察。

---

## 建議的下一步

- 若需要，我可以：
  - 幫你把此檔 commit 並推上遠端（使用你指定的作者資訊）；
  - 把私鑰移出 repo 並加入 `.gitignore`，並示範如何更新遠端（需你確認是否要重發金鑰）；
  - 將 `oci_retry.sh` 擴充為參數化（自訂重試間隔、最大次數、通知）。

有任何要我幫你執行的步驟請直接告訴我（例如: commit & push / 移除私鑰 / 擴充腳本）。
