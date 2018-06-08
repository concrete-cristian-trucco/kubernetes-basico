---
titulo: Kubernetes básico
descrição: Esse repositório tem algumas ferramentas para automátizar o processo de criação do cluster baremetal.
autor: Cristian Trucco
autor: cristian-trucco
data: 06/06/2018
---

---
# Kubernetes básico

[![Kubernetes alt](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/kubernetes.png)](https://kubernetes.io)

#### Apresentação básica dos conceitos chaves e componentes do Kubernetes.
* [Apresentação Kubernetes](https://docs.google.com/presentation/d/1gTFIslzy4sxyE8Ezzaq_PYlb6aehhD0W4JkQ5gmOiPA/edit?usp=sharing)

#### Necessário VirtualBox ou HiperV para Rodar localmente, ou rodar essa Demo no http://play-with-k8s.com
* [Api kubecetl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Minikube](https://github.com/kubernetes/minikube/releases)

#### Para Windows utilize meu artigo que mostra como rodar o Minikube no Windows usando o Chocolatey
* [Minikube no Windows](https://concrete.com.br/2018/05/14/chocolatey-o-que-e-e-como-usar/)

![Minikube](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/minikube.jpg)
* Deploy de serviço: Usar os exemplos desse repositório


#### Subir o Minikube na máquina
<pre> minikube start </pre> 

#### Subir o Minikube modo RBAC e passando versão do Kubernetes desejada
<pre>
minikube start --kubernetes-version v1.10.0 --vm-driver=virtualbox --extra-config='apiserver.Authorization.Mode=RBAC'
</pre> 

---
#### Acessar o Dashboard do Kubernetes
<pre> minikube dashboard </pre> 

![Dashboard](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/kubernetes_dashboard.png)

#### O Kubectl é a cli que usaremos para interagir com nosso cluster

#### Listar os nós do cluster
<pre> kubectl get nodes </pre>

#### Listar os pods
<pre> kubectl get pods </pre> 
 
#### Criar um pod 
* É a menor unidade no cluster do Kube, é o objeto que faz a abstração dos containers
<pre> kubectl create -f aplicação.yaml </pre> 
 
#### Deployments é o que garante o estados dos pods, é nele que defino a quantidades de pods que irei rodar
* Comando cria o objeto deployment abstraindo o pod
<pre> kubectl create -f deployment.yaml </pre> 
 
#### Cria o serviço que será o ponto de entrada para meus pods
<pre> kubectl create -f servico-aplicacao.yaml </pre> 
  
#### Pegar a url do meu serviço
<pre> minikube service servico-aplicacao --url </pre> 

#### Listar todos os objetos criados no cluster
<pre> kubectl get deployment,svc,pods,pvc </pre> 
#### Segunda alternativa para o comando acima
<pre> kubectl gel all </pre>  


##### Documentação da Api do Kubernetes
* [Api do Kubernetes](https://kubernetes.io/docs/api-reference/v1.9/#_v1_container)

