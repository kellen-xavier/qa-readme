# Template — Documento de Evidências de Testes

Um Documento de Evidências de Testes é um artefato utilizado para registrar, de forma estruturada, as evidências geradas durante a execução dos testes. Seu principal objetivo é prover rastreabilidade, auditabilidade e comprovação objetiva de que determinado requisito, história de usuário, correção ou entrega foi validado.

>NOTA: O documento não substitui os casos de teste, mas registra a execução e suas evidências.

## ISO/IEC/IEEE 29119

A ISO/IEC/IEEE 29119 is an international family of software testing standards that provides a common vocabulary, processes, documentation guidance, and testing techniques for software quality assurance. Developed jointly by ISO, IEC, and IEEE, it is widely referenced by organizations seeking consistent testing practices across projects, although it has also generated debate within the software testing community about how prescriptive such standards should be.

### O que abrange

A família 29119 is organized into multiple parts, each addressing a different aspect of software testing. Together they define:

- Concepts and terminology for a shared testing vocabulary.

- Test processes applicable at organizational, project, and dynamic testing levels.

- Test documentation templates and recommended content.

- Test techniques, including specification-based, structure-based, and experience-based approaches.

- Guidance for applying the standard in different development contexts.

### Informações Gerais do Template

| Campo                | Informação                                                                 |
| -------------------- | -------------------------------------------------------------------------- |
| Projeto              |                                                                            |
| Sistema              |                                                                            |
| Sprint / Release     |                                                                            |
| Build / Versão       |                                                                            |
| Ambiente             | Desenvolvimento / Homologação / Produção                                   |
| Data da Execução     |                                                                            |
| Responsável          |                                                                            |
| Tipo de Teste        | Funcional / Regressão / Smoke / Integração / API / Performance / Segurança |
| Ferramenta utilizada | Cypress, Playwright, Selenium, Postman etc. Não se Aplica (Manual)         |

### Casos de Teste Executados

| ID | Caso de Teste | Resultado | Observações |
|----|---------------|-----------|-------------|

---

## Estrutura de Documento

CT — Nome do Caso de Teste - `<Objeto>_<Condição>_<ResultadoEsperado>`

>O objetivo da nomenclatura é tornar um teste autoexplicativo, rastreável e de fácil manutenção.

**Um nome deve ser:**

- Descritivo
- Objetivo
- Não ambíguo
- Independente da implementação
- Baseado em comportamento (Behavior), não em detalhes técnicos

### Objetivo

Descrever o objetivo do teste.

### Resultado Esperado

Descrever o comportamento esperado.

### Resultado Obtido

Descrever o comportamento observado.

### Evidências

#### Screenshot(s)

```txt
/evidencias/screenshots/CT001_01.png
```

OBS: deve mostrar em capturas de tela, o passo a passo visualmente seguindo os steps para que seja auditável.

---

## Referencias

[IEEE IEEE 829 - Standard for Software Test Documentation – descontinuado porém amplamente referenciado](https://en.wikipedia.org/wiki/Institute_of_Electrical_and_Electronics_Engineers)

[ISO/IEC/IEEE 29119 (atual padrão internacional para documentação de testes)](https://www.iso.org/standard/81291.html)

[ISTQB CTFL Foundation Level Syllabus](https://bstqb.online/ctfl)
