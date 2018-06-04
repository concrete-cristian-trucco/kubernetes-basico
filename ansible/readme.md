## Ansible

### Rodar o playbook passando usuário e senha

```
ansible-playbook -i hosts main.yml -u root --ask-pass
```

### Rodar o playbook modo verboso

```
ansible-playbook -i hosts main.yml -u root --ask-pass -vvv
```

#### Gerar a chave
```
ssh-keygen
```
### Copiar chave ssh para o host remoto

```
ssh-copy-id root@192.168.2.99
```
