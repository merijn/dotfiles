FILE="sync_history/install.sh"

install_repo "install/sync_history" "git+https://github.com/merijn/sync_history"

printf "Building sync_history.\n" 1>&2
make -C $src/sync_history >/dev/null 2>&1
printf "Installing sync_history.\n" 1>&2
./dotfiles/bin/sync_history shutdown
mv install/sync_history/sync_history/sync_history dotfiles/bin/
