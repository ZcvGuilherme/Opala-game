#!/bin/sh
echo -ne '\033c\033]0;Jogo Parkour\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Lab Escape.x86_64" "$@"
