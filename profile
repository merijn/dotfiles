EDITOR=vim
PAGER=less
LESSHISTFILE=-
GREP_OPTIONS="--colour=auto"
PATH=$HOME/opt/bin:$HOME/.bin:$PATH
PROMPT_COMMAND="history -n; history -a"
TMUX_COMMAND="bash"
export EDITOR PAGER LESSHISTFILE GREP_COLOR PATH PROMPTCOMMAND TMUX_COMMAND

# Read local overrides, if any. (i.e. for PATH, MANPATH, SNET_*, etc.)
[ -f ~/.profile_local ] && . ~/.profile_local

if [ "$(uname)" = "Darwin" ]; then
    TMUX_COMMAND="reattach-to-user-namespace bash"
    PATH=/opt/local/bin:/opt/local/sbin:$PATH
    MANPATH=/opt/local/share/man:$MANPATH
    LC_ALL=en_US.UTF-8
    LANG=en_US.UTF-8

    export MANPATH LC_ALL LANG
fi

. ~/.bashrc

# Exit if the shell is non-interactive
[ -z "$PS1" ] && return 0

case $TERM in
    cons*)
        if [ `id -u` -ne 0 ]; then
            [ $(which startx | wc -l) -eq 1 ] && startx && exit
        else
            if [ $(which tmux | wc -l) -eq 1\
                  -o $(which screen | wc -l) -eq 1 ]; then

                printf "Start tmux/screen? (y/n) "
                read ESCAPE

                [ "$ESCAPE" = "n" ] && return 0
            fi
        fi

        ESCAPE=^Dd
        ;;

    screen*)
        while true; do
            printf "%s\n"\
            "Running a new screen/tmux inside a screen/tmux session. Enter "\
            "an escape sequence for the new session (format: ^Dd) or \"None\""\
            "to stop starting screen: "

            read ESCAPE

            if [ -z "$ESCAPE" ]; then
                ESCAPE=^Dd
                break
            fi

            case $ESCAPE in
                ^[A-Z][a-z])
                    if [ "${ESCAPE:1:1}" = $(echo "${ESCAPE:2:1}" | tr '[a-z]' '[A-Z]') ]; then
                        break
                    fi
                    ;;
                [Nn][Oo][Nn][Ee])
                    return 0
                    ;;
            esac
        done
        ;;

    xterm*)
        ESCAPE=^Dd
        ;;
esac

export ESCAPE

if [ $(which tmux | wc -l) -eq 1 ]; then
    ESCAPE=`expr $ESCAPE : "\(..\)"`
    tmux attach && exit || tmux new bash && exit
elif [ $(which screen | wc -l) -eq 1 ]; then
    if [ $(screen -ls | grep "\(No Sockets found in\)" | wc -l) -eq 1 ]; then
        screen -e $ESCAPE && exit
    else
        screen -DRR && exit
    fi
fi
