# Guia de Instalação Nginx Ingress Baremetal

## Conteúdo do Guia

- [Comandos mandatórios](#comandos-mandatórios)
- [Instalar Nginx Controller com regras RBAC](#instalar-nginx-controller-com-regras-rbac)
  - [Baremetal](#baremetal)
  - [Verificando a instalação](#verificando-instalação)

## Deploy Genérico 

The following resources are required for a generic deployment.

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

## Verificando instalação

Para checar se os pods do ingress controller foram iniciados, execute o seguinte comando:

```console
kubectl get pods --all-namespaces -l app=ingress-nginx --watch
```

Once the operator pods are running, you can cancel the above command by typing `Ctrl+C`.
Now, you are ready to create your first ingress.

## Detect installed version

To detect which version of the ingress controller is running, exec into the pod and run `nginx-ingress-controller version` command.

```console
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app=ingress-nginx -o jsonpath={.items[0].metadata.name})
kubectl exec -it $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version
```
