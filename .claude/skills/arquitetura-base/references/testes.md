# Testes

Teste existe para impedir que uma regra quebre sem ninguém ver. Se ele não pode falhar por um motivo real, não é teste.

## Regras

1. **Zero testes falsos.** Nada de `espera(verdadeiro).serVerdadeiro()`, teste que só instancia, ou teste que verifica o mock em vez da regra.
2. **Bug corrigido = teste que reproduz o bug primeiro.** Veja o teste falhar, corrija, veja passar.
3. **Testes ao lado do código** (`servico.test` junto de `servico`), com o mesmo nome do arquivo testado.
4. **Descrições em linguagem de negócio, na língua do time:** "segura o envio sem foto", não "testa a função submit".
5. **O que testar primeiro:** serviços (regras), validação, funções puras de tela. São baratos e pegam a maioria dos bugs.

## Por camada

| Camada | Como testar |
|---|---|
| Validação e funções puras | Entrada → saída, incluindo bordas (vazio, só espaços, limites, acentos) |
| Serviço | Com **implementações em memória** das interfaces (um repositório que guarda num array). Verifique o resultado e o estado final, não as chamadas internas |
| Repositório / integração | Poucos testes, contra o recurso real em ambiente de teste ou com o SDK simulado na pasta de mocks |
| Componentes | No ambiente de DOM simulado, testando o que o usuário vê e faz: papel acessível, clique, digitação. Nunca detalhes internos (estado, nome de classe) |
| Fluxo ponta a ponta | Para os caminhos críticos (login, cadastro, pagamento), quando o projeto tiver ferramenta para isso |

## Implementação em memória vs. mock

Prefira uma implementação em memória da interface (um objeto de verdade, com comportamento) a mocks que só registram chamadas. Ela testa o comportamento, sobrevive a refatorações e documenta o contrato. Use mock só para o que não dá para simular (SDK externo, relógio, aleatoriedade) e deixe-os na pasta de mocks.

## Autochecagem: o teste pegaria o bug?

Antes de considerar um teste pronto, pergunte: *se eu inverter esta condição ou trocar este número na regra, o teste falha?* Se não, ele não protege nada. Quando der, faça a mudança de propósito e confira.

## Antes de concluir

Rode a checagem completa (tipos + lint sem avisos + testes). O pré-commit deve rodar o mesmo e bloquear o commit se algo falhar.
