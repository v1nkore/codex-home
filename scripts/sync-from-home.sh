#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 0 ]; then
  printf 'Usage: %s\nReview the changes, then commit and push them manually.\n' "$0" >&2
  exit 2
fi

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
repo_root="$(dirname -- "${script_dir}")"
codex_root="${CODEX_HOME:-${HOME}/.codex}"

if [ ! -f "${codex_root}/config.toml" ] || [ ! -d "${codex_root}/skills" ]; then
  printf 'Expected config.toml and skills/ under %s\n' "${codex_root}" >&2
  exit 1
fi

if [ -n "$(git -C "${repo_root}" status --porcelain -- config.portable.toml skills)" ]; then
  printf 'Review or commit existing changes to config.portable.toml and skills/ before syncing.\n' >&2
  exit 1
fi

python3 "${script_dir}/export-portable-config.py" \
  "${codex_root}/config.toml" \
  "${repo_root}/config.portable.toml"
rsync -a --delete --exclude='.system/' \
  "${codex_root}/skills/" \
  "${repo_root}/skills/"

printf 'Local snapshot updated. Review config.portable.toml, new skills, and git diff before committing.\n'
