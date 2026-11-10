# Fluxo de trabalho

## Configuração mínima do repositório (antes da primeira feature)

1. **Lint** com as regras de `principios-de-codigo.md`, rodando com **zero avisos tolerados**. Aviso que ninguém corrige vira ruído e esconde o que importa.
2. **Checagem de tipos** (quando a linguagem tem).
3. **Testes** com um comando só.
4. **Um comando `check`** que roda os três em sequência.
5. **Pré-commit** que roda a checagem (de preferência só nos arquivos alterados, para ser rápido) e bloqueia o commit se falhar. Nunca pule o hook.
6. **`.editorconfig`**: UTF-8, fim de linha LF, 2 espaços (ou o padrão da linguagem), linha final em branco, sem espaço sobrando no fim da linha.
7. **Ignore** com `.env`, credenciais, artefatos de build e dependências.
8. **Guia do projeto** a partir de `modelo-guia-do-projeto.md`.

## Commits

- **Conventional Commits**, mensagem na língua do time (pt-BR por padrão):
  - `feat`: funcionalidade nova
  - `fix`: correção de bug
  - `refactor`: mudança sem alterar comportamento
  - `perf`: desempenho
  - `test`: testes
  - `docs`: documentação
  - `style`: formatação
  - `chore`: manutenção, dependências, configuração
- Cabeçalho com no máximo 100 caracteres; escopo opcional (`feat(precos): ...`).
- Um commit = uma mudança coerente. Corpo explica o porquê quando não for óbvio.
- Valide o formato com uma ferramenta de lint de commits quando possível.
- Commit e push só quando o usuário pedir.

## Geradores a partir de modelos

Quando o projeto tem estrutura repetida (bloco, módulo de domínio, handler), mantenha **modelos (boilerplates)** numa pasta própria e um comando que gera a estrutura a partir deles ("gerar bloco galeria em areas/site"). Isso garante que toda peça nasce no padrão — com `index`, teste e README — em vez de cada um copiar de um lugar diferente.

## Ao terminar uma tarefa

1. Checagem completa passando.
2. Refatoração para a menor complexidade (segundo tempo da entrega).
3. README do módulo/bloco atualizado, se o comportamento mudou.
4. **Evolução contínua:** surgiu uma regra nova ou um padrão relevante? Sugira registrá-lo no guia do projeto.
