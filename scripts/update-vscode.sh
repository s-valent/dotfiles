#!/bin/bash

set -eo pipefail
cd $(dirname $0)

sync_file="$(dirname $0)/vscode/settings.json"
local_file="$HOME/Library/Application Support/Code/User/settings.json"
result=$(jq -s '.[0] * .[1]' <(cat "$local_file" | grep -v "//.*") <(cat "$sync_file" | grep -v "//.*"))
echo "$result" > "$local_file"

sync_file="$(dirname $0)/vscode/keybindings.json"
local_file="$HOME/Library/Application Support/Code/User/keybindings.json"
cp "$sync_file" "$remote_file"
