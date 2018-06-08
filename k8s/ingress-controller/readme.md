# Guia de Instalação Nginx Ingress Baremetal

## Conteúdo do Guia

- [Comandos mandatórios](#comandos-mandatórios)
- [Instalar Nginx Controller com regras RBAC](#instalar-nginx-controller-com-regras-rbac)
  - [Baremetal](#baremetal)
  - [Verificando a instalação](#verificando-instalação)

### Motivação 

Fiz esse guia pois senti a necessidade de configurar um controlador ingress em um cluster baremetal, e a maioria dos exemplos que achava na web era para cloud, onde ao expor um service no cluster - especificando o type LoadBlancer, a propria infra da cloud seja ela Azure o AWS provisiona automáticamente um ip (vip) para acessar o serviço na porta 80 ou 443 do ip atribuido ao serviço (parece até mágica), bastando apenas configurar o dns para responder para esse Ip. 

  O Minikube por padrão já vendo com o Ingress embarcado basta habilitar o recurso com uma linha de comando
  ```
     minikube addons enable ingress
  ```
  No Google Cloud já existe o Nginx embarcado no cluster bastando criar o Ingress e o DNS.

Isso vira um problema quando se tem vários serviços no cluster e cada um com um LoadBalancer, lembrando que a maioria das clouds cobra por esse serviços, o ideal é ter um ponto de entrada um controlador ingress encaminhando essas requisições para o cluster. 

Mas voltando para o nosso problema resolvi colocar o passo a passo para que ao criar um objeto ingress no cluster (baremetal) para que seja prossivel o cluster encaminhar essas requisições DNS > para um serviço no Kubernetes sem que seja necessário mapear NodePort ou ter um proxy fora do cluster onde fica dificil gerencia os ingress.

O Ingress Controller nesse exemplo abaixo nada mais é que um pod de Nginx que fica observando a criação de entradas ingress para cluster, colocando as entradas que vão sendo criadas e dando um reload no serviço automáticamente então basta configurar o DNS para apontar para qualquer nó do cluster que o cluster vai saber encaminha a requisição para o serviço desejado.

###  1. Necessidade do uso do Ingress.
O Ingress  é uma coleção de regras que permite que as conexões de entrada atinjam os serviços dentro do cluster Kubernetes.

  internet
   |
  [ Ingress ] → DNS (URL)
  [ Services ] → API (pod)



###  2. Quais serviços necessitam dessa abordagem?
O Ingress pode ser configurado para fornecer serviços a URLs acessíveis externamente, funciona para tráfego de balanceamento de carga, encerrar SSL, oferecer hospedagem virtual baseada em nome. Os administradores criam o ingresso ao colocar o recurso Ingress no servidor da API. Um controlador de ingresso é responsável pelo cumprimento do Ingress, geralmente como um balanceador de carga interno responsável por rotear o tráfego direto para o serviço até o pod onde de fato está o container que está executando a aplicação. 



###  3. O que é um controlador de ingresso?
Um controlador de ingresso nada mais é do que um proxy reverso dentro do cluster Kubernetes, ele esperada entradas de ingress serem criadas no cluster para adicionar a configuração sem ter a necessidade de parar o serviço, expondo a nova entrada para fora do cluster. 
O controlador Ingress serve para lidar com todas as peculiaridades associadas a uma "classe" específica do Ingress.
Um Ingress Controller é um daemon, implementado como um Pod no Kubernetes, que observa o ponto de /ingresses extremidade do apiserver em busca de atualizações para o recurso Ingress . Sua tarefa é satisfazer solicitações de Ingressos. 
Os serviços de controle de ingress que executam o papel de proxy e que foram avaliadas nas POCs são: o Traefik e Nginx Ingress. Essas ferramentas ajudam a lidar com o tráfego de maneira HA. 

###  4.  Ganho em usar esse recurso.
O ganho em se utilizar essa abordagem é que não precisamos controlar portas de serviços expostos no cluster.

* Declarando um objeto do Ingress no arquivo **yaml**, para acessar na porta 80 do cluster, o ingress irá associar **serviceName: test** ao ingress **test-ingress**.

```
Exemplo de um objeto Ingress:
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        backend:
          serviceName: test
          servicePort: 80
```
#### criando o ingress no cluster

```
kubectl create –f myservice-ingress.yaml

```
#### Listando o ingress criado
```
kubectl get ing
```
#### Acessando o serviço
```
 http://nomedoserviconodns/testpath
```

## Deploy Genérico 
#### Setup do Nginx baremetal com Rbac

Os passos a seguir são mandatórios para o setup do Ingress

### Comandos Mandatórios

```console

kubectl apply -f deploy/namespace.yaml 
    
kubectl apply -f deploy/default-backend.yaml 
    
kubectl apply -f deploy/configmap.yaml     

kubectl apply -f deploy/tcp-services-configmap.yaml 
   
kubectl apply -f deploy/udp-services-configmap.yaml 
    
```

### Instalar Nginx Controller com regras RBAC

Please check the [RBAC](rbac.md) document.

```console
kubectl apply -f deploy/rbac.yaml 

kubectl apply -f deploy/nginx-controller-ds-rbac.yaml 
```
Obs: O segundo comando irá aplicar DaemonSet nos nós do cluster
isso irá abrir as portas 80 e 443 (portas usadas pelo controlador) usando hostport (semelhante ao Docker), necessário usar hostnetwork: true para ter esse comportamento, todas essas alterações já estão declaradas no nginx-controller-ds-rbac.yaml.

### Baremetal

##### Aplicando o serviço do Nginx Ingress

Using [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport):

```console
kubectl apply -f deploy/service-nodeport.yaml 
    
```
* Ou para ser mais rápido rode o comando na pasta deploy.
```
kubectl apply -f deploy/
```

## Verificando instalação

Para checar se os pods do ingress controller foram iniciados, execute o seguinte comando:

```console
kubectl get pods --all-namespaces -l app=ingress-nginx --watch
```

Once the operator pods are running, you can cancel the above command by typing `Ctrl+C`.
Now, you are ready to create your first ingress.

## Versão da instalação 

Conferindo a versão do ingress controller is running, executando dentro do pod `nginx-ingress-controller version` command.

```console
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app=ingress-nginx -o jsonpath={.items[0].metadata.name})
kubectl exec -it $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version
```
