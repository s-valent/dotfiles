# Source env file
if test -f ~/.config/shell/env
    source ~/.config/shell/env
end

# Environment variables
set -gx EDITOR nvim
set -gx LSCOLORS ExGxBxDxCxEgEdxbxgxcxd
set -gx WORDCHARS '*?-.[]~=/&;!#$%^(){}<>'
set -gx BAT_THEME 'base16'
set -gx LESS "-XRFS"

# History (fish handles this differently)
set -gx HISTFILE ~/.local/share/fish/fish_history
set -gx HISTSIZE 1000000

# macOS specific
if test (uname) = Darwin
    set -gx PATH /opt/homebrew/bin $PATH
    alias sed gsed
end

# Aliases
which pbcopy > /dev/null 2>&1; or alias pbcopy 'printf "\e]52;c;"(openssl base64 -A)"\a"'
alias brew-up 'brew update && brew upgrade; brew cleanup --prune=all'
alias clear 'printf '\''\33c\e[3J\e[1 q'\'''
alias pip 'python -m pip'
alias mkdir 'mkdir -pv'
alias grep 'grep --color=auto'
alias ls 'ls -h --color=auto'
alias la 'ls -hA --color=auto'
alias ll 'ls -hla --color=auto'
alias cp 'cp -i'
alias ln 'ln -i'
alias mv 'mv -i'
alias c clear
alias v nvim

alias docker-kill 'docker ps -aq | xargs -I{} docker stop {} && docker network prune -f'
alias docker-prune 'docker system prune -af'
alias dc 'docker compose'
alias db 'nvim +":DBUI"'

# Functions
function caffeinate-hours
    caffeinate -t (math 60 \* 60 \* $argv[1]) -d &
end

function code-reload
    if test -z "$SSH_CLIENT"
        lsof | grep "Code Helper" | cut -d" " -f2 | xargs -r kill
    else
        pgrep -f vscode-server | xargs -r kill
    end
end

function cursor-reload
    if test -z "$SSH_CLIENT"
        lsof | grep "Cursor Helper" | cut -d" " -f2 | xargs -r kill
    else
        pgrep -f cursor-server | xargs -r kill
    end
end

function app-id
    osascript -e 'id of app "'"$argv[1]"'"'
end

function cdf
    set -l dest (osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)' 2> /dev/null)
    test "$dest" != "/" -a -n "$dest"; and cd "$dest"
end

function ql
    qlmanage -p "$argv[1]" > /dev/null 2>&1
end

function curl
    if echo "$argv" | grep -iq '\bcontent-type\b'
        /usr/bin/curl $argv
    else
        /usr/bin/curl -H 'Content-type: application/json' $argv
    end
end

function rs
    rg -l $argv | while read -l file
        rg $argv --passthru "$file" | sponge "$file"
    end
end

set -g fish_greeting ""

function fish_prompt
    set -g __last_status $status

    printf "\033]2;%s@%s: %s\007" $USER (hostname -s) (pwd)
    printf "\x1b[1 q"

    if test -n "$SSH_CLIENT"
        set_color green
        echo -n (hostname)
        set_color normal
        echo -n ":"
    end

    set_color -o brblack
    echo -n (prompt_pwd)
    set_color white
    echo -n " → "
    set_color normal
end

function fish_right_prompt
    if test -n "$CMD_DURATION"
        if test "$CMD_DURATION" -gt 1000 -o "$__last_status" -ne 0
            set -l total_seconds (math "floor($CMD_DURATION / 1000)")
            set -l minutes (math "floor($total_seconds / 60)")
            set -l secs (math "$total_seconds % 60")

            if test "$__last_status" -eq 0
                set_color green
            else
                set_color red
            end

            if test $minutes -gt 0
                printf "%dm%ds" $minutes $secs
            else
                printf "%ds" $secs
            end

            set_color normal
        end
    end
end



function edit-command
    set -l tmpfile (mktemp)
    commandline > $tmpfile
    $EDITOR $tmpfile
    commandline (cat $tmpfile)
    rm -f $tmpfile
end
bind \e\[C edit-command 2>/dev/null; or bind \e\[C edit-command
bind \ce edit-command
