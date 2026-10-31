## Pi Setup

Flash Pi OS Lite 64-bit with Imager
------------------------------------
- Important settings:
  - hostname
  - user
  - SSH public key
  - timezone
- Reserve IPs in router LAN DHCP settings
- Test `ssh theo@<hostname>`

Generating a new token for the vault
------------------------------------
- Generate token: `openssl rand -hex 32`
- Create vault: `ansible-vault create group_vars/k3s/vault.yml`
  - content: `k3s_token: "<token>"`

Running Ansible
---------------
- Check inventory: `ansible-inventory --graph`
- Ping: `ansible k3s -m ping --ask-vault-pass`
- Run: `ansible-playbook k3s.yml --ask-vault-pass -K`
  - `-K` = sudo password prompt
  - each Pi reboots once (cgroup change)


Set up local machine to point to the pi cluster
-----------------------------------------------
- Copy kube config:
    
        scp theo@pi-master:/etc/rancher/k3s/k3s.yaml ~/.kube/config

- Replace all references to "local host" 
  with the raspi ip address:

        sed -i '' 's/127.0.0.1/192.168.50.100/' ~/.kube/config

- Test it:
        
        kubectl get nodes
        kubectl get nodes --show-labels | grep role=dns

- Deploy pi-hole helm chart

        helm lint ./pi-cluster/charts/pihole
        helm template pihole ./pi-cluster/charts/pihole
        helm install pihole ./pi-cluster/charts/pi-hole -n pihole --create-namespace
        kubectl -n pihole get pods 

- Managing password for pihole 
    - Setting / Changing current password

            kubectl -n pihole patch secret pihole-admin -p '{"stringData":{"password":"PASSWORD"}}'
            kubectl -n pihole rollout restart deploy/pihole

    - Getting the current one
