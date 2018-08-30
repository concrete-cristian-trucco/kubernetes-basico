### Deploy 
  Teste de deploy de uma aplicação simples usando a imagem do Nginx no cluster Kubernetes
  
O arquivo deploy-all.yaml irá criar de uma só vez os objetos declarados no yaml, o pod, um deployment e um service 

```
kubectl apply -f deploy-all.yaml
```

#### Lembrete
Caso não seja passado ou declarado no yaml o namespace o cluster irá implantar os objetos no namespace default
    
#### Ingress
  Deve ter o Ingress Controller instalado no cluster para ingress funcionar via DNS
* Ingress-Controller: https://github.com/concrete-cristian-trucco/kubernetes-basico/tree/master/k8s/ingress-controller
