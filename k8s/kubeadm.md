### Kubeadm

Executando kubeadm initbootstraps um cluster do Kubernetes. Isso consiste nas seguintes etapas:

O kubeadm executa uma série de verificações prévias para validar o estado do sistema antes de fazer alterações. Algumas verificações só acionam avisos, outras são consideradas erros e saem do kubeadm até que o problema seja corrigido ou o usuário especifique --skip-preflight-checks.

O kubeadm gera um token que nós adicionais podem usar para se registrar no mestre no futuro. Opcionalmente, o usuário pode fornecer um token.

O kubeadm gera uma CA auto-assinada para fornecer identidades para cada componente (incluindo nós) no cluster. Também gera certificados de clientes para serem usados ​​por vários componentes.

Saída de um arquivo kubeconfig para o kubelet usar para conectar-se ao servidor da API, bem como um arquivo kubeconfig adicional para administração.

O kubeadm gera manifestos do Kubernetes Static Pod para o servidor da API, o gerenciador do controlador e o planejador. Coloca-os  /etc/kubernetes/manifests. O kubelet observa este diretório para Pods criar na inicialização. Estes são os principais componentes do Kubernetes. Uma vez em funcionamento, o kubeadm pode configurar e gerenciar quaisquer componentes adicionais.

O kubeadm "corrompe" o nó mestre para que somente os componentes do plano de controle sejam executados nele. Também configura o sistema de autorização RBAC e grava um ConfigMap especial que é usado para inicializar a confiança com os kubelets.

O kubeadm instala componentes complementares através do servidor da API. Neste momento, este é o servidor DNS interno e o daemon Kube-proxy.

A execução kubeadm joinem cada nó no cluster consiste nas seguintes etapas:

O kubeadm faz o download das informações da CA raiz do servidor da API. Ele usa o token para verificar a autenticidade desses dados.

O kubeadm cria um par de chaves local. Ele prepara uma solicitação de assinatura de certificado (CSR) e a envia para o servidor da API para assinatura. O token de bootstrap é usado para autenticar. O servidor da API está configurado para assinar isso automaticamente.

kubeadm configura o kubelet local para se conectar ao servidor da API
