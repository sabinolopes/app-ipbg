# Contacts

Lista o pastor, os presbíteros e os diáconos da igreja. Domínio só de leitura.

- **Fonte:** tabela `contacts` do Supabase, com leitura pública.
- **Ordem:** pastor, presbíteros, diáconos; dentro do mesmo cargo, por nome.
- **Cargos:** o banco guarda `pastor`, `elder` e `deacon`. Um valor diferente desses faz a listagem falhar, de propósito, para o problema aparecer.
- **Falha de rede:** o serviço devolve um `Failure` com mensagem para o usuário e registra o erro técnico.

Para cadastrar ou alterar um contato, use o Table Editor do Supabase.

## Como testar

```sh
flutter test test/domains/contacts
```
