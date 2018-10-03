---
titulo: Kubernetes básico
descrição: Esse repositório tem algumas ferramentas para automátizar o processo de criação do cluster baremetal.
autor: Cristian Trucco
autor: cristian-trucco
data: 06/06/2018
---


[![StackShare](https://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](https://stackshare.io/concrete-cristian-trucco/my-stack)
---
# Kubernetes básico

Este repositório é focado em Kubernetes - setups baseados em on premise (baremetal) ou seja em VMs tradicionais. Existem breves explicações de conceitos chaves do Kubernetes. Tambémm coloquei oustras ferramentas que vão auxiliar na criação do cluster, como playbooks ansible,vagrant para provisionamento de máquinas locais e Terraform para provisioar a infra em Prod.

[![Kubernetes alt](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/kubernetes.png)](https://kubernetes.io)

#### Apresentação básica dos conceitos chaves e componentes do Kubernetes.
* [Apresentação Kubernetes](https://docs.google.com/presentation/d/14VtepKVOzb0aMDCn4GkvJN3JYDCs2y6FkBVTTi-8H_0/edit?usp=sharing)

### Rodar o Kubernetes localmente
#### Rodar um cluster local é possível usando o Minikube é necessário o VirtualBox ou HiperV, ou no caso de não querer instalar nada na máquina pode rodar os labs no http://play-with-k8s.com é possivél criar e gerênciar o cluster direto do navegador.

* [Api kubecetl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Minikube](https://github.com/kubernetes/minikube/releases)

#### Obs: Caso não conheça o **play with k8s** escrevi um artigo no **Medium** de como criar um cluster nessa plataforma, lá tem explicando tudo com detalhes você vai gastar menos de 10 minutos para ler o artigo e implementar o cluster.

* [Play K8s Artigo Medium](https://medium.com/@cristianvitortrucco/rode-um-cluster-kubernetes-em-menos-de-10-minutos-ff9db3415639)

#### Para Windows utilize meu artigo que mostra como rodar o Minikube no Windows usando o Chocolatey
* [Minikube no Windows](https://concrete.com.br/2018/05/14/chocolatey-o-que-e-e-como-usar/)

![Minikube](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/minikube.jpg)
* Deploy de serviço: Usar os exemplos desse repositório


#### Subir o Minikube na máquina
<pre>minikube start</pre> 

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
 
#### Rodando o primeiro exemplo
* O POD é a menor unidade no cluster Kubernetes, é o objeto que faz a abstração dos containers, é nesse objeto onde nossas aplicações iram rodar. Para rodar um exemplo rápido para ver como o kubernetes funciona entre na pasta deploy-test/ que está na raiz do repositório e execute o comando para criar um pod usando o kubectl.

* Os comandos a seguir serão executados para criar e expor uma aplicação no cluster Kubernetes.
<pre> cd deploy-test/ </pre> 

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

