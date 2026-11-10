# Bulletins

Lista os boletins semanais da igreja, do mais recente para o mais antigo. Domínio só de leitura.

- **Fonte:** tabela `bulletins` do Supabase, com leitura pública.
- **Conteúdo:** cada boletim pode ter um texto (`content`), um PDF (`pdf_url`) ou os dois.
- **Link do PDF:** só é aceito se for um endereço `https` válido. Qualquer outra coisa é tratada como boletim sem PDF, porque o app abre esse link.
- **Falha de rede:** o serviço devolve um `Failure` com mensagem para o usuário e registra o erro técnico.

Para publicar um boletim, suba o PDF no Storage do Supabase e crie a linha no Table Editor com o link público.

## Como testar

```sh
flutter test test/domains/bulletins
```
