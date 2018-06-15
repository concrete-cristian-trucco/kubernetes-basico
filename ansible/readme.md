## Ansible

### Introdução

Ansible é uma simples e poderosa ferramenta de automatização criada para gerenciar múltiplas máquinas de uma vez. Além disso, é uma engine que permite executar Ansible Playbooks.

Uma das principais características que faz o Ansible ser atrativo para uso em relação à automação de serviços é a sua linguagem bastante simples, ao ponto de ser “humanamente legível”, isto é, não precisando ter um notável conhecimento técnico para entender o que está sendo feito. Pelo fato da linguagem ser de fácil entendimento, é possível começar a criar serviços de automação de forma fácil e rápida. E para auxiliar ainda mais o entendimento do que está sendo processado, as tasks são executadas na ordem em que são escritas.

Outras duas características interessantes do Ansible são: Ele é simples de começar a utilizar, pois apenas utiliza SSH para se conectar com os servidores e executar as tasks; e o Ansible utiliza do princípio da idempotência, isto é, seus módulos não executarão uma ação que não mudarão o estado do sistema.

Por fim, o Ansible funciona em cima de uma arquitetura sem a presença de agentes (agentlesss) e não necessita de uma infraestrutura de segurança customizada, fazendo com que o processo de automação seja mais eficiente e mais seguro.

O Ansible funciona com suporte de uma linguagem própria baseada em YAML. Sua estrutura é composta por:

* **Playbook:**
Playbooks são a forma pelo qual o Ansible consegue configurar uma política ou passos de um processo de configuração. São feitos para serem fáceis de ler e podem realizar desde deploys de máquinas remotas até delegar ações com diferentes hosts através da interação com servers de monitoramento.

* **Play:**
Um Playbook pode contar várias plays que nada mais são que uma espécie de introdução para as tasks. Isso é, uma play contém várias tasks e define as propriedades que serão utilizadas para as mesmas. Isso é, nome de hosts, permissões de acesso, portas http. As configurações para as tasks são definidas aqui.

* **Task:**
As tasks são onde o trabalho vai ser efetivamente realizado. Elas contém as definições do que será instalado ou qual arquivo será copiado para o servidor que está sendo configurado, por exemplo. As tasks contém modules, que efetivamente vão realizar o trabalho de automatização.

* **Module:**
As tasks são o local onde o trabalho ocorrerá, mas quem efetivamente o realiza são os modules. São parecidos com os resources do Chef, onde você pode definir diversas atividades, como iniciar um serviço, alterar aquivos com base em um template e outra infinidade de coisas. Por exemplo, há modulos responsáveis por instalar pacotes (apt), adicionar um repositório via ppa (apt_repository), entre outros.

* **Handler:**
São opcionais, sendo estruturas que são ativadas por tasks e são executadas quando são notificadas por uma task. Por exemplo, após a instalação e configuração de um serviço, talvez seja interessante que você reinicie o mesmo. Essa é uma das ocasiões em que o uso de um handler é aconselhado.

Uma característica interessante dos handlers, que é fortemente ligada ao princípio da idempotência, é que, caso mais de uma task notifique a execução de um handler, este só será executado uma vez ao fim do bloco de tasks.

### Rodar o playbook passando usuário e senha

* O comando abaixa executa o playbook passando o arquivo de hosts informando usuário e senha.
```
ansible-playbook -i hosts main.yml -u root --ask-pass
```

### Rodar o playbook modo verboso

```
ansible-playbook -i hosts main.yml -u root --ask-pass -vvv
```

#### Gerar a chave para não pedir mais senha
```
ssh-keygen
```
### Copiar chave ssh para o host remoto

```
ssh-copy-id root@192.168.2.99
```

