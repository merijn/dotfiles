# Settings for all shells
# Set various aliases and functions
alias grep='grep -I'
alias hig='history | grep -i'
alias ls='ls -FG'       # ls always shows colour and type (dir, link, etc)
alias la='ls -aFG'      # Like above but shows dotfiles/-directories
alias ll='ls -lhoAFG'   # Show file flags in long mode with human readable size
alias lg='ls -lhoAFG | grep -i' # Case insensitive grep on ls
alias ulimit='ulimit -S'
alias more='less'

# If this is a non-login shell .bashrc is sourced without .profile, source
# .profile anyway to make sure PATH is set up properly. Recursive source is
# prevented by checking the existence of the XYZZY variable defined below.
if ! shopt -q login_shell && [ -z "$PS1" ]; then
    XYZZY="xyzzy"
    . ~/.profile
fi

if [ ! -z "$BASH_VERSION" -a ! -z "$PS1" ]; then
    TITLEBAR="\[\e]0;\u@\h:\w\007\]" # Sets titlebar of xterm/PuTTy to \u@\h:\w
    CAPTION="\[\e]0;\w\007\]"        # Sets screen status bar to CWD
    JOBS="\[\e[0;36m\]"              # Bright cyan, no. of background jobs
    TIME="\[\e[1;37m\]"              # Bright white, clock colours
    CWD="\[\e[1;34m\]"               # Pale blue, top directory
    CLEAR="\[\e[0m\]"                # Clear colour changes

    if [ $UID -eq 0 ]; then
        USERCOLOR="\[\e[0;31m\]"     # Red if running as root
    else
        USERCOLOR="\[\e[0;32m\]"     # Green otherwise
    fi

    # Default prompt (for TMUX)
    PS1="$USERCOLOR\u $CWD\W $JOBS\j$CLEAR\$ "

    if [[ $TERM =~ cons* ]]; then
        # Prompt when running on console
        PS1="$TIME\$(date "+%H:%M") $PS1"
    elif [[ $STY ]]; then
        # Add caption to set the CWD in screen's statusbar
        PS1="$CAPTION$PS1"
    elif [[ $TERM =~ screen* && ! $TMUX ]]; then
        # Prompt when running in a remote screen
        PS1="$USERCOLOR\u@\h $CWD\W $JOBS\j$CLEAR\$ "
    elif [[ ! $TMUX ]]; then
        # Set terminal titlebar to user@host:path for all other terminals
        PS1="$TITLEBAR$TIME\$(date "+%H:%M") $PS1"
    fi

    # Set various shell options
    shopt -s no_empty_cmd_completion
    shopt -s nocaseglob   # * matches case insensitively
    shopt -s histappend   # Append to .bash_history instead of overwriting
    shopt -s histreedit   # Edit line on failed history substitution
    shopt -s cmdhist      # Multi-line command are stored multi-line in history
    shopt -s lithist      # Store multi-line history entries with s/;/\n
    shopt -s checkwinsize # Check terminal size after each command
    set -o vi             # Set vi keybindings.

    # Commands (colon separated) not added to the history
    HISTIGNORE="fortune*" # Stop me from wasting time on fortune!
    HISTCONTROL=ignorespace:erasedups
    HISTFILESIZE=50000  # Keep 50000 lines of history

    # Set OS specific aliases and settings or overwrites
    if [ "$(uname)" = "Darwin" ]; then
        if [ -f ~/.hg-bash_completion ]; then
            . ~/.hg-bash_completion
        fi
    elif [ "$(uname)" = "FreeBSD" ]; then
        alias rm='rm -rI' # (Recursively) delete and ask confirmation for >3 files
        if [ -f /usr/local/etc/bash_completion ]; then
            . /usr/local/etc/bash_completion
        fi

        if [ -f /usr/local/share/mercurial/contrib/bash_completion ]; then
            . /usr/local/share/mercurial/contrib/bash_completion
        fi
    elif [ "$(uname)" = "Linux" ]; then
        alias ls='ls -F --color=auto'
        alias la='ls -aF --color=auto'
        alias ll='ls -lhoAF --color=auto'
        alias lg='ls -lhoAF --color=auto | grep -i'
    fi
fi

st () {
    if [ $TMUX ]; then
        tmux renamew $*
    else
        echo -ne "\033k$*\033\\"
    fi
}

mq () {
    local queue=$(hg qqueue --active)
    if [ "$queue" = "patches" ]; then
        hg -R $(hg root)/.hg/patches $*
    else
        hg -R $(hg root)/.hg/patches-$queue $*
    fi
}
