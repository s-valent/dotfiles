#!/bin/bash

filename="$(dirname $0)/../ssh"

config='''
[[ -r /etc/profile ]] && source /etc/profile
[[ -r ~/.bashrc ]] && source ~/.bashrc
'''"""
$(cat $(dirname $0)/../shell/bashrc)
export VIMINIT=$(printf "%q" "$(cat $(dirname $0)/../shell/vimrc | grep -v '^"')")
$(cat $(dirname $0)/custom.sh 2>/dev/null)
"""

ssh_flag="[$(man ssh | col -b | grep -o '\[-[^]]*\]' | sed -E 's/\[-([^] ]+).*/\1/' | grep -v '^.$' | tr -d '\n')]"
ssh_argument="[$(man ssh | col -b | grep -o '\[-[^]]*\]' | sed -E 's/\[-([^] ]+).*/\1/' | grep '^.$' | tr -d '\n')]\s*\S*"
ssh_command_regex="^(\S*/)?ssh (-$ssh_flag*($ssh_argument|$ssh_flag) )*\S+( -$ssh_flag*($ssh_argument|$ssh_flag))*$"
echo \
'''Host *
Match exec "ps -o args= $PPID | grep -E '\'$ssh_command_regex\''"
    RemoteCommand [[ $SHELL == *bash ]] && exec $SHELL --rcfile <(echo "'$(echo "$config" | base64 -w 0)'" | base64 --decode) || exec $SHELL --login
    RequestTTY force''' > "$filename" && chmod 600 "$filename"

echo "put the following line in ~/.ssh/config"
echo "Include $filename"
