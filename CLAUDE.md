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

- **Solicitar horário com o pastor:** o usuário escolhe um horário livre e informa nome e telefone. Dois pedidos não podem ocupar o mesmo horário, e quem garante é o banco: o gatilho `appointments_reserve_slot` reserva o horário na mesma transação do pedido e recusa o segundo com `slot_unavailable`. Cancelar ou apagar o pedido libera o horário. Detalhes em `lib/domains/schedule/README.md`.
- **Nome e telefone de quem pede** nunca vão para log nem para mensagem de erro; o repositório repassa só o código do erro do banco.

## 4. Modelo de dados (Supabase)

| Tabela | Campos | Acesso público |
|---|---|---|
| `contacts` | `id`, `name`, `role` (`pastor`, `elder`, `deacon`), `board_position` (`president`, `vice_president`, `first_secretary`, `second_secretary` ou vazio), `phone`, `email`, `photo_url`, `created_at` | leitura |
| `bulletins` | `id`, `title`, `content`, `pdf_url`, `publication_date`, `created_at` | leitura |
| `schedule_slots` | `id`, `date`, `start_time`, `end_time`, `is_available`, `created_at` | leitura |
| `appointments` | `id`, `slot_id`, `requester_name` (3 a 80 letras), `requester_phone` (10 ou 11 dígitos), `status` (`pending`, `confirmed`, `cancelled`), `created_at` | só inserção com status `pending`, sem leitura |

As migrações ficam em `supabase/migrations/`.

## 5. Telas

A navegação entre as seções é uma barra inferior em `lib/ui/pages/home_page.dart`. Só a seção selecionada é construída, então cada visita recarrega os dados.

- **Boletins** (pronta): lista do mais recente para o mais antigo; ao tocar, abre o boletim com o texto e o botão "Abrir PDF", que mostra o PDF num navegador por cima do app.
- **Agenda** (pronta): horários livres e futuros do pastor; ao tocar, abre o formulário de nome e telefone e envia o pedido.
- **Contatos** (pronta): pastor, presbíteros e diáconos, nessa ordem, com cargo, posição no Conselho ou na Junta Diaconal e telefone.
- Hinário e Bíblia: a implementar, nessa ordem.

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
| `validation.dart` | Limpa e valida o que o usuário digitou | pura, testada; as mesmas regras existem no banco |
| `<x>_repository.dart` | Interface de acesso a dados | só o contrato |
| `supabase_<x>_repository.dart` | Implementação real | só traduz dados e lança erro |
| `<x>_service.dart` | Regras de negócio | dependências por parâmetro, testado em memória |
| `README.md` | O que o módulo faz e como testar | atualizado junto com o código |

Crie só os papéis que tiverem conteúdo. As implementações reais são escolhidas em `lib/main.dart`, reunidas em `AppDependencies` (`lib/app_dependencies.dart`) e entregues às telas.

Domínios: `bulletins` (boletins semanais, só leitura), `contacts` (lista de liderança, só leitura) e `schedule` (horários do pastor e pedido de horário).

Pastas sem domínio: `lib/shared/` (result, logger, config, long_date) e `lib/providers/` (um cliente externo por pasta: `supabase`, `url_launcher`).

**Link vindo do banco só é aberto se for `https`** (`safePdfLink` em `lib/domains/bulletins/types.dart`). Use a mesma regra para qualquer link novo.

## 8. Interface (`lib/ui/`)

| Camada | Pasta | O que é | Pode importar |
|---|---|---|---|
| Elementos | `elements/` | peças genéricas: `ResultLoader`, `MessageWithAction`, `LoadingIndicator` | Flutter e `lib/shared/` |
| Blocos | `blocks/<name>/` | uma funcionalidade: `appointment_request_form`, `bulletin_list`, `contact_list`, `slot_list` | elementos, blocos, tipos dos domínios |
| Páginas | `pages/` | uma tela inteira com seu estado | elementos, blocos, domínios |

- Cada bloco tem um `index.dart` que exporta o que o resto do app usa; importe por ele.
- Interface não busca dados: páginas recebem funções de carregamento pelo construtor.
- Tela que carrega dados usa o `ResultLoader`, que já trata carregamento, erro e "Tentar novamente".
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
