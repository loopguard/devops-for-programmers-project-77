TERRAFORM_DIR=terraform
ANSIBLE_DIR=ansible
VAULT_FILE=$(ANSIBLE_DIR)/group_vars/all/vault.yml
VAULT_VARS_TMP=.vault_env.tmp
GET_IP=terraform -chdir=$(TERRAFORM_DIR) output -raw public_ip

.PHONY: all init plan apply output ansible destroy clean vault-env

all: vault-env apply ansible

vault-env:
	@ansible localhost -m include_vars \
	    -a "file=$(VAULT_FILE) name=vault" \
	    --connection=local \
	    --inventory localhost, \
	    --ask-vault-pass \
	    | grep vault_ \
	    | sed 's/.*vault_/export TF_VAR_/; s/: /=/' > $(VAULT_VARS_TMP)

init: vault-env
	. $(VAULT_VARS_TMP) && terraform -chdir=$(TERRAFORM_DIR) init

plan: vault-env
	. $(VAULT_VARS_TMP) && terraform -chdir=$(TERRAFORM_DIR) plan

apply: vault-env
	. $(VAULT_VARS_TMP) && terraform -chdir=$(TERRAFORM_DIR) apply -auto-approve

output:
	@$(GET_IP)

ansible:
	IP=$$($(GET_IP)); \
	echo "[redmine]" > $(ANSIBLE_DIR)/inventory.ini; \
	echo "$$IP ansible_user=ubuntu" >> $(ANSIBLE_DIR)/inventory.ini; \
	ansible-playbook -i $(ANSIBLE_DIR)/inventory.ini $(ANSIBLE_DIR)/playbook.yml

destroy: vault-env
	. $(VAULT_VARS_TMP) && terraform -chdir=$(TERRAFORM_DIR) destroy -auto-approve

clean:
	rm -f $(ANSIBLE_DIR)/inventory.ini $(VAULT_VARS_TMP)
