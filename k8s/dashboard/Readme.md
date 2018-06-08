
## Deploy do painel do kubernetes com Rbac

```
kubectl apply -f kubernetes-dashboard-rbac.yaml

```
Criando uma SA para acessar o Dashboard do Kubernetes. 

```
kubectl apply -f sa-dashboard-dev.yaml
```
======================================================================================
```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-dev
  namespace: kube-system


---

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-dev
  labels:
    k8s-app: kubernetes-dashboard
    rbac.authorization.k8s.io/aggregate-to-view: "true"

roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view # usando a Role View não é possivel acessar secrets
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard-dev
  namespace: kube-system
```
  ======================================================================================

#### Listar as ServiceAccount do namespace de sistema
```  
   kubectl get sa -n kube-system
```
#### Pegar o Token do ServiceAccount dev

```
   kubectl describe secret kubernetes-dashboard-dev -n kube-system
```
#### Pegar o token e logar no dashboard

Saída do comando:

```
kubectl describe secret kubernetes-dashboard-dev -n kube-system
Name:         kubernetes-dashboard-dev-token-blx7j
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name=kubernetes-dashboard-dev
              kubernetes.io/service-account.uid=9b451dac-69cd-11e8-b150-0050568dea18

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC1kZXYtdG9rZW4tYmx4N2oiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoia3ViZXJuZXRlcy1kYXNoYm9hcmQtZGV2Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiOWI0NTFkYWMtNjljZC0xMWU4LWIxNTAtMDA1MDU2OGRlYTE4Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmt1YmVybmV0ZXMtZGFzaGJvYXJkLWRldiJ9.uKyBzuEucEbZJn9ZDXtMixxtlSPC55bX3VoBRtkxeBysRyzs51OsjQtQ4zJN2Tqy4O9xkedabcXh-OdxVxan3z9wX1KkfzuwNRCN7KQsR4XD8JqhZmAQ1u45vuaMRV8wFungHqNxnORKCRrm09407xFssYxe-CmiV7psatonvd9n9TvjevBunSQpDYJUU8wMcpw5mMpPA23eAUwqCIlEXCtSFD9cVPFR8G3FSycUrFPNg1h10RcySkcrPA8HCVrmdi1aQvpyEwcDb_GCnty4R4W5MNqnxqF09wMgJB9VZ__r0s-WZvLW69fHqP87L6QGg0tYWN2REjjpWDYinvhO4A

```
