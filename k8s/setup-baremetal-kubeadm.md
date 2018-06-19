
### Motivação
Esse guia é baseado na documentação oficial do kubernetes usando o kubeadm, a ideia desse guia é você realizar esse setup a primeira vez para ver como funciona o kubernetes, o que o cluster precisa ter para funcionar e realizar um deploy de uma aplicação.

* Esse guia foi criado para ambiente Centos 7 e Redhat

Criei um playbook para facilitar, mas somente use ele após entender como o Kubernetes funciona!
* Playbook: https://raw.githubusercontent.com/concrete-cristian-trucco/kubernetes-basico/master/ansible/main.yml

### [MASTER]

* Desligar o Swap no Centos:
```
vi /etc/fstab
```

* Colocar o Selinux como permissive:
```
setenforce 1
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```

* Configurar Firewall e aplicar regras:
```
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload
```

* Configurar Repositorio Kubernetes:
```
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

* Instalar Docker e Kubeadm:
```
yum install kubeadm docker -y
```

* Habilitar o Docker e o Kubeadm na inicialização do sistema.
```
systemctl restart docker && systemctl enable docker
systemctl  restart kubelet && systemctl enable kubelet
```

* Inicializar o cluster no Master:

```
kubeadm init
```

* Copiar saída do kubeconfig para usuário corrente.

```
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```

* Listar todos os Nós do cluster
```
kubectl get nodes
```

* Realizar de deploy da Rede Flannel.

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
```

* Referência: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

#### Obs: O cluster só estará com status Ready após o Deploy da rede Flannel

* Realizar as etapas a seguir nos Nós/Workes do cluster:

### [NODE/WORKES]

* Desligar o Swap:
```
vi /etc/fstab
```
#### Obs: Comentar a linha do Swap.

* Firewall e Selinux:
```
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --permanent --add-port=6783/tcp
firewall-cmd  --reload
```

* Configurar Repositório do Kubernetes nos Workes:

```
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

* Instalar o Docker e o Kubeadm:
```
yum  install kubeadm docker -y
```
* Colocar o Docker e Kubeadm na inicialização do sistema.
```
systemctl restart docker && systemctl enable docker
systemctl  restart kubelet && systemctl enable kubelet
```


#### Obs: Copiar e colar saída do kubeadm init do master e colar nos nodes que faram parte do cluster:
```
kubeadm join --token fe75e3.827db73r3qw8950a 192.168.50.15:6443 --discovery-token-ca-cert-hash sha256:7e6ce96dfsdewqaebcfb7632376c3053d8e3430b04e703b7eb789a0e342bb4
```


#### Dashboard-Kubernetes

* Referencia: https://github.com/kubernetes/dashboard/

* Create secrete dashboard:

kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kube-system

* Deploy Dashboard:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

```

* Editar o service do dashboard:

```
kubectl -n kube-system edit service kubernetes-dashboard
```

#### Obs: Alterar type de : ClusterIP para NodePort, esse procedimento é necessário para expor o serviço do dashboard para fora
do cluster, ou editar o arquivo yaml e depois realizar o apply desse arquivo no cluster.

* Visualizar os namespace criados no cluster.

```
kubectl config view
```

* Criar contexto test para realizar deploy no namespace selecionado.

```
kubectl config set-context test --namespace=test --cluster=kubernetes-admin@kubernetes --user=kubernetes-admin@kubernetes
```
     
* Listar os contextos:
```
kubectl config view
```

* Verificar contexto atual:
```
kubectl config current-context
```

Criar os namespaces para desenvolvimento 
```
kubectl config set-context dev --namespace=desenvolvimento --cluster=kubernetes --user=kubernetes-admin
```
* Referencia: https://stackoverflow.com/questions/46664104/how-to-sign-in-kubernetes-dashboard

* Pegar todos os secrets do cluster e tokens

```
kubectl -n kube-system describe secret
```

* Pegar token namespacecontroller

```
kubectl -n kube-system describe secret namespace-controller
```

* Referência: https://kubernetes.io/docs/tasks/administer-cluster/namespaces/

* Criar namespace para desenvolvimento:

```
vi  development.yaml


{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "desenvolvimento",
    "labels": {
      "name": "desenvolvimento"
    }
  }
}

```

* Listar contextos e namespace criados:

```
kubectl config view
```
```
kubectl get namespace
```

* Resolver problemas de acesso ao Dashboard:
https://stackoverflow.com/questions/46664104/how-to-sign-in-kubernetes-dashboard

* Referências: para montagem do roteiro - Documentação oficial.
https://kubernetes.io/docs/setup/independent/install-kubeadm/

#### Dica
Para adicionar mais nodes/workes no caso de não ter o token gerado com o comando kubeadm init

* Pegar o token gerado na saida no kubeadm init

```
kubeadm token list
```

* Saida do comando

```
74ew3f3.2cerfwfw1a15sf0a
```

#### Exemplo do comando

```
kubeadm join --token ($token) --discovery-token-unsafe-skip-ca-verification ($ip-master):6443
```




