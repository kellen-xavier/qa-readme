# Abertura de BUG - Projeto XYZ

<strong>Título do BUG:</strong> BUG Plataforma | Ação X não está respondendo conforme esperado

<strong>Data:</strong> dd/mm/aa

<strong>Cenário:</strong> Plataforma_ADMIN | Edit a material video's record
must be login

<strong>Descrição do cenário do Teste:</strong> Deve poder editar vídeo somente para quem está  logado na Plataforma

<strong>Repro Steps:</strong>

(Dado) Given in the portal admin panel

(E) And edit a vídeo

(E) And must be active

(Quando) When the option 'Only visible to companies' disabled

(Então) Then must have the videos in Materials, visible to everyone on the portal



<strong>BUG:</strong> When saving the option only for companies is saving enabled by default - Descrição objetiva do BUG

<strong>Critério de Aceite:</strong> Qual critério não foi atendido

<strong>Evidências:</strong> Prints com destaque onde está ocorrendo o erro/ Vídeo do Fluxo/ Log de eventos de Erros ocorrendo/ Trecho do código

<strong>Grau de impacto no Sistema/Severidade:</strong> Crítica/Alta/Média/baixa

<strong>Prioridade:</strong> Alta/Média/Baixa

<strong>Informações do Sistema:</strong> Tem alguma informação a mais sobre como ocorreu esse erro ? Adicionar as informações aqui. Exemplo “somente ocorre no Navegador X”.

<strong>Histórico de Alterações:</strong> pode ser commits das correções ou histórico do mesmo (repositório do projeto).

<strong>Referências:</strong> incluír os Casos de Testes

<strong>Status:</strong> Aberto/Diferido/Duplicado/Aguardando correção/Aguardando confirmação/Reaberto/ Fechado



<strong>Objetivos desta estrutura de BUG (e relatório):</strong> Essa estrutura é indicada para poder gerenciar os reports de bugs para o time de desenvolvimento (e outros), contendo informações sobre qualquer evento adverso ocorrido, para identificação de qualquer efeitos específicos, isolar o problema com um teste mínimo de reprodução e corrigir o defeito potencial conforme a necessidade ou resolver o problema. - ISTQB CTFL Syllabus