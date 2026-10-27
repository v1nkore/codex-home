#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_root="$(dirname -- "${script_dir}")"
codex_root="${CODEX_HOME:-${HOME}/.codex}"

if [ ! -f "${codex_root}/AGENTS.md" ] || [ ! -f "${codex_root}/config.toml" ]; then
  printf 'Expected AGENTS.md and config.toml under %s\n' "${codex_root}" >&2
  exit 1
fi

cp "${codex_root}/AGENTS.md" "${repo_root}/AGENTS.md"
python3 "${script_dir}/export-portable-config.py" \
  "${codex_root}/config.toml" \
  "${repo_root}/config.portable.toml"
rsync -a --delete --exclude='.system/' \
  "${codex_root}/skills/" \
  "${repo_root}/skills/"

printf 'Local repository snapshot updated. Review with: git diff\n'

if [ "${1:-}" = "--push" ]; then
  cd "${repo_root}"
  git add AGENTS.md config.portable.toml skills
  if git diff --cached --quiet; then
    printf 'No changes to push.\n'
    exit 0
  fi
  git commit -m "Sync Codex home $(date +%Y-%m-%d)"
  git push
fi
