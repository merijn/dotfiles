FILE="sync_history/install.sh"

printf "Checking for updates.\n"

install_repo "install/sync_history" "git+ssh://git@github.com/merijn/sync_history"

printf "Building sync_history.\n"
make -C $src/sync_history >/dev/null

printf "Installing sync_history.\n"
if [ -f dotfiles/bin/sync_history ]; then
    ./dotfiles/bin/sync_history shutdown
fi
mv install/sync_history/sync_history/sync_history dotfiles/bin/
