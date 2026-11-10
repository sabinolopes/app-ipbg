---
name: arquitetura-base
description: Arquitetura base para projetos de software, independente de linguagem ou framework — organização por domínio (tipos → validação → repositório → serviço → leituras → ações), interface em camadas (elementos → blocos → páginas), código legível (return early, sem abreviações, complexidade baixa), testes reais, segurança desde a primeira linha e um guia de arquitetura vivo no repositório. Use SEMPRE que for iniciar um projeto novo, criar ou reorganizar pastas e módulos, adicionar uma funcionalidade, criar um componente de tela, revisar ou refatorar código, configurar lint/testes/pré-commit ou escrever o guia do projeto (CLAUDE.md, AGENTS.md, README de arquitetura) — mesmo que o usuário não diga "arquitetura", e mesmo que só peça "faz essa feature" ou "organiza esse código".
---

# Arquitetura base

> "A máquina compila qualquer código que funcione; humanos precisam entender esse código para dar manutenção."

Esta skill descreve **como organizar e escrever** o código, não **com o quê**. Vale para qualquer linguagem, framework, banco ou provedor. Quando a stack do projeto tem um jeito próprio de fazer algo (onde ficam as rotas, como se declara cache, qual ferramenta de lint), use o jeito da stack e encaixe nele os papéis descritos aqui.

## Os dois tempos de toda entrega

1. **Faça funcionar** — com testes reais e segurança desde a primeira linha. Qualidade e segurança não ficam "para depois".
2. **Refatore para a menor complexidade possível** — nomes claros, funções curtas, cada coisa no seu papel.

Só considere uma tarefa pronta depois do passo 2 e com a checagem completa do projeto passando (tipos + lint sem avisos + testes).

## Regras de ouro

1. **Cada arquivo tem um papel só.** Regra de negócio não mora na tela, nem na rota, nem no acesso a dados. Veja os papéis em `references/modulos-de-dominio.md`.
2. **Organize por domínio, não por tipo técnico.** `precos/`, `usuarios/`, `pagamentos/` — cada um com os mesmos papéis de arquivo. Nada de uma pasta gigante e plana com cem arquivos.
3. **Dependências apontam para dentro.** Entrada (rota, ação, tela) → serviço → interfaces. O serviço não conhece banco, rede ou framework; recebe tudo por parâmetro.
4. **Rotas e telas são finas.** Só recebem a entrada, chamam o serviço e devolvem/renderizam o resultado.
5. **Return early.** Validações negativas no topo, caminho feliz sem indentação. Sem `else` depois de `return`, sem condicional dentro de condicional ternária.
6. **Nomes por extenso.** `evento`, `resposta`, `erro`, `preco` — nunca `e`, `res`, `err`, `p`. Exceção: termos do domínio e convenções universais da stack.
7. **Funções pequenas.** No máximo 3 parâmetros (acima disso, um objeto nomeado), no máximo 2 níveis de bloco, complexidade cognitiva baixa (≈12). Passou disso, fatie em funções com nome descritivo.
8. **Zero testes falsos.** Todo teste exercita uma regra real. Bug corrigido = primeiro um teste que reproduz o bug.
9. **Falhe de forma segura.** Configuração faltando ou integração quebrada bloqueia o fluxo com mensagem clara. Nunca modo mock/demo nem fallback que finja sucesso.
10. **Nunca confie no cliente.** Validação sempre no servidor; permissões vêm de uma fonte que só o servidor controla; checagem de acesso no topo de toda entrada protegida.
11. **Nada sensível em logs ou respostas.** Sem chaves, tokens ou dados pessoais. Use o logger padronizado do projeto, nunca a saída de console solta.
12. **O guia de arquitetura é vivo.** Quando uma regra nova surgir durante uma tarefa, sugira registrá-la no guia do projeto (ver "Evolução contínua").

## Como agir em cada situação

**Projeto novo**
1. Monte a estrutura de pastas por camadas e domínios (`references/modulos-de-dominio.md` e `references/camadas-de-interface.md`).
2. Configure antes da primeira feature: lint com as regras de `references/principios-de-codigo.md` (zero avisos), testes, checagem de pré-commit e `.editorconfig` (`references/fluxo-de-trabalho.md`).
3. Escreva o guia do projeto a partir de `references/modelo-guia-do-projeto.md`.

**Nova funcionalidade ou regra**
1. Identifique o domínio. Se não existir, crie a pasta com os papéis necessários (não precisa criar todos).
2. Comece pelo **serviço com teste**, usando implementações em memória das interfaces. Só depois ligue a ação/rota e a tela.
3. Na interface, antes de escrever estilo repetido, procure o elemento que já existe. Lógica de tela vai para arquivo puro com teste.
4. Rode a checagem completa e refatore.

**Revisão ou refatoração**
Use `references/checklist-de-revisao.md`. Aponte o problema, o porquê e a correção concreta, em ordem de gravidade (segurança > correção > arquitetura > legibilidade).

## Referências — leia conforme a tarefa

| Arquivo | Quando ler |
|---|---|
| `references/principios-de-codigo.md` | Ao escrever ou revisar qualquer código: legibilidade, nomes, return early, complexidade, comentários, valores vazios |
| `references/modulos-de-dominio.md` | Ao criar/organizar regra de negócio, acesso a dados, rotas, ações ou integrações |
| `references/camadas-de-interface.md` | Ao criar telas e componentes, ou organizar a pasta de interface |
| `references/testes.md` | Ao escrever qualquer teste ou corrigir um bug |
| `references/seguranca.md` | Ao tocar em autenticação, permissões, entrada do usuário, arquivos, segredos, logs ou integrações |
| `references/fluxo-de-trabalho.md` | Ao configurar o repositório, commitar, criar geradores de código ou atualizar o guia |
| `references/checklist-de-revisao.md` | Ao revisar código (seu ou de outra pessoa) |
| `references/modelo-guia-do-projeto.md` | Ao criar ou atualizar o guia de arquitetura do projeto |

## Evolução contínua

O guia do projeto (CLAUDE.md, AGENTS.md ou equivalente) é a fonte da verdade daquele repositório e prevalece sobre esta skill quando forem diferentes. Quando, durante uma tarefa, surgir um padrão novo ou uma regra de arquitetura relevante (um elemento visual que virou reutilizável, uma armadilha da stack, uma decisão de segurança), **sugira ao usuário registrá-la no guia**, no lugar certo e em poucas linhas. Conhecimento que fica só na conversa se perde.
