## Service Accounts

### Acesso a Recursos da API do Kubernetes


Por default ao iniciar o Kubernetes e rodar um pod,service ou um deployment sem passar um namespace os objetos são criados no namespace default. 

Quando essas aplicações são instanciadas por padrão elas rodam com um Service Accout default essa SA é criada sempre que criamos um novo namespace uma SA é  criada com privilégios de  admin do namespace. 

O problema que caso um pod ou um container for comprometido, esse container poderia de alguma forma subtrair secrets do cluster comprometendo as aplicações que estão rodando dentro do cluster e que tem acesso a dados sensíveis. 

* Solução:

Criar SAs - contas de serviços com escopo mínimo para acessar API (avaliar cada aplicação para ver a necessidade de acesso). Atrelar as aplicações (PODs) a essas SAs de forma que se uma aplicação for comprometida não seja possível acessar outros segredos no namespace e até mesmo secrets no cluster.
RBAC Authorization
O Controle de Acesso Baseado em Função (RBAC) usa o grupo de API "rbac.authorization.k8s.io" para conduzir decisões de autorização. 
Por meio do Rbac o administrador pode permitir determinado niveis de acesso a API do Kubernetes.

* Role and ClusterRole

Na API do RBAC, uma role contém regras que representam um conjunto de permissões. 
As permissões são puramente aditivas (não há regras de "negação"). 
Uma função pode ser definida dentro de um namespace com um Role, ou em todo o cluster com um ClusterRole.

Uma Role só pode ser usado para conceder acesso a recursos dentro de um único namespace. Veja um exemplo Role no namespace "default" que pode ser usado para conceder acesso de leitura aos pods:

```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```  

ClusterRole pode ser usado para conceder as mesmas permissões de um Role, mas como eles são no escopo do cluster, eles também podem ser usados ​​para conceder acesso a:

Recursos com escopo de cluster (como nós)
endpoints sem recursos (como “/ healthz”)
recursos com namespaces (como pods) em todos os namespaces (necessários para execução kubectl get pods --all-namespaces, por exemplo)


* RoleBinding and ClusterRoleBinding

O Kubernetes já vem com algumas Roles e ClusterRoles criadas por default. Podem atribuir SAs ou usuários a essas roles.
```
cluster-admin - usa ClusterRole ou seja tem acesso a todo sistema: Permite que o acesso de superusuário execute qualquer ação em qualquer recurso da API do Kubernetes para qualquer namespace.

admin - Permite acesso de administrador, destinado a ser concedido dentro de um namespace usando uma RoleBinding. Seu acesso de admin só vale para o namespace onde a Role está associada. Dentro do namespace consegue acessar qualquer objeto.

edit - Permite acesso de leitura/gravação à maioria dos objetos em um namespace. Não permite visualizar ou modificar roles ou rolebindings.

view - Permite que o acesso somente leitura para a maioria dos objetos em um namespace. Não permite a visualização de roles ou rolebindings. Não permite a exibição de segredos.
```

* Service Accounts

Uma conta de serviço fornece uma identidade para processos executados em um Pod.
O Kubernetes cria automaticamente uma conta de serviço default com acesso relativamente limitado em todos os namespaces. Se os Pods não solicitarem explicitamente uma conta de serviço, eles serão atribuídos a essa conta default.

Recomenda-se criar Contas de Serviço adicionais. A criação deve permitir que usuários de cluster criem contas de serviço para tarefas específicas (princípio de privilégio mínimo).


* Dashboard Kubernetes

#### Problema:
Por padrão o dashboad cria uma SA e associa essa sa a uma clusterrole default no cluster o cluster-admin, ou seja conseguimos gerenciar todo o cluster através da interface gráfica. Isso é últil do ponto de vista de desenvolvimento mais a nivel de segurança é um risco. Esse usuário tem acesso a qualquer objeto e inclusive ver secrets e seu conteúdo. 


#### Solução:
 
Foi criado uma SA com um nível mais restrito mas que ainda seja uma boa forma de gerenciar e realizar debug no ambiente por parte dos desenvolvedores. 
Foi atribuído ao grupo view a essa SA. Já que informações sensíveis (como secrets) não podem ser listada para esse usuário de desenvolvimento.

O acesso ao painel continua o mesmo usando um token em base64 para realizar a autenticação na APi. Esses tokens ficam armazenados no ETCD e são encriptado pela chave do Azure KMS.


### Visão Service Accounts.

Contas de serviço e namespaces permitem que você limite a permissão do pod e do usuário no Kubernetes. Os registros de auditoria fornecem informações sobre quais contas estão acessando quais recursos. Aprenda a usar esses recursos do Kubernetes!

Neste passo a passo, você cria um namespace e adiciona duas contas de serviço, cada uma com sua própria role. Uma SA pode ler segredos, objetos do Kubernetes que armazenam informações confidenciais e outros não. 

Cada uma dessas SAs é anexada ao seu próprio pod. Esses dois pods executam a mesma imagem de contêiner. No tempo de execução, os secrets são lidos de dentro do contêiner usando um comando curl. A autorização para acessar o segredo é determinada por um token da API que é montado dentro do contêiner. Este token é gerado usando o nome da conta de serviço do pod. O acesso à API é registrado em um arquivo, que contém o acesso secreto por essas contas de serviço.

Segredos dão a capacidade de armazenar dados com segurança fora de uma definição de pod. As contas de serviço permitem conceder e revogar o acesso a recursos de pods. 

Como os secrets contas de serviço têm escopo para um namespace, você pode acessá-los usando apenas contas com permissões apropriadas para o namespace. 

Além disso, os logs de auditoria permitem a rastreabilidade de contas que acessam recursos por meio da API.

Clone o Git Repo
Clone o projeto do Github: https://github.com/IBM/k8s-service-accounts

O diretório raiz deste projeto contém todos os arquivos YAML de amostra, o diretório docker contém o Dockerfile usado pelo pod.

Cada arquivo YAML é nomeado com base no recurso criado. Por exemplo, o arquivo api-reader-cluster-roles.yaml 
define as funções do cluster que você usa neste projeto.

O arquivo api-reader-all-in-one.yaml contém todas as definições em um único arquivo. Você pode revisar os recursos de um único local, no entanto, neste guia, você cria cada recurso individualmente.


#### Inicie o Minikube

Para que o Kubernetes cumpra as funções das contas de serviço, você deve ativar o suporte RBAC (Role-Based Access Control) no Minikube.

```
minikube start --kubernetes-version v1.10.0 --vm-driver=hyperkit --extra-config='apiserver.Authorization.Mode=RBAC'
```

* Criar o Namespace

Quando você executa o Kubernetes como um ambiente multi-tenant ou multi-project, você cria namespaces para os recursos do escopo. Você cria itens como pods, secrets e contas de serviço em um namespace e pode definir cotas de recursos no nível do namespace. 

* Crie um novo namespace. 

Use a seguinte definição de recurso:

```
apiVersion: v1
kind: Namespace
metadata:
name: dev
```

Você pode encontrar a definição de namespace no arquivo api-reader-dev-namespace.yaml

Para criar o namespace "dev", execute este comando:

```
$ kubectl create -f api-reader-dev-namespace.yaml 
namespace "dev" criado
```

Para permitir que o kubectl execute comandos no namespace dev, altere o contexto do kubectl. O comando a seguir obtém o nome do cluster atual e atualiza o contexto usado para executar comandos nele:

```
 kubectl config set-context dev --namespace=dev 
```

O nome do cluster atual é "minikube", altera para o contexto de dev, a partir desse comando abaixo qualquer comando que executarmos com o kubectl o namespace default será o dev.

* Trocar o namespace atual.

```
kube config use-context dev
```

* Verificar qual o contexto usado no momento.
```
kube config current-context
```
* Criar o Secret

Um segredo é um objeto usado para armazenar informações confidenciais, como senhas e chaves de autenticação. Neste exemplo, um nome de usuário e senha são armazenados para fins de demonstração. Dados secretos devem ser codificados em base64. 

Obs: secrets são armazenados em texto plano no ETCD,  a codificação base64 não é considerado uma criptografia.

O secret é definido no arquivo api-reader-secret.yaml . 

Seu conteúdo segue:

Segredo com valores codificados em base64 

```
---
apiVersion: v1 
tipo: 
Metadados secretos : 
nome: api-access-secret 
type: 
Dados opacos : 
username: YWRtaW4 = 
password: cGFzc3dvcmQ =
```

Para criar o segredo, execute este comando:
```
kubectl create -f api-reader-secret.yaml 
secret "api-access-secret" criado
```
Para verificar se o secret foi criado, execute este comando:

```
kubectl get secrets api-access-secret 
```
 
* Crie as Services Accounts (contas de serviço)

Podemos anexar contas de serviço a pods e usá-las para acessar a API do Kubernetes. 
Se uma conta de serviço não estiver definida na definição de conjunto, o pod usa a conta de serviço padrão para o namespace. 

Os arquivos denominados token , ca.crt e namespace são montados automaticamente no  diretório /var/run/secrets/kubernetes.io/serviceaccount/ de cada contêiner. Seu conteúdo é baseado no nome da conta de serviço - SA que você fornece. 

Kubernetes docs

Nota: Os segredos mostrados no diretório /var/run/secrets/kubernetes.io/serviceaccount/ 
são segredos específicos da conta de serviço que são montados pelo sistema Kubernetes, não o secret criado. O acesso a este segredo não indica que o pod pode acessar outros segredos com este token.

As contas de serviço são definidas no arquivo api-reader-service-accounts.yaml. 

Segue seu conteúdo:

```
---
# SA que não acessa a API.

apiVersion: v1
kind: ServiceAccount
metadata:
name: no-access-sa
---
# SA para acessar secrets na API
apiVersion: v1
kind: ServiceAccount
metadata:
name: secret-access-sa
---
```

* Criar os service accounts,executando o comando abaixo:
```
 kubectl create -f api-reader-service-accounts.yaml

serviceaccount "no-access-sa" created
serviceaccount "secret-access-sa" created
```

* Rode o comando abaixo para testar se as contas de serviços foram criadas:

```
kubectl get serviceaccounts
NAME SECRETS AGE
default 1 24m
no-access-sa 1 5m
secret-access-sa 1 5m
```

* Crie Cluster Roles no cluster

Uma ClusterRole (função do cluster) define um conjunto de permissões que é usado para acessar recursos, como pods e secrets. As cluster roles estão no escopo do cluster. 

As cluster roles definidas aqui são anexadas às contas de serviço por meio de uma role binding (associação de função). Usando uma associação de função.

As funções do cluster são definidas no arquivo api-reader-cluster-roles.yaml.

Seu conteúdo é mostrado:

```
--- 
# Uma Role sem acesso 

apiVersion: rbac.authorization.k8s.io/v1beta1 
kind: 
Metadados ClusterRole : 
name: no-access-cr 
: 
- apiGroups: [""] # "" indica os principais 
recursos do grupo API : [""] verbos: [""] 
--- 
# Uma Role para ler / listar segredos 

apiVersion: rbac.authorization.k8s.io/v1beta1 
tipo: 
Metadados do ClusterRole : 
nome: secret-access-cr 
regras: 
- apiGroups: [""] # "" indica os principais 
recursos do grupo da API : ["secrets"] verbos: ["get", "list"]

```
* Para criar as funções de cluster, execute este comando:

```
kubectl create -f-api-reader-cluster-roles.yaml 
clusterrole "no-access-cr" criado 
clusterrole "secret-access-cr" criado
```
* Para verificar se as Roles e as ClusterRoles foram criadas, execute este comando:
```
 kubectl get clusterroles 
```

* Criando  Role binding
  
Para aplicar funções de cluster a contas de serviço, crie role bindings que as conectem. Quando você vincula uma função de administrador a uma conta de serviço, as permissões definidas em uma role são concedidas à conta.

As ligações de função são definidas no arquivo api-reader-role-bindings.yaml 

```
--- 
# A vinculação de função para combinar a conta de serviço sem acesso e a 
apiVersão de função : rbac.authorization.k8s.io/v1beta1 
kind: 
Metadados de RoleBinding : 
nome: no-access-rb 
assuntos: 
- kind: ServiceAccount 
nome: no- access-sa 
roleRef: 
tipo: ClusterRole 
nome: no-access-cr 
apiGroup: rbac.authorization.k8s.io 

--- 
# A vinculação de função para combinar a conta de serviço de acesso secreto e a 
apiVersão de função : rbac.authorization.k8s.io / v1beta1 
tipo: 
Metadados RoleBinding : 
nome: secret-access-rb 
assuntos: 
- tipo: ServiceAccount 
nome: secret-access-sa 
roleRef: 
tipo: ClusterRole
nome: secret-access-cr 
apiGroup: rbac.authorization.k8s.io
```

* Para criar essas ligações de função, execute este comando:

```
kubectl create -f api-reader-role-bindings. 
yaml rolebinding "no-access-rb" criado 
rolebinding "secret-access-rb" criado
```

* Para visualizar as ligações de função, execute este comando:

```
kubectl get rolebindings 
saida do comando...
NAME KIND 
no-acesso-rb RoleBinding.v1beta1.rbac.authorization.k8s.io 
secret-access-rb RoleBinding.v1beta1.rbac.authorization.k8s.io
```

* o Dockerfile para testar as SA

O Dockerfile para este exemplo contém um único pod. Quando você executa o Dockerfile, instala o curl no contêiner e copia um script runtime.sh , que contém os comandos que o contêiner executa na inicialização.

Para construir esta imagem do Docker localmente, alterne para o diretório do Docker e execute este comando:
```
docker build -t <docker_image_tag>.
```
O Dockerfile:

```
# ibmcloudprivate/k8s-service-accounts 
FROM ubuntu 

# Copiar arquivos 
COPY runtime.sh / 
# Modificar permissões de arquivo 
RUN chmod + x runtime.sh 

# Instalar curl 
RUN atualização do 
apt-get RUN apt-get install curl -y 

# Executar script na inicialização 
CMD ["/runtime.sh"]

# O script runtime.sh contém o seguinte código:

#!/bin/bash 

# Ler arquivos montados 
KUBE_TOKEN = $ (</var/run/secrets/kubernetes.io/serviceaccount/token) 
```

* Criando os Pods

Você usa contas de serviço para acessar a API de dentro de um pod. Nesse modelo, seu contêiner acessa a API de segredos em tempo de execução, em vez de referenciar segredos na definição de agrupamento YAML. Os segredos referenciados na especificação YAML não cumprem as permissões da conta de serviço.

As informações da conta de serviço são montadas automaticamente no diretório /var/run/secrets/kubernetes.io/serviceaccount/ e consistem nos arquivos ca.crt , namespace e token .

Os pods são definidos em api-reader-pods.yaml. Se você criou a imagem do docker localmente na etapa Revisar o Dockerfile , substitua os  valores do parâmetro de imagem ibmcloudprivate / k8s-service-accounts neste YAML pelo nome da imagem que você construiu.

```
--- 
# Crie um pod com o 
tipo de conta de serviço sem acesso : Pod 
apiVersion: 
metadados v1 : 
name: 
especificação no-access-pod : 
serviceAccountName: no-access-sa 
containers: 
- nome: no-access-container 
   image: ibmcloudprivate / k8s-service-accounts

 --- 
# Crie um pod com o 
tipo de conta de serviço de acesso secreto : Pod 
apiVersion: v1 
metadados: 
nome: secr-access-pod 
spec: 
serviceAccountName: 
contêineres secret-access-sa : 
- name:    imagem de recipiente de acesso secreto 
: ibmcloudprivate / k8s-service-accounts
```

* Para criar esses pods, execute este comando:

```
$ kubectl create -f api-reader-pods.yaml 
rolebinding "não-acesso-rb" criado 
rolebinding "secret-access-rb" criado
```

Para verificar se as ligações de função foram criadas, execute o seguinte comando:

```
$ kubectl get pods 
NOME PRONTO STATUS RESTAURANTES IDADE 
sem acesso-pod 0/1 ContêinerCriando 0 9s 
acesso secreto-pod 0/1 ContêinerCriando 0 9s
```

* Visualizar a saída do pod

Esta etapa verifica se um dos pods pode acessar a API de segredos e o outro não.
Verifique se ambos os pods que você criou estão em execução, executando este comando:

```
$ kubectl get po 
NOME READY STATUS REESTARES IDADE 
sem acesso-pod 1/1 Rodando 0 57s 
secr-access-pod 1/1 Rodando 0 57s
```
Execute este comando para obter os logs do pod de não acesso:

```
$ kubectl logs no-access-pod 
curl -sSk -H Autorização: Bearer <token> https://10.0.0.1:443/api/v1/namespaces/dev/secrets 

Usuário "system: serviceaccount: dev: no-access- sa "não pode listar segredos no namespace" dev ".
```

A saída do comando mostra que o acesso foi negado.

Execute este comando para visualizar os logs do pod de acesso secreto. A saída do comando inclui o segredo que você criou.

```
$ kubectl logs secrets-access-pod 
```

Tente acessar os segredos em outro namespace
Você pode usar o Kubernetes para executar outros comandos em contêineres no seu pod. Quando você executa o script runtime.sh no contêiner, pode passar um parâmetro de namespace para ele. Se você não passar um parâmetro de namespace para ele, ele usará o namespace da conta de serviço.

Execute o script runtime.sh e especifique o namespace default, conforme mostrado neste comando:

$ Exec kubectl -É segredo-access-pod /runtime.sh padrão 
onda -sSk -H Authorization: Bearer <token> https://10.0.0.1:443/api/v1/namespaces/default/secrets 
usuário "sistema: ServiceAccount : dev: secret-access-sa "não pode listar segredos no namespace" default ".
Como a conta de serviço é definida para o namespace dev, ela não está autorizada a usar o namespace padrão. Seu acesso ao namespace padrão é negado.

 

#### Visualizar os logs de auditoria

Os registros de auditoria permitem que os administradores visualizem os recursos específicos que uma conta acessou. Os logs de auditoria são armazenados no sistema que hospeda o Minikube. Você definiu o local de armazenamento de logs quando iniciou o Minikube usando o parâmetro `-- extra-config`.


### Conclusão
As contas de serviço são uma ferramenta poderosa para administração de cluster, pois você pode usá-las para controlar e exibir o acesso de recursos no Kubernetes. Você pode usá-los para limitar o acesso a um namespace específico. Você deve limitar os pods a acessar apenas o que eles precisam. A capacidade de saber quem acessou quais recursos e quando eles os acessaram fornece informações sobre a atividade do cluster.


