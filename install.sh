#!/usr/bin/env bash
set -euo pipefail
umask 077

if [ "$#" -ne 0 ]; then
  printf 'Usage: %s\n' "$0" >&2
  exit 2
fi

repo_root="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
codex_root="${CODEX_HOME:-${HOME}/.codex}"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_root="${codex_root}/backups/codex-home-${timestamp}-$$"

mkdir -p "${codex_root}" "${codex_root}/skills"

backup_file() {
  source_path="$1"
  relative_path="$2"
  if [ -e "${source_path}" ]; then
    mkdir -p "${backup_root}/$(dirname -- "${relative_path}")"
    cp -R "${source_path}" "${backup_root}/${relative_path}"
  fi
}

backup_file "${codex_root}/AGENTS.md" "AGENTS.md"
backup_file "${codex_root}/config.toml" "config.toml"

install -m 0644 "${repo_root}/AGENTS.md" "${codex_root}/AGENTS.md"
install -m 0600 "${repo_root}/config.portable.toml" "${codex_root}/config.toml"

for skill_path in "${repo_root}"/skills/*; do
  [ -d "${skill_path}" ] || continue
  skill_name="$(basename -- "${skill_path}")"
  destination="${codex_root}/skills/${skill_name}"

  if [ -d "${destination}" ] && diff -qr "${skill_path}" "${destination}" >/dev/null 2>&1; then
    continue
  fi

  if [ -e "${destination}" ]; then
    mkdir -p "${backup_root}/skills"
    mv "${destination}" "${backup_root}/skills/${skill_name}"
  fi
  cp -R "${skill_path}" "${destination}"
done

printf 'Codex settings restored to %s\n' "${codex_root}"
if [ -d "${backup_root}" ]; then
  printf 'Previous files backed up to %s\n' "${backup_root}"
fi
printf 'Restart Codex so every restored skill and setting is rediscovered.\n'
