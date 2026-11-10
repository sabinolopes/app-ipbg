# Princípios de código

O objetivo é que qualquer pessoa entenda uma função lendo-a uma vez, de cima para baixo. As regras abaixo devem ser **garantidas pelo lint** sempre que a ferramenta da stack permitir (com zero avisos tolerados); o que o lint não pega fica para a revisão humana.

## Regras que o lint deve garantir

| Regra | Por quê | Como corrigir |
|---|---|---|
| **Return early** — sem `else` depois de `return`, sem `if` sozinho dentro de `else` | O caminho feliz fica sem indentação e as exceções ficam visíveis no topo | Inverta a condição e retorne cedo |
| **No máximo 2 níveis de bloco** | Cada nível a mais é uma pilha mental | Extraia o miolo para uma função nomeada |
| **Sem ternário dentro de ternário** | Ilegível e fácil de errar | Função com guard clauses ou um mapa `tipo → valor` |
| **Complexidade cognitiva ≤ 12 por função** | Acima disso a função faz coisas demais | Fatie em funções com nome que diga o que fazem |
| **No máximo 3 parâmetros** | Parâmetros posicionais demais trocam de lugar sem ninguém ver | Receba um objeto com campos nomeados |
| **Sem abreviações** (e nomes de 1 letra) | `e`, `res`, `ctx` obrigam a adivinhar | `evento`, `resposta`, `contexto`. Exceções: termos do domínio (`kg`, `uf`) e convenções universais da stack |
| **Imports pelo alias da raiz, sem `../`** | Mover arquivos não quebra caminhos e a origem fica clara | Configure um alias para a raiz; caminho relativo só para a mesma pasta |
| **Sem saída de console solta** | Log sem padrão vaza dados e polui produção | Use o logger padronizado do projeto |
| **Sem variáveis/parâmetros não usados** | Ruído e bug escondido | Remova; quando a assinatura exige, use o prefixo convencional de "ignorado" (`_`) |
| **Sem testes focados/pulados esquecidos** | Uma suíte "verde" que não roda tudo mente | O lint de testes bloqueia `only`/`skip` |

## Regras de revisão humana

### Nomes
- Nome diz **o que é** (variável) ou **o que faz** (função), no vocabulário do domínio, não do código: `precoPorKg`, não `valor2`.
- Booleanos como pergunta: `temExifValido`, `estaPronto`, `podeEnviar`.
- Funções puras de regra com verbo ou substantivo claro: `precoPareceErrado(preco)`, `marcaResolvida(campos)`.
- Arquivos com o mesmo nome do que exportam; pasta e arquivo no mesmo estilo de caixa do projeto.

### Comentários
- Na língua do time (pt-BR por padrão).
- Explicam **o porquê**, nunca o quê. Se o comentário descreve o que o código faz, renomeie até o código se explicar sozinho.
- Bons motivos para comentar: uma restrição externa ("o provedor só aceita 1 hora de validade"), uma armadilha ("o pré-visualizador de links abre a URL e gastaria o convite"), uma decisão não óbvia.

### Valores vazios
- Distinga **ausente** de **falso/zero/vazio válido**. Quando `0`, `false` ou `""` são valores válidos, use o operador de "ausente" da linguagem (ex.: coalescência nula); quando qualquer valor falso deve cair no padrão, use o "ou" lógico.
- Normalize entrada uma vez, na borda (validação), e trabalhe com dados limpos no resto.

### Tamanho e forma
- Uma função faz uma coisa. Se o nome precisa de "e" (`validaESalva`), são duas.
- Prefira dados a condicionais: um mapa `estado → rótulo` é mais legível que uma cadeia de `if`.
- Lista de regras de validação como dados (`[{ falhou, mensagem }]`) em vez de uma função com dez `if`.
- Constantes nomeadas para números e textos mágicos (`PRECO_MINIMO_KG`, `TAMANHO_MAXIMO_FOTO`).

### Erros
- Mensagens para o usuário: claras, na língua dele, sem detalhe técnico nem dado sensível.
- Mensagens técnicas (API, logs): padronizadas (o time decide a língua — inglês é comum em APIs) e sem segredos.
- Nunca engula erro em silêncio. Ou trate de verdade, ou propague.
