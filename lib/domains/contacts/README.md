# Contacts

Lista o pastor, os presbíteros e os diáconos da igreja. Domínio só de leitura.

- **Fonte:** tabela `contacts` do Supabase, com leitura pública.
- **Cargos:** o banco guarda `pastor`, `elder` e `deacon`.
- **Posição na diretoria** (`board_position`, opcional): `president`, `vice_president`, `first_secretary` ou `second_secretary`. Para o pastor e os presbíteros, a diretoria é o Conselho; para os diáconos, a Junta Diaconal. O app mostra, por exemplo, "Presbítero · Vice-Presidente do Conselho".
- **Ordem:** pastor, presbíteros, diáconos; dentro do mesmo cargo, primeiro a diretoria (presidente, vice, 1º e 2º secretário), depois os demais por nome.
- **Valor desconhecido:** um cargo ou posição diferente dos listados faz a listagem falhar, de propósito, para o problema aparecer.
- **Falha de rede:** o serviço devolve um `Failure` com mensagem para o usuário e registra o erro técnico.

Para cadastrar ou alterar um contato, use o Table Editor do Supabase. Ao trocar a diretoria, lembre de limpar a posição de quem saiu.

## Como testar

```sh
flutter test test/domains/contacts
```
