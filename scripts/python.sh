#!/bin/bash

default="/opt/homebrew/bin/python3.11"

function find_bin() {
    path="$(pwd)"
    while [[ ! -d "$path/.venv" ]] && [[ ! -f "$path/pyproject.toml" ]] && [[ "$path" != "/" ]]; do
        path="$(dirname "$path")"
        bin="$path/.venv/bin/python3"
        [[ -f "$bin" ]] && break
    done
    [[ "$path" == "/" ]] && bin="$default"

    ipython_bin="$(dirname "$bin")/ipython"
    if [[ -f "$ipython_bin" ]]; then
        [[ "$#" -eq 0 ]] && bin="$bin $ipython_bin"
        echo "$@" | is_interactive && bin="$bin $ipython_bin --no-banner"
    fi
    echo "$bin"
}

function is_interactive() {
    echo "$(cat) " | grep -Eo '^(-\S* )*' | grep -Eq '\-[^ -]*i\S*'
}

exec $(find_bin "$@") "$@"
