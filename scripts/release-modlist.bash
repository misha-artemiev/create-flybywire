#!/usr/bin/env bash
set -euo pipefail

FILE="${1:?Usage: $0 <pakku-lock.json>}"

mapfile -t MCVERS < <(jq -r '.mc_versions[]' "$FILE" | awk '{ print length, $0 }' | sort -rn | cut -d' ' -f2-)

extract_version() {
  local file="$1"
  local v="${file%.jar}"

  v=$(echo "$v" | sed -E 's/[-_]?(neoforge|forge|fabric|quilt)//gI')

  for mcver in "${MCVERS[@]}"; do
    local esc
    esc=$(echo "$mcver" | sed 's/\./\\./g')
    v=$(echo "$v" | sed -E "s/[-_+]?mc\.?${esc}//gI; s/[-_+]?${esc}//g")
  done

  v=$(echo "$v" | sed -E 's/[-_+]mc[0-9]+(\.[0-9]+)*//gI')

  v=$(echo "$v" | sed -E 's/[-_+.]{2,}/-/g; s/^[-_+.]+//; s/[-_+.]+$//')

  local ver
  ver=$(echo "$v" | grep -oE '[vV]?[0-9]+(\.[0-9]+)+[a-zA-Z0-9.+-]*$' | tail -1)
  [ -z "$ver" ] && ver="$v"
  echo "$ver"
}

{
  echo "| Mod Name | Version |"
  echo "|---|---|"
  jq -r '.projects[] | [.name.modrinth, .files[0].file_name] | @tsv' "$FILE" \
    | while IFS=$'\t' read -r name file; do
        printf "| %s | %s |\n" "$name" "$(extract_version "$file")"
      done
}
