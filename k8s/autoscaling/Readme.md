### Horizontal Pod Autoscaler

**Horizontal Pod Autoscaler** dimensiona automaticamente o número de conjuntos em um RC(controlador de replicação), 
deployment ou conjunto de réplicas com base na utilização da CPU observada (ou base em outras métricas 
fornecidas pelo aplicativo como memória).

Este documento apresenta um exemplo de HPA Automático de Podshorizontal para containers usando imagem do Nginx.
O container inicia o pod de Nginx com 2 replicas e após um dos pods atingir mais de 50% de uso de cpu o Kube provisiona mais um container isso até atingir o máximo de replicas definida no yaml que está para 10 replicas.
