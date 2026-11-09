# Portfólio Escrita de Testes BDD - Projeto Magalu

**Descrição:** Usuário deve adicionar itens aos Favoritos, e consultar Listagem;

**Pré-condições:** Usuário deve estar logado no ecommerce

**Feature:** Lista de Favoritos

**Resultado esperado:** Adicionar itens aos favoritos.

**Observações Gerais:** Melhoria na listagem - adicionar filtro de adicionados recentes e mais antigos;

---

**Teste 1:** Validar adicionar itens a lista de Favoritos com sucesso

**Steps:**

1. Dado que usuário esteja @logado no Ecommerce Magalu
2. E navegue por produtos
3. E usuário clique em um produto
4. E usuário redireciona para página do produto
5. Quando usuário clicar no ícone de coração `>Favoritos`
6. Então deve adicionar na lista de Favoritos

---

**Teste 2:** Validar Listagem de Produtos adicionados aos Favoritos com sucesso

**Steps:**

1. Dado que usuário clicou no `>Menu`
2. E usuário clicou em `>Favoritos`
3. Quando redirecionar para página de Favoritos
4. Então deve listar todos os produtos adicionados nos Favoritos

**Evidências em anexo**

---

> Cada evidência destacada na cor vermelha sinaliza que precisa de atenção (neste caos) ou a funcionalidade falhou. Adicionar destaques em Verde para os casos que teve sucesso, para evidênciar o funcionamento. Adicionar Vídeo contendo o fluxo da função. Caso tenha alguma Observação, adicionar no Caso de Teste. Sugerir com o Time se possível abrir melhoria. Caso função ocorra falha, deve reportar no BUG.
