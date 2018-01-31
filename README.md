# Kubernetes básico
Demonstração básica dos componentes do Kubernetes

### cenário aplicação Nginx com html básico.

* Api kubecetl
* minikube
* deploy de serviço

#### Acessar o Dashboard do Kubernetes
<pre>   minikube dashboard </pre> 

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
