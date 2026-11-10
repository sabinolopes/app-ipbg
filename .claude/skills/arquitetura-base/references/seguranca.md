# Segurança

Segurança é parte do "faça funcionar", não uma etapa posterior. Use o OWASP Top 10 como referência mínima.

## Princípios

- **Falhe de forma segura.** Variável de configuração faltando, integração fora do ar ou permissão indefinida → bloqueia com mensagem clara. Nunca modo mock/demo, nunca "se não tiver chave, finge que deu certo".
- **Nunca confie no cliente.** Toda validação acontece também no servidor, mesmo que a tela já valide. IDs, papéis e preços vindos do cliente são só sugestões.
- **Permissão vem de fonte controlada pelo servidor** (metadados que só o servidor escreve, tabela de papéis), nunca de um campo que o próprio usuário pode editar.
- **Acesso checado no topo** de toda rota, ação ou tela protegida, antes de qualquer leitura ou escrita. Quando o banco oferece regras de acesso por linha, use-as também (defesa em profundidade).
- **Menor privilégio.** A chave com poder total fica só no servidor, nunca exposta ao navegador nem commitada.

## Entrada

- Consultas **sempre parametrizadas**. Nunca concatene entrada do usuário em SQL, comandos ou caminhos.
- Valide tipo, tamanho e formato de tudo (inclusive arquivos: tipo real, tamanho máximo).
- Normalize antes de comparar (espaços, caixa, acentos) para evitar duplicatas e bypass.
- Texto do usuário que vai para um modelo de linguagem é sanitizado e delimitado (risco de injeção de prompt).

## Segredos

- Segredos em variáveis de ambiente ou no cofre do provedor, nunca no código, nunca no repositório (inclusive arquivos de conta de serviço `.json`).
- `.env` e arquivos de credencial no ignore desde o primeiro commit; um `.env.example` sem valores documenta o que é necessário.
- Se um segredo vazou num commit, **troque o segredo** — apagar o arquivo não basta, o histórico guarda.
- Nunca peça nem cole segredo em conversa, issue ou log.

## Logs e respostas

- Logger padronizado com níveis; nunca saída de console solta.
- Nada de chave, token, senha ou dado pessoal em log, mensagem de erro ou resposta de API.
- Erro para o usuário é genérico; o detalhe técnico vai para o log (sem segredos).

## Contas e convites

- Senhas fortes, nunca senha padrão compartilhada; prefira convite por link de uso único.
- Links de uso único só são "gastos" quando a pessoa conclui a ação — pré-visualizadores de link (mensageiros, e-mail) abrem a URL sozinhos.
- Proteja contra tomada de conta: não gere link de redefinição/convite para conta já ativa sem confirmação do dono; nunca permita remover o próprio acesso nem o último administrador.
- Expiração curta para links e tokens, e informe a validade na mensagem.

## Outros

- CORS restrito às origens conhecidas.
- Endpoints de tarefa agendada aceitam só chamadas com o cabeçalho/assinatura do agendador.
- Uploads com nome gerado pelo servidor (ex.: hash do conteúdo), nunca o nome enviado pelo cliente.
- Dependências atualizadas e auditadas periodicamente.
