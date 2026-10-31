#############################################
# A thin wrapper around ansible, helm and kubectl
#
# Only the things worth running more than once - the one-off
# setup steps are in README.md

all: help

ANSIBLE_DIR := pi-cluster/ansible
CHART       := pi-cluster/charts/pihole
RELEASE     := pihole
NS          := pihole

############ Ansible
# -K prompts for the sudo password. The pis reboot once on the first run,
# because enabling the memory cgroup edits cmdline.txt.
.PHONY: provision
provision: 
	cd $(ANSIBLE_DIR) && ansible-playbook k3s.yml --ask-vault-pass -K

############ Helm
.PHONY: lint
lint: 
	helm lint $(CHART)

.PHONY: template
template: 
	helm template $(RELEASE) $(CHART)

.PHONY: upgrade
upgrade: 
	helm upgrade $(RELEASE) $(CHART) -n $(NS)

############ Cluster
.PHONY: status
status: 
	kubectl -n $(NS) get pods,svc,pvc -o wide

.PHONY: logs
logs: 
	kubectl -n $(NS) logs -f deploy/$(RELEASE)

.PHONY: restart
restart: 
	kubectl -n $(NS) rollout restart deploy/$(RELEASE)
	kubectl -n $(NS) rollout status deploy/$(RELEASE)
