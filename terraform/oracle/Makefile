# 定義變數，方便未來修改
BACKEND_CONF = backend.conf
VAR_FILE = terraform.tfvars

# 初始化
init:
	terraform init -backend-config=$(BACKEND_CONF)

# 格式化檢查 (SRE 的好習慣)
fmt:
	terraform fmt -recursive

# 規劃 (預覽變更)
plan:
	terraform plan -var-file=$(VAR_FILE)

# 執行部署
apply:
	terraform apply -var-file=$(VAR_FILE) -auto-approve

# 銷毀資源 (慎用！)
destroy:
	terraform destroy -var-file=$(VAR_FILE)