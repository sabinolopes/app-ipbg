# Schedule

Mostra os horários livres do pastor e envia o pedido de horário, com nome e telefone de quem pede. Só funciona online.

## Regras

- **Horários mostrados:** só os livres (`is_available`) que ainda não começaram, em ordem de data e hora.
- **Nome:** de 3 a 80 letras, sem espaços sobrando.
- **Telefone:** DDD + número, 10 ou 11 dígitos. O app guarda só os dígitos e remove o `55` do país.
- **Um pedido por horário:** quem garante é o banco, não o app. Se o horário foi ocupado enquanto a pessoa preenchia, ela vê "Esse horário acabou de ser reservado".

## Banco

- `schedule_slots`: leitura pública. `appointments`: só inserção, sem leitura, e só com status `pending`.
- O gatilho `appointments_reserve_slot` confere se o horário está livre e no futuro (fuso `America/Sao_Paulo`) e o marca como ocupado na mesma transação. Recusa com o erro `slot_unavailable` (código `P0001`).
- Cancelar (`status = 'cancelled'`) ou apagar um pedido no Table Editor libera o horário de novo.
- As mesmas regras de nome e telefone existem como check constraints.
- Migração: `supabase/migrations/20261110140000_protect_appointment_requests.sql`.

## Privacidade

Nome e telefone nunca vão para o log. O repositório descarta o erro do banco e repassa só o código, porque os detalhes do erro podem repetir a linha enviada.

## Uso pelo pastor ou secretaria

No Table Editor do Supabase: crie os horários em `schedule_slots`; veja os pedidos em `appointments` e mude o `status` para `confirmed` ou `cancelled`.

## Como testar

```sh
flutter test test/domains/schedule
```
