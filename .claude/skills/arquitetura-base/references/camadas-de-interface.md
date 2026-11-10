# Camadas de interface

A interface é organizada em **duas dimensões**: o *nível de reuso* (de quão longe a peça pode ser usada) e o *tamanho* (Atomic Design: elementos → blocos → páginas).

## Nível de reuso

| Camada | O que guarda | Exemplo |
|---|---|---|
| **Núcleo** (`core/`) | Primitivas do próprio projeto que não sabem nada do produto: utilitários funcionais, roteador, eventos, middlewares, diretivas de comportamento | Funções de composição, máscara de campo, carregamento sob demanda |
| **Essenciais** (`essentials/`, `components/`) | O que é compartilhado entre todas as áreas do produto | Elementos, blocos, páginas, modelos de layout, comportamentos, provedores |
| **Áreas** (`app/`, `admin/`, `site/`, `auth/`…) | O que pertence a uma área do produto só | A tela de configurações do admin |

Uma área pode importar dos essenciais e do núcleo; os essenciais importam do núcleo; o núcleo não importa ninguém. Nunca o contrário.

## Tamanho (Atomic Design)

| Camada | O que é | Pode importar |
|---|---|---|
| **Elementos** (átomos) | Peças genéricas, sem domínio: botão, campo, alerta, selo, painel, modal, esqueleto de carregamento | Só utilitários genéricos |
| **Blocos** (moléculas) | Uma funcionalidade do domínio: galeria, gráfico, formulário de cadastro | Elementos, outros blocos, tipos e ações dos módulos de domínio |
| **Páginas** (organismos) | A composição de uma tela inteira com o estado que liga os blocos | Elementos, blocos, módulos |
| **Modelos** (layouts) | O esqueleto de cada área: cabeçalho, menu, rodapé | Elementos, blocos |

Duas famílias complementam:
- **Comportamentos reutilizáveis** (`actions/`): coisas que se "ligam" a qualquer peça — fechar com Esc, travar rolagem, copiar para a área de transferência, paginação, download. Cada um com `ativar`/`desativar` (ou equivalente) e limpeza garantida.
- **Provedores** (`providers/`): clientes de dados e estado global — sessão do usuário, guarda de acesso, cookies, plano contratado. Um por pasta, cliente único (singleton) quando faz sentido.

## Estrutura de um bloco

Cada bloco numa pasta, mesmo que tenha um arquivo só:

```
blocos/formulario-de-preco/
  index            ← só reexporta o que o resto do app usa
  formulario-de-preco   ← composição (pouca lógica)
  use-formulario-de-preco ← estado e ações, quando há estado não trivial
  etapa-foto ...   ← subcomponentes do próprio bloco
  regras-do-formulario  ← regras puras, sem framework de UI, sempre com teste
  README           ← quando o bloco tem uso não óbvio
```

## Regras

- **Antes de escrever estilo repetido, procure o elemento.** Se um padrão visual aparece em 2+ blocos, ele vira elemento.
- **Lógica fora da marcação.** Cálculo, formatação de texto e regra de tela vão para arquivo puro com teste (`dados-do-grafico`, `opcoes-de-filtro`, `texto-de-compartilhar`). Estado com várias ações vai para um hook/controlador próprio.
- **Interface não busca dados.** Componentes não chamam banco nem rede; recebem dados por props e chamam as ações do módulo de domínio.
- **Comunicação filho → pai só por callback** (`aoMudar`, `aoSelecionar`, `aoFechar`). Filho nunca chama método do pai nem lê estado de irmão.
- **Importe pelo `index` do bloco**, não pelos arquivos internos (exceto nos testes do próprio bloco).
- **Rotas/telas de entrada só buscam dados e montam** uma página ou blocos; sem marcação própria além de layout.
- **Controle de acesso no topo de toda tela protegida**, antes de qualquer busca de dados.
- **Textos de interface** na língua do público, no próprio componente. Se houver mais de um idioma, extraia para arquivos de texto por bloco/área desde o início.
- **Acessibilidade é requisito:** papéis e rótulos corretos, foco gerenciado em modais, estados de carregamento anunciados, nada comunicado só por cor.
- **Carregamento por bloco:** cada bloco que busca dados tem seu esqueleto, para a tela aparecer aos poucos em vez de esperar tudo.
- **Rastreamento/analytics** isolado em sua própria pasta (`pixels/`), nunca espalhado pelos componentes.
