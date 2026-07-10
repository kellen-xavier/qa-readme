# Abertura de BUG - Projeto XYZ

## Título do BUG [Funcionalidade XX]

BUG Plataforma | Ação X não está respondendo conforme esperado

**Data:** dd/mm/aa

>Adicione no documento de evidências de testes, quando foi cadastrato a inconformidade. Dado importante para rastreabilidade

**Cenário:** Plataforma_ADMIN | Edit a material video's record must be login

**Descrição do cenário do Teste:** Deve poder editar vídeo somente para quem está  logado na Plataforma

**Repro Steps:**

> Como foi exatamente os passos realizados (ação) que resultou o comportamento atual

(Dado) Given in the portal admin panel

(E) And edit a vídeo

(E) And must be active

(Quando) When the option 'Only visible to companies' disabled

(Então) Then must have the videos in Materials, visible to everyone on the portal

---

**BUG:** When saving the option only for companies is saving enabled by default - Descrição objetiva do BUG

**Critério de Aceite:** Qual critério não foi atendido

**Evidências:** Prints com destaque onde está ocorrendo o erro/ Vídeo do Fluxo/ Log de eventos de Erros ocorrendo/ Trecho do código

**Grau de impacto no Sistema/Severidade:** Crítica/Alta/Média/baixa

**Prioridade:** Alta/Média/Baixa

**Informações do Sistema:** Tem alguma informação a mais sobre como ocorreu esse erro ? Adicionar as informações aqui. Exemplo “somente ocorre no Navegador X”.

**Histórico de Alterações:** pode ser commits das correções ou histórico do mesmo (repositório do projeto).

**Referências:** incluír os Casos de Testes

**Status:** Aberto/Diferido/Duplicado/Aguardando correção/Aguardando confirmação/Reaberto/ Fechado

---

> Objetivos desta estrutura de BUG (e relatório): Essa estrutura é indicada para poder gerenciar os reports de bugs para o time de desenvolvimento (e outros), contendo informações sobre qualquer evento adverso ocorrido, para identificação de qualquer efeitos específicos, isolar o problema com um teste mínimo de reprodução e corrigir o defeito potencial conforme a necessidade ou resolver o problema.

[Referencias - ISTQB CTFL Syllabus](https://bcr.bstqb.org.br/docs/syllabus_ctfl_3.1br.pdf)
