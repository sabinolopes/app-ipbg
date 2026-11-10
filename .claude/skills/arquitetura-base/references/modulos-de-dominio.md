# Módulos de domínio

O código de negócio fica agrupado **por domínio** (`precos/`, `usuarios/`, `pagamentos/`), e cada domínio usa **os mesmos papéis de arquivo**. Quem conhece um módulo conhece todos.

## Os papéis

| Papel | O que faz | Regra |
|---|---|---|
| **tipos** | Tipos, constantes e funções puras do vocabulário do domínio | Não depende de nada de infraestrutura |
| **validação** | Lê a entrada crua (formulário, corpo da requisição) e devolve dados limpos ou a lista de erros | Função pura, testada |
| **repositório** | Acesso a dados atrás de uma **interface** (`RepositorioDePrecos`) | Só traduz entre o banco e os tipos do domínio e lança erro; nenhuma regra de negócio |
| **consultas / SQL** | O texto das consultas, separado de quem as executa | Sempre parametrizadas (`{ texto, valores }`), nunca concatenando entrada |
| **serviço** | As regras de negócio | Recebe repositórios e integrações por parâmetro (objeto desestruturado) e devolve um resultado padronizado; testado com implementações em memória |
| **leituras** | O que as telas/rotas precisam ler | Sem regra; escolhe o cliente certo (público com cache, sessão do usuário) |
| **ações / handlers** | Ponto de entrada de uma escrita (endpoint, ação de servidor, comando) | Camada fina: checa acesso → valida → chama o serviço → invalida cache → responde |
| **rotas** | Mapa `método + caminho → handler` com os guardas de acesso | Só o mapa; nenhuma lógica |
| **README do módulo** | O que o módulo faz, endpoints/ações, regras temporais, configuração e segredos necessários, como testar | Atualizado junto com o código |

Não é preciso criar todos os papéis em todo domínio. Um domínio só de leitura pode ter apenas `tipos` e `leituras`. Crie o papel quando ele tiver conteúdo.

## Fluxo de uma escrita

```
entrada (rota / ação / tela)
   │  1. checa acesso (quem é, tem permissão?)        ← no topo, antes de tudo
   │  2. valida a entrada                             ← validação
   ▼
serviço                                               ← regras de negócio
   │  usa interfaces recebidas por parâmetro
   ▼
repositório / armazenamento / integração              ← implementação real escolhida na entrada
   │
   ▲  resultado padronizado { ok, dados } | { ok: false, erro }
entrada
   │  3. invalida cache / registra evento
   │  4. responde
```

## Dependências apontam para dentro

- Entrada → serviço → **interfaces**. O serviço importa apenas os *tipos* das interfaces, nunca a implementação.
- A implementação real (banco, armazenamento de arquivos, provedor de e-mail) é escolhida **na entrada** e passada ao serviço.
- Se o serviço precisa de mais de 3 dependências, recebe um objeto `{ repositorio, armazenamento, diretorio }`.
- Isso permite testar o serviço com implementações em memória, sem banco nem rede, e trocar o provedor sem tocar na regra.

## Resultado padronizado

Serviços e ações devolvem um formato único, por exemplo `{ ok: true, dados }` ou `{ ok: false, erro: "mensagem para o usuário" }`. Exceção é para o inesperado; regra de negócio violada é um resultado, não uma exceção.

## Pastas compartilhadas

- **Utilidades genéricas** (formatação, parse, o tipo do resultado padronizado, clientes de infraestrutura): numa pasta sem domínio (`lib/`, `essentials/`, `shared/`). Só entra o que não conhece nenhum domínio.
- **Provedores** (clientes de banco, cache, SDKs externos): um por pasta. Quando crescer, divida em arquivos e mantenha um `index` de fachada que reexporta tudo — quem usa não muda o import (aberto para extensão, fechado para modificação).
- **Simulações de SDK externo** para testes ficam numa pasta própria de mocks, nunca misturadas ao código real.

## Convenções que ajudam a escalar

- **Um handler por arquivo**, nomeado pela ação (`adicionar`, `remover`, `listar`, `salvar`, `ver`), ou `entidade_acao` quando o domínio tem várias entidades. Se o handler tem teste próprio e arquivos auxiliares, ele vira uma pasta.
- **Um arquivo por consulta** numa subpasta de SQL, quando o projeto usa SQL escrito à mão.
- **Remoção lógica** (`removido_em`) quando o histórico importa; transação quando várias escritas precisam acontecer juntas.
- **Payloads** com uma convenção de caixa única (ex.: camelCase) em toda a API.
- **Imports/requires no topo** do arquivo, nunca no meio da função (salvo carregamento sob demanda proposital e comentado).

## Sinal de alerta: a pasta plana gigante

Uma pasta com dezenas ou centenas de arquivos soltos (`usuario_cria.js`, `usuario_lista.js`, `usuario_plano_troca.js`…) é o sintoma de domínio que cresceu sem ser dividido. Quebre em subdomínios, cada um com seus papéis.
