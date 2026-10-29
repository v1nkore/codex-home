# Codex home

Переносимая копия глобальных настроек и skills Codex.

## Что хранится

- `AGENTS.md` — глобальные правила работы Codex.
- `config.portable.toml` — безопасная переносимая часть настроек.
- `skills/` — зафиксированная копия всех установленных пользовательских и curated skills.
- `sources/` — происхождение и лицензии сторонних наборов skills.
- `install.sh` — восстановление на новом устройстве с резервными копиями.
- `scripts/sync-from-home.sh` — обновление репозитория из текущего `~/.codex`.

Системные skills из `~/.codex/skills/.system` не копируются: они устанавливаются и обновляются самим Codex.

## Восстановление на новом устройстве

Сначала установите и хотя бы один раз запустите Codex. Затем:

```bash
git clone git@github.com:v1nkore/codex-home.git
cd codex-home
./install.sh
```

Скрипт сохранит прежние `AGENTS.md`, `config.toml` и отличающиеся skills в `~/.codex/backups/`, после чего установит снимок из репозитория. Перезапустите Codex.

## Синхронизация изменений

Обновить локальный снимок без отправки:

```bash
./scripts/sync-from-home.sh
git diff
```

Обновить, создать коммит и отправить:

```bash
./scripts/sync-from-home.sh --push
```

## Что намеренно исключено

Даже в приватном репозитории не хранятся:

- `auth.json`, токены и credentials;
- история чатов, диктовки, сессии и memories;
- SQLite-базы, логи, очереди и кэши;
- installation/device ID;
- абсолютные пути, project trust и локальная конфигурация MCP/runtime.

Эти данные секретны, эфемерны или привязаны к конкретному устройству. `.gitignore` работает как белый список и не позволяет случайно добавить другие файлы из `~/.codex`.

## Сторонние наборы

В снимок включены skills из [`mattpocock/skills`](https://github.com/mattpocock/skills). Точная версия и лицензия сохранены в `sources/mattpocock-skills/`.
