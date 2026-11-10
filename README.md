# App da Igreja Presbiteriana de Guaçuí

App mobile (iOS e Android) com hinário, Bíblia, contatos, agenda do pastor e boletim semanal.

## Como rodar

```sh
flutter pub get
git config core.hooksPath .githooks   # ativa os hooks de commit, uma vez por clone
flutter run                           # com um simulador ou aparelho aberto
```

## Checagem

```sh
./tools/check.sh
```

Roda formatação, análise (zero avisos) e testes. O pré-commit executa o mesmo.

## Arquitetura e regras

Veja [CLAUDE.md](CLAUDE.md).
