#!/usr/bin/env bash
set -euo pipefail

FILE="${1:?Usage: $0 <pakku-lock.json>}"

mapfile -t MCVERS < <(jq -r '[.mc_versions[]?, .projects[].files[].mc_versions[]?] | unique | .[]' "$FILE" | awk '{ print length, $0 }' | sort -rn | cut -d' ' -f2-)

extract_version() {
  local file="$1"
  local v="${file%.jar}"

  # Remove common loaders and build tags
  v=$(echo "$v" | sed -E 's/[-_]?(neoforge|forge|fabric|quilt|community|bundled|all)//gI')

  # Strip exact Minecraft versions found in the JSON
  for mcver in "${MCVERS[@]}"; do
    local esc
    esc=$(echo "$mcver" | sed 's/\./\\./g')
    v=$(echo "$v" | sed -E "s/[-_+]+mc\.?${esc}//gI; s/[-_+]+${esc}//gI")
  done

  local ver
  ver=$(echo "$v" | grep -oE '[vV]?[0-9]+\.[0-9]+.*$' || true)

  if [ -z "$ver" ]; then
    ver=$(echo "$v" | awk -F'-' '{print $NF}')
  fi

  ver=$(echo "$ver" | sed -E 's/^[-_+]+//')
  echo "$ver"
}

{
  echo "| Mod Name | Version |"
  echo "|---|---|"
  jq -r '.projects[] | [(.name.modrinth // .name.github // "Unknown"), .files[0].file_name] | @tsv' "$FILE" \
    | while IFS=$'\t' read -r name file; do
        printf "| %s | %s |\n" "$name" "$(extract_version "$file")"
      done
}
