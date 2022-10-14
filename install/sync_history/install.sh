#!/usr/bin/env bash
install_repo "install/sync_history" "git+ssh://git@github.com/merijn/sync_history"

printf "Building sync_history.\n"
make -C install/sync_history/sync_history >/dev/null

printf "Installing sync_history.\n"
if [[ -f dotfiles/bin/sync_history ]]; then
    ./dotfiles/bin/sync_history shutdown
fi
mv install/sync_history/sync_history/sync_history dotfiles/bin/

if [[ "${BASH_VERSINFO[0]:-0}" -lt 4 ]] \
|| { [[ "${BASH_VERSINFO[0]:-0}" -eq 4 ]] && [[ "${BASH_VERSINFO[1]}" -lt 4 ]] ;}
then
    printf "Bash %s doesn't support multi-line history from file.\n" \
        "$BASH_VERSION"
    printf "Update to Bash >= 4.4\n"
elif [[ -f ~/.bash_history ]] && type sync_history >/dev/null 2>&1; then
    hist_path="$(sync_history history-path)"
    # shellcheck disable=SC2312
    if ! head -n1 ~/.bash_history | grep -q '^#[0-9]*$' >/dev/null 2>&1; then
        # shellcheck disable=SC2088
        printf "~/.bash_history is not in multi-line format! "
        printf "Unable to migrate to %s\n" "$hist_path"
    elif [[ -f "$hist_path" ]]; then
        printf "%s already exists, not migrating ~/.bash_history\n" "$hist_path"
    else
        printf "Migrating ~/.bash_history to %s\n" "$hist_path"
        mv ~/.bash_history "$hist_path"
    fi
fi

