Nome do Role
=========

Uma breve descrição do papel vai aqui.

Requisitos
------------

Quaisquer pré-requisitos que não possam ser cobertos pela própria Ansible ou pela função devem ser mencionados aqui. Por exemplo, se a função usar o módulo EC2, pode ser uma boa ideia mencionar nesta seção que o pacote boto é necessário.

Variáveis ​​de Função
--------------

Uma descrição das variáveis ​​configuráveis ​​para essa função deve ser incluída aqui, incluindo quaisquer variáveis ​​que estejam em defaults / main.yml, vars / main.yml e quaisquer variáveis ​​que possam / devam ser configuradas por meio de parâmetros para a função. Quaisquer variáveis ​​que são lidas de outras funções e / ou do escopo global (por exemplo, hostvars, group vars, etc.) devem ser mencionadas aqui também.

Dependências
------------

Uma lista de outras funções hospedadas no Galaxy deve ser exibida aqui, além de quaisquer detalhes em relação aos parâmetros que podem precisar ser definidos para outras funções ou variáveis ​​que são usadas de outras funções.

Exemplo de Playbook
----------------

Incluir um exemplo de como usar sua função (por exemplo, com variáveis ​​passadas como parâmetros) é sempre bom para os usuários também:

    - hosts: servidores
      funções:
         - {role: username.rolename, x: 42}

Licença
-------

BSD

Informação sobre o autor
------------------

Uma seção opcional para os autores da função incluir informações de contato ou um site (HTML não é permitido).