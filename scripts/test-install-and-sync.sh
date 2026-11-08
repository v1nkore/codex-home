#!/usr/bin/env bash
set -euo pipefail

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/codex-home-test.XXXXXX")"
trap 'rm -rf -- "${test_root}"' EXIT

fixture="${test_root}/repo"
fake_home="${test_root}/home"
mkdir -p "${fixture}/scripts" "${fixture}/skills/example" "${fake_home}/skills/example"
cp "${repo_root}/install.sh" "${fixture}/install.sh"
cp "${repo_root}/scripts/sync-from-home.sh" "${fixture}/scripts/sync-from-home.sh"
cp "${repo_root}/scripts/export-portable-config.py" "${fixture}/scripts/export-portable-config.py"
printf 'Public rules\n' > "${fixture}/AGENTS.md"
printf 'model = "gpt-6-sol"\n' > "${fixture}/config.portable.toml"
printf 'new skill\n' > "${fixture}/skills/example/SKILL.md"

git -C "${fixture}" init -q
git -C "${fixture}" -c user.name=Test -c user.email=test@example.invalid add .
git -C "${fixture}" -c user.name=Test -c user.email=test@example.invalid commit -qm initial

printf 'Private rules\n' > "${fake_home}/AGENTS.md"
printf 'model = "gpt-5-sol"\n' > "${fake_home}/config.toml"
printf 'old skill\n' > "${fake_home}/skills/example/SKILL.md"

CODEX_HOME="${fake_home}" "${fixture}/install.sh" >/dev/null
cmp "${fixture}/AGENTS.md" "${fake_home}/AGENTS.md"
cmp "${fixture}/config.portable.toml" "${fake_home}/config.toml"
cmp "${fixture}/skills/example/SKILL.md" "${fake_home}/skills/example/SKILL.md"
python3 - "${fake_home}/config.toml" <<'PY'
import os
import stat
import sys

if stat.S_IMODE(os.stat(sys.argv[1]).st_mode) != 0o600:
    raise SystemExit("Installed config.toml is not private")
PY
backup_dir="$(find "${fake_home}/backups" -mindepth 1 -maxdepth 1 -type d -print -quit)"
test -n "${backup_dir}"
test "$(cat "${backup_dir}/AGENTS.md")" = 'Private rules'
test "$(cat "${backup_dir}/config.toml")" = 'model = "gpt-5-sol"'
test "$(cat "${backup_dir}/skills/example/SKILL.md")" = 'old skill'
CODEX_HOME="${fake_home}" "${fixture}/install.sh" >/dev/null
test "$(find "${fake_home}/backups" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" = '2'

printf 'Private routing\n' > "${fake_home}/AGENTS.md"
cat > "${fake_home}/config.toml" <<'EOF'
model = "gpt-6-sol"
[mcp_servers.private]
token = "TEST_VALUE_ONLY"
EOF
printf 'updated skill\n' > "${fake_home}/skills/example/SKILL.md"
CODEX_HOME="${fake_home}" "${fixture}/scripts/sync-from-home.sh" >/dev/null
test "$(cat "${fixture}/AGENTS.md")" = 'Public rules'
test "$(cat "${fixture}/skills/example/SKILL.md")" = 'updated skill'
grep -q 'model = "gpt-6-sol"' "${fixture}/config.portable.toml"
if grep -q 'TEST_VALUE_ONLY' "${fixture}/config.portable.toml"; then
  printf 'Private config value was exported.\n' >&2
  exit 1
fi
if CODEX_HOME="${fake_home}" "${fixture}/scripts/sync-from-home.sh" >/dev/null 2>&1; then
  printf 'Sync overwrote unreviewed repository changes.\n' >&2
  exit 1
fi
if CODEX_HOME="${fake_home}" "${fixture}/scripts/sync-from-home.sh" --push >/dev/null 2>&1; then
  printf 'Unsafe --push mode remained available.\n' >&2
  exit 1
fi

printf 'Install and sync checks passed.\n'
