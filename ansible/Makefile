.PHONY: play-deploy play-destroy edit-secrets dependencies generate-terraform-vars

dependencies:
	ansible-galaxy install -r requirements.yml

deploy:
	ansible-playbook -i inventory.ini playbook.yml --vault-password-file get_vault_key --skip-tags destroy

destroy:
	ansible-playbook -i inventory.ini playbook.yml --vault-password-file get_vault_key --tags destroy

edit-secrets:
	ansible-vault edit group_vars/webservers/vault.yml --vault-password-file get_vault_key

generate-terraform-vars:
	ansible-playbook playbook-terraform-vars.yml --vault-password-file get_vault_key
