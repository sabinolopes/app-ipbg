# Modelo de guia do projeto

Use como ponto de partida do guia de arquitetura de um repositório (CLAUDE.md, AGENTS.md ou README de arquitetura). Preencha com a realidade do projeto, corte o que não se aplica e mantenha curto: o guia é lido a cada tarefa. Troque os termos genéricos pelos nomes reais da stack (pastas, comandos, ferramentas).

---

```markdown
# Projeto: <nome> — <uma linha sobre o que é>

No ar em <url>. <Onde roda, região, contas.>

<Dois ou três parágrafos: o problema, o público, o que é crítico (ex.: auditabilidade, tráfego viral, dados sensíveis).>

## 1. Stack
- <Linguagem / framework / banco / armazenamento / hospedagem>, com o porquê de cada escolha não óbvia.

## 2. Regras críticas do projeto
<Restrições que, se quebradas, derrubam o projeto: limites de plano gratuito, cache obrigatório, armadilhas da versão do framework.>

## 3. Fluxos de negócio importantes
<Passo a passo dos fluxos que têm regra sensível (cadastro, pagamento, auditoria).>

## 4. Modelo de dados
<Tabelas/coleções com campos, tipos e restrições.>

## 5. Telas
<Lista das telas e o que cada uma mostra/faz.>

## 6. Padrões de código
Toda entrega tem dois tempos: (1) faça funcionar, com testes reais e segurança desde a primeira linha; (2) refatore para a menor complexidade possível.

### Regras que o lint garante (<arquivo de config>, zero avisos)
- Return early (sem else depois de return, no máximo 2 níveis de bloco)
- Sem ternário aninhado
- Complexidade cognitiva ≤ 12
- No máximo 3 parâmetros
- Sem abreviações (exceções do domínio: <lista>)
- Imports pelo alias <alias>, sem ../
- Sem saída de console solta: use <logger>

### Regras de revisão humana
- Comentários em <língua>, explicando o porquê
- Validação sempre no servidor (<arquivo>); permissão vem de <fonte controlada pelo servidor>
- Falhe de forma segura: nunca modo mock/demo
- Nada sensível em logs ou respostas

### Testes (<ferramenta>, arquivos <padrão> ao lado do código)
- Zero testes falsos; bug corrigido = teste que reproduz o bug primeiro
- Antes de concluir: `<comando check>`; o pré-commit roda o mesmo

## 7. Organização por domínio (<pasta>)
| Arquivo | Papel | Regra |
|---|---|---|
| tipos | ... | sem infraestrutura |
| validação | ... | pura, testada |
| repositório | ... | só traduz dados |
| serviço | ... | dependências por parâmetro, testado em memória |
| leituras | ... | sem regras |
| ações/handlers | ... | fina: acesso → validação → serviço → cache |

Domínios: <lista com uma linha cada>.

## 8. Componentes (<pasta>)
| Camada | Pasta | O que é | Pode importar |
|---|---|---|---|
| Elementos | ... | peças genéricas: <lista dos que existem> | utilitários |
| Blocos | ... | uma funcionalidade | elementos, blocos, módulos |
| Páginas | ... | uma tela inteira | elementos, blocos, módulos |

<Estrutura de pasta de um bloco e as regras: procure o elemento antes de repetir estilo, lógica fora da marcação, filho → pai por callback, importe pelo index.>

## 9. Fluxo de trabalho
- Commits: Conventional Commits em <língua>, cabeçalho ≤ 100 caracteres
- Geradores: `<comando>` cria <bloco/módulo> a partir de <pasta de modelos>
- Evolução contínua: regra nova surgiu numa tarefa → registre aqui
```
