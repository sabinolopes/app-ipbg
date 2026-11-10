# Projeto: App da Igreja Presbiteriana de Guaçuí

App mobile (iOS e Android, sem web) para a Igreja Presbiteriana de Guaçuí (ES): hinário, Bíblia (ARA e NAA), contatos, agenda do pastor com solicitação de horário e boletim semanal.

Público: qualquer pessoa, sem login. Menos de 200 usuários. O que é crítico: hinário e Bíblia funcionam offline; nome e telefone de quem solicita horário nunca ficam legíveis pela API pública.

Este guia segue a skill `arquitetura-base` (`.claude/skills/arquitetura-base`) e prevalece sobre ela quando forem diferentes.

## 1. Stack

- **Flutter / Dart** no cliente.
- **Supabase** (plano gratuito) para contatos, boletins e agenda. Projeto `igreja-guacui-app`.
- **SQLite local (sqflite)** para hinário e Bíblia, que não ficam no Supabase. Ainda não implementado.
- Gestão de conteúdo pelo Table Editor do Supabase; não há painel administrativo no app.

## 2. Regras críticas do projeto

- **Tabela nova no Supabase precisa de grant explícito.** O projeto foi criado com "Automatically expose new tables" desativado: além da política de RLS, é preciso `grant select/insert ... to anon`. Sem isso a API responde "tabela não encontrada" (PGRST205).
- **O projeto gratuito pausa após cerca de uma semana sem requisições.** O keep-alive ainda não foi configurado.
- **Só a chave publicável entra no app** (`lib/shared/config.dart`). A `service_role` nunca entra no repositório.
- **Agendamento é só online**, direto no servidor, sem fila offline.
- **Texto da ARA e da NAA depende de licença da SBB**, ainda pendente. Não embutir o texto sem ela.

## 3. Fluxos de negócio importantes

- **Solicitar horário com o pastor** (a implementar): o usuário escolhe um horário livre e informa nome e telefone. Dois pedidos não podem ocupar o mesmo horário, e essa garantia precisa estar no banco, não no app.

## 4. Modelo de dados (Supabase)

| Tabela | Campos | Acesso público |
|---|---|---|
| `contacts` | `id`, `name`, `role` (`pastor`, `elder`, `deacon`), `phone`, `email`, `photo_url`, `created_at` | leitura |
| `bulletins` | `id`, `title`, `content`, `pdf_url`, `publication_date`, `created_at` | leitura |
| `schedule_slots` | `id`, `date`, `start_time`, `end_time`, `is_available`, `created_at` | leitura |
| `appointments` | `id`, `slot_id`, `requester_name`, `requester_phone`, `status` (`pending`, `confirmed`, `cancelled`), `created_at` | só inserção, sem leitura |

## 5. Telas

- **Contatos** (pronta): pastor, presbíteros e diáconos, nessa ordem, com cargo e telefone.
- Boletim, agenda, hinário e Bíblia: a implementar, nessa ordem.

## 6. Padrões de código

Toda entrega tem dois tempos: (1) faça funcionar, com testes reais e segurança desde a primeira linha; (2) refatore para a menor complexidade possível.

### Idioma

- **Tudo no código em inglês**: pastas, arquivos, classes, funções, variáveis, comentários, descrições de teste e mensagens de log. O banco também é em inglês.
- **Em português**: os textos que o usuário vê na tela, as mensagens de commit e a documentação (este guia e os READMEs).

### Regras gerais

- **Imports sempre por `package:app_igreja_guacui/...`**, nunca relativos em `lib/`.
- **Sem `print`**: use `logError` de `lib/shared/logger.dart`. Nada de nome ou telefone em log.
- **Resultado padronizado**: serviços devolvem `Result` (`Success` ou `Failure` com mensagem para o usuário), de `lib/shared/result.dart`. Exceção é só para o inesperado.
- Comentários explicam o porquê, nunca o quê.

O lint (`analysis_options.yaml`) roda com zero avisos. O Dart não tem regra pronta para complexidade cognitiva, limite de parâmetros, níveis de bloco e abreviações: isso fica para a revisão.

### Testes

- `flutter_test`, em `test/` espelhando `lib/` (convenção do Flutter), arquivos `*_test.dart`.
- Implementações em memória das interfaces ficam em `test/support/`.
- Zero testes falsos; bug corrigido = teste que reproduz o bug primeiro.
- Antes de concluir: `./tools/check.sh` (formatação + análise + testes). O pré-commit roda o mesmo.

## 7. Organização por domínio (`lib/domains/`)

| Arquivo | Papel | Regra |
|---|---|---|
| `types.dart` | Tipos e funções puras do domínio | sem infraestrutura |
| `<x>_repository.dart` | Interface de acesso a dados | só o contrato |
| `supabase_<x>_repository.dart` | Implementação real | só traduz dados e lança erro |
| `<x>_service.dart` | Regras de negócio | dependências por parâmetro, testado em memória |
| `README.md` | O que o módulo faz e como testar | atualizado junto com o código |

Crie só os papéis que tiverem conteúdo. As implementações reais são escolhidas em `lib/main.dart` e entregues aos serviços.

Domínios: `contacts` (lista de liderança, só leitura).

Pastas sem domínio: `lib/shared/` (result, logger, config) e `lib/providers/` (um cliente externo por pasta).

## 8. Interface (`lib/ui/`)

| Camada | Pasta | O que é | Pode importar |
|---|---|---|---|
| Elementos | `elements/` | peças genéricas: `MessageWithAction`, `LoadingIndicator` | só Flutter |
| Blocos | `blocks/<name>/` | uma funcionalidade: `contact_list` | elementos, blocos, tipos dos domínios |
| Páginas | `pages/` | uma tela inteira com seu estado | elementos, blocos, domínios |

- Cada bloco tem um `index.dart` que exporta o que o resto do app usa; importe por ele.
- Interface não busca dados: páginas recebem funções de carregamento pelo construtor.
- Texto e regra de tela vão para função pura com teste (ex.: `roleLabel`).
- Antes de repetir estilo, procure o elemento.

## 9. Fluxo de trabalho

### Commits

Crie a mensagem de commit seguindo o padrão:

- Idioma: **Português do Brasil**
- Prefixo: `feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `perf`, `test`
- Escopo: **obrigatório**, entre parênteses, dizendo onde foi a mudança, com as pastas separadas por ponto (`lib.domains`, `lib.ui`, `tools`)
- Limite do header: **100 caracteres**
- Exemplo: `git commit -m "fix(lib.domains): corrige a ordenação da lista de contatos"`

O hook `.githooks/commit-msg` recusa mensagens fora do padrão. Commit e push só quando pedido.

### Outros

- Em um clone novo, ative os hooks com `git config core.hooksPath .githooks`.
- Mudanças de schema no Supabase vão por migração nomeada.
- Regra nova surgiu numa tarefa → registre aqui.
