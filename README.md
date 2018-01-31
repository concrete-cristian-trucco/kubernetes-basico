# Kubernetes básico
![Kubernetes](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/kubernetes.png)

Demonstração básica dos componentes do Kubernetes

### Cenário aplicação Nginx com html básico.
#### Necessário VirtualBox ou HiperV para Rodar localmente, ou rodar essa Demo no http://play-with-k8s.com
* Api kubecetl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
* Minikube: https://github.com/kubernetes/minikube/releases

![Minikube](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/minikube.jpg)
* Deploy de serviço: Usar os exemplos desse repositório

#### Acessar o Dashboard do Kubernetes
<pre> minikube dashboard </pre> 

![Dashboard](https://github.com/concrete-cristian-trucco/kubernetes-basico-nginx/blob/master/imagens/kubernetes_dashboard.png)

#### Listar os nodes(minions)
<pre> kubectl get nodes </pre>

#### Listar os pods
<pre> kubectl get pods </pre> 
 
#### Criar um pod 
* Que é a menor unidade no Kube, é a abstração dos containers
<pre> kubectl create -f aplicação.yaml </pre> 
 
#### Deployments é o que garante o estados dos pods
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
https://kubernetes.io/docs/api-reference/v1.9/#_v1_container
