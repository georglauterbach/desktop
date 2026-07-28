#! /usr/bin/env bash

# This script displays a table to visualize your
# terminal colors and how they interact with each other.
#
# ref: https://github.com/pablopunk/colortest
#      https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html

printf '\n                  '
printf '%sm     ' {40..47}
printf '\n       ┌'
printf '─%0.s' {0..71}
printf '┐\n'

for FG in '' {30..37}; do
  for VARIANT in "${FG}m" "1;${FG}m"; do
    printf " %5s │\033[%s  gYw  " "${VARIANT}" "${VARIANT}"
    for BG in {40..47}; do
      printf " \033[%s\033[%sm  gYw  \033[0m" "${VARIANT}" "${BG}"
    done
    printf ' │\n'
  done
done

printf '       └'
printf '─%0.s' {0..71}
printf '┘\n\n'
