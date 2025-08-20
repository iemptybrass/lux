#!/usr/bin/env bash
set -euo pipefail
set -f

uri='[[[:space:]]?((\.?)(\/[[:alnum:]_-]+)+(\.[in]{2}[xp][ut]{0,2})?)([][:space:]]|$)'

queue=(./flake.nix)

count=0
while (( count < ${#queue[@]} )); do
  input=${queue[count]}

  while IFS= read -r line; do
    line=${line%%#*}
    if [[ $line =~ $uri ]]; then
      prefix="${BASH_REMATCH[2]}"
      path="${BASH_REMATCH[3]}"
      suffix="${BASH_REMATCH[4]}"


      if [[ $input == */default.nix ]]; then
        prefix=${input%/default.nix}
      fi

      if [[ -z $suffix ]]; then
        suffix="/default.nix"
      fi

      queue+=("${prefix}${path}${suffix}")
      echo "${prefix}${path}${suffix}"
    fi
  done < "$input"

  ((++count))
done