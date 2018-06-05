#### worker nodes setup steps

ref: https://kubernetes.io/docs/setup/independent/install-kubeadm/

A instalação dos nodes workers é bem direta:


1. Instalar Docker, kubeadm, kubelet and kubectl

```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "set SELinux config to Permissive so it keeps as permissive even on reboots"
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux
echo "set SELinux to Permissive while a reboot doesnt happens"
setenforce 0

echo "Disable Swap on fstab"
sed -i --follow-symlinks 's/\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/g' /etc/fstab
echo "disable swap before while a reboot doesnt happens"
swapoff -av

echo "Install everything"
yum install -y docker kubelet kubeadm kubectl

echo "enable and start docker"
systemctl enable docker && systemctl restart docker

echo "enable and start kubelet"
systemctl enable kubelet && systemctl restart kubelet

echo "prevent traffic incorrect routing due to iptables bypassing"
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```


2. Ingressar o _"worker node"_ ao Cluster

Em um dos nós _master_, obtenha o comando de JOIN executando:

```
kubeadm token create --print-join-command
```

No _worker_ a ingressar no Cluster, execute a saída do comando anterior, que deve ser no formato:

```
kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>
```

