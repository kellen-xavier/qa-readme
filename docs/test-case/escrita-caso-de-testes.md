# Portfólio Escrita de Testes BDD - Projeto Dell (DEN)

**Descrição:** Usuário que está logado no portal e deseja solicitar um suporte deve enviar formulário de chamado, com sucesso para plataforma e chamados do Portal DEN.

**Pré-condições:** Usuário deve estar logado na plataforma

**Feature:** Envio de formulário para abertura de chamados

**Resultado esperado:** Deve enviar o formulário com sucesso e deve ter mensagem avisando usuário que envio foi realizado;

**Observações Gerais:** Nenhuma observação cadastrada.

**Teste:** Validar envio de formulário Logado com Sucesso

**Steps:**

1. Dado que usuário esteja @logado no sistema DEN
2. E clicou na aba do header em suporte
3. E usuário foi redirecionado para página Suporte
4. Quando usuário preencher todos os campos obrigatórios do @formulário
5. Então usuário clica no botão habilitado @Abrir_chamado
6. E deve enviar com sucesso o formulário para o sistema de chamados do Portal DEN
7. E deve mostrar uma mensagem de sucesso no envio do formulário para o usuário
