# AGENTS

## Repositório

Este repositório é documental: padrões de QA, bugs, casos de teste BDD, evidências, consultas SQL e material de apoio.

## AGENTE.md — Processo de Qualidade de Software com a metodologia Extreme Programming XP

## 1. Objetivo

Este documento define o processo de qualidade de software do projeto com base em Extreme Programming XP.

O objetivo é estabelecer um fluxo de trabalho orientado a:

- feedback rápido;
- desenvolvimento incremental;
- testes como parte do desenvolvimento;
- integração contínua;
- refatoração contínua;
- simplicidade;
- comunicação frequente;
- colaboração entre papéis;
- software funcionando como principal evidência de progresso;
- gestão visual sem microgerenciamento.

Este processo não existe para fiscalizar pessoas. Ele existe para tornar visível o fluxo de entrega, os riscos, os bloqueios e a qualidade técnica do software.

---

## 2. Fundamento Metodológico

Este projeto adota XP como base metodológica para qualidade de software.

XP parte da premissa de que mudanças são esperadas durante o desenvolvimento. Por isso, o processo deve reduzir o custo de mudança por meio de práticas técnicas, ciclos curtos de feedback e colaboração contínua.

As práticas centrais consideradas neste processo são:

- histórias pequenas;
- planejamento incremental;
- testes automatizados;
- test-first sempre aplicável;
- integração contínua;
- refatoração;
- design simples;
- propriedade coletiva do código;
- programação colaborativa;
- ritmo sustentável;
- releases pequenas;
- cliente ou negócio próximo do time - sempre.

---

## 3. Valores XP Aplicados ao Processo

## 3.1 Comunicação

O processo deve favorecer comunicação direta e frequente.

Isso significa:

- critérios de aceite claros;
- dúvidas registradas no card quando impactarem a entrega;
- decisões funcionais documentadas;
- alinhamento entre Produto, Desenvolvimento e QA;
- PRs pequenos e compreensíveis;
- evidências objetivas.

O board não substitui conversa técnica. Ele apenas torna visível o estado do trabalho.
Não deve ser para microgerenciamento.

---

## 3.2 Simplicidade

A solução deve resolver o problema atual com o menor nível necessário de complexidade.

Evitar:

- abstração prematura;
- documentação redundante;
- fluxo burocrático;
- card grande demais;
- PR grande demais;
- automação sem valor de regressão;
- processo maior que o problema.

A pergunta central deve ser:

```text
Qual é a solução mais simples que atende ao critério de aceite e preserva a qualidade?
```

## 3.3 Feedback

XP depende de feedback rápido.

O processo deve permitir feedback em vários níveis:

- feedback do teste local (Unitários).
- feedback da pipeline.
- feedback do PR.
- feedback do QA/Testes durante o desenvolvimento.
- feedback do Produto durante refinamento e validação.
- feedback da homologação.
- feedback de produção.

Quanto mais tarde o erro aparece, **maior tende a ser o custo de correção**.

## 3.4 Coragem

Coragem em XP significa tratar problemas reais cedo.

Exemplos:

- Apontar critério de aceite fraco.
- Recusar card sem informação mínima.
- Quebrar demanda grande em histórias menores.
- Refatorar código problemático.
- Corrigir teste instável.
- Registrar risco de entrega.
- Expor bloqueio no fluxo.
- Não mascarar retrabalho como progresso.

## 3.5 Respeito

O processo deve respeitar pessoas e papéis.

Isso significa:

- Não usar board como ranking individual.
- Não medir valor por quantidade de cards.
- Não comparar produtividade individual.
- Não expor impedimento como falha pessoal.
- Não empurrar qualidade para QA no fim.
- Não tratar teste como tarefa menor.
- Não tratar teste como opcional.
- Não tratar teste como parte final dado como tarefa pronta antes.
- Não forçar entrega sem evidência mínima.

## 4. Princípios Operacionais XP

## 4.1 Teste faz parte do desenvolvimento

Neste processo, não existe separação conceitual entre desenvolver e testar.

**Atividades consideradas parte do desenvolvimento:**

- Implementar código.
- Escrever teste unitário.
- Escrever teste de integração.
- Escrever teste de contrato.
- Escrever teste E2E - quando aplicável.
- validar regra de negócio.
- Validar payload.
- Validar response.
- Validar persistência.
- Validar logs.
- Validar querys.
- Corrigir bugs.
- Retestar bugs.
- Refatorar código.
- Atualizar documentação com técnica necessária.
- Preparar evidências da validação.

**A frase correta é:** Estou desenvolvendo a entrega, incluindo implementação, testes e validações.

**A frase incorreta para este processo é:** Terminei o desenvolvimento, agora vai para teste.

## 4.2 Desenvolvimento é responsável por qualidade

Desenvolvimento é responsável por **entregar software validável.**

Isso inclui:

- Implementar solução.
- Escrever testes compatíveis com o risco.
- Executar testes locais.
- Manter o PR revisável.
- Garantir que a pipeline passe.
- Corrigir falhas automatizadas.
- Manter clareza do código.
- Refatorar quando necessário.
- Registrar impacto técnico.
- Registrar decisões relevantes.

## 4.3 Integração contínua é parte do fluxo

Integração contínua não deve ser tratada como etapa opcional.

Toda mudança deve buscar validação automatizada o mais cedo possível.

A pipeline deve executar, quando aplicável:

- build.
- linters.
- análise estática.
- testes unitários.
- testes de integração.
- testes de contrato.
- validação de documentação.
- validação de migrations.
- geração de relatórios auditáveis.
- verificações de segurança.

>O objetivo é evitar que revisão humana seja desperdiçada em problemas que a automação poderia detectar.

## 4.4 Refatoração é atividade legítima de desenvolvimento

Refatoração não é retrabalho quando preserva comportamento e melhora manutenção.

Refatorar é adequado quando houver:

- duplicidade;
- baixa legibilidade;
- alto acoplamento;
- regra de negócio espalhada;
- testes frágeis;
- complexidade desnecessária;
- dificuldade de manutenção;
- risco de regressão por código confuso.

Refatoração deve ser acompanhada de testes suficientes para reduzir risco.

---

## 4.5 Histórias devem ser pequenas

XP favorece entregas pequenas e frequentes.

Uma demanda deve ser quebrada quando:

- exige PR muito grande;
- mistura regras diferentes;
- envolve muitas telas;
- envolve múltiplas integrações;
- exige muitas decisões pendentes;
- tem risco alto;
- depende de várias áreas;
- não pode ser validada objetivamente.

**Histórias pequenas reduzem:**

- tempo de revisão.
- risco de conflito.
- tempo de feedback.
- custo de correção.
- incerteza de escopo.

## Referencias

- [Livro: Programação Extrema (xp) Explicada - Acolha as Mudanças (Kent Beck)](https://a.co/d/01sw5n5T)
- O programador Pragmático: de aprendiz a mestre
- [Extreme Programming](https://martinfowler.com/bliki/ExtremeProgramming.html)
