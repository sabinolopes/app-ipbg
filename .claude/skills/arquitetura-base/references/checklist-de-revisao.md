# Checklist de revisão

Percorra na ordem de gravidade. Para cada problema, diga **onde** (arquivo:linha), **por quê** e **a correção concreta**.

## 1. Segurança
- [ ] Toda entrada protegida checa acesso no topo?
- [ ] Validação acontece no servidor?
- [ ] Permissão vem de fonte que só o servidor controla?
- [ ] Consultas parametrizadas, sem concatenação de entrada?
- [ ] Algum segredo no código, no repositório ou exposto ao navegador?
- [ ] Algum dado sensível em log, erro ou resposta?
- [ ] Falha de configuração/integração bloqueia com mensagem clara, sem fingir sucesso?

## 2. Correção
- [ ] Há teste para cada regra nova? Ele falharia se a regra quebrasse?
- [ ] O bug corrigido tem teste que o reproduz?
- [ ] Bordas tratadas: vazio, só espaços, zero, limites, acentos, duplicatas?
- [ ] Ausente vs. falso/zero/vazio distinguidos corretamente?

## 3. Arquitetura
- [ ] Cada arquivo no seu papel (regra no serviço, acesso a dados no repositório, entrada fina)?
- [ ] Organizado por domínio, sem pasta plana gigante?
- [ ] Serviço recebe dependências por parâmetro e importa só interfaces?
- [ ] Componente sem busca de dados e sem regra de negócio na marcação?
- [ ] Filho → pai só por callback?
- [ ] Estilo repetido que deveria ser um elemento?
- [ ] Importa pelo `index` do bloco e pelo alias da raiz?

## 4. Legibilidade
- [ ] Return early, no máximo 2 níveis de bloco, sem ternário aninhado?
- [ ] Funções curtas, complexidade baixa, no máximo 3 parâmetros?
- [ ] Nomes por extenso, no vocabulário do domínio?
- [ ] Comentários explicam o porquê, na língua do time?
- [ ] Números e textos mágicos viraram constantes nomeadas?

## 5. Fechamento
- [ ] Checagem completa passa (tipos + lint sem avisos + testes)?
- [ ] README/guia atualizado se uma regra ou comportamento mudou?
