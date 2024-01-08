#!/bin/bash

config='''
[[ -r /etc/profile ]] && source /etc/profile
[[ -r ~/.bashrc ]] && source ~/.bashrc
'''"""
$(cat $(dirname $0)/../shell/bashrc)
export VIMINIT=$(printf "%q" "$(cat $(dirname $0)/../shell/vimrc | grep -v '^"')")
$(cat $(dirname $0)/custom.sh 2>/dev/null)
"""

echo \
'''Host *
Match exec "[[ $(ps -o args= $PPID | wc -w) -eq 2 ]] || [[ $(ps -o args= $PPID | grep \ -l\  | wc -w) -eq 4 ]]"
    RemoteCommand if [[ "$SHELL" == *bash ]]; then exec $SHELL --rcfile <(echo "'$(echo "$config" | base64)'" | base64 --decode); else exec $SHELL --login; fi
    RequestTTY force''' > "$(dirname $0)/../ssh"

echo "put the following line in ~/.ssh/config"
echo "Include ~/.config/ssh"
