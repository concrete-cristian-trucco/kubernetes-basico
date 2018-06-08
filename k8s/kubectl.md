### Sobre kubectl
O utilitário kubectl permite que você acesse (API) e gerencie o cluster Kubernetes. Por exemplo, você pode adicionar e excluir nós, pods, controladores de replicação,serviços e etc.


#### Comandos Basicos

Comando   | Descrição
--------- | ------
kubectl get pods    | Listar os Pods
kubectl get svc     | Listar os Serviços
kubectl get deploy  | Listar os Deploys
kubectl get ds      | Listar os Daemonsets
kubectl get ingress | Listar os Ingress
kubectl get pv      | Listar os Persistent Volumes
kubectl get pvc     | Listar os Persistent Volumes Clains
kubectl get all     | Listar os todos os objetos (nem todos)
kubectl get sa      | Listar os Service Accounts
kubectl get clusterrole | Listar os ClusterRoles


```bash
# Informações basicas do cluster
$ kubectl cluster-info
```
```bash
# Lista as versões da API
$ kubectl api-versions
```
```bash
# Lista servidores que faz parte do cluster
$ kubectl get nodes
```
```bash
# Exibe pods em execução
$ kubectl get pods
```
```bash
# Exporta informações dos pod no formato yaml
$ kubectl get pod <pod name> -o=yaml
```
```bash
# Exibe quantas replicas tem em um rc
$ kubectl get rc <rc name>
```
```bash
# Exibe serviços em execução
$ kubectl get svc <sc name>
```
```bash
# Exibe os pod dentro de um namespace
$ kubctl get --namespace=kube-system pods
```
```bash 
# Exibe os logs de todos namespace
$ kubectl  get --all-namespaces events -w
```
```bash
# Cria pods a partir de um aquivo yaml
$ kubectl create -f development-ns.yaml
```
```bash
# Exibe informações do Pod
$ kubectl describe pod <pode name>
```
```bash
# Deleta Pod
$ kubectl delete pod <pode name>
```
```bash
# Escala o numero de pods
$ kubectl scale --replicas=3 rc <pod name>
```
```bash
# Executa comando remoto no pod
$ kubectl exec <pod name> date
```
```bash
# Acessa o bash do pod
$ kubectl exec <pod name> -it bash
```

#### Mais informações sobre o comando kubectl
[kubectl-overview](https://kubernetes.io/docs/user-guide/kubectl-overview/)

[kubectl](https://kubernetes.io/docs/user-guide/kubectl/)
