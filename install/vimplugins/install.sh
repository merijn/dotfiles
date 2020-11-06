FILE="${src}/install.sh"
bundle_dir="$HOME/.vim/bundle"

declare -A installed_repos
for repo_dir in $bundle_dir/*; do
    installed_repos[$repo_dir]=1
done

install_plugin ()
{
    local repo_name="$(basename $1)"
    install_repo "$bundle_dir" "$1"
    unset installed_repos[$bundle_dir/${repo_name%.git}]
}

install_plugin "git+ssh://git@github.com/trefis/coquille.git"
install_plugin "git+ssh://git@github.com/ctrlpvim/ctrlp.vim.git"
install_plugin "https://hg.stevelosh.com/gundo.vim"
install_plugin "git+ssh://git@github.com/merijn/haskellFoldIndent.git"
install_plugin "git+ssh://git@github.com/kien/rainbow_parentheses.vim.git"
install_plugin "git+ssh://git@github.com/majutsushi/tagbar.git"
install_plugin "git+ssh://git@github.com/tpope/vim-pathogen.git"
install_plugin "git+ssh://git@github.com/tpope/vim-surround.git"
install_plugin "git+ssh://git@github.com/tpope/vim-repeat.git"
install_plugin "git+ssh://git@github.com/def-lkb/vimbufsync.git"
install_plugin "git+ssh://git@github.com/godlygeek/tabular.git"
install_plugin "git+ssh://git@github.com/neovimhaskell/haskell-vim.git"
install_plugin "git+ssh://git@github.com/JKirchartz/writegooder.vim.git"
install_plugin "git+ssh://git@github.com/lervag/vimtex.git"
install_plugin "git+ssh://git@github.com:dense-analysis/ale.git"

for repo_dir in ${!installed_repos[*]}; do
    while true; do
        # Prompt user for action
        printf "Removing obsolete plugin: $repo_dir\n"
        printf "(Y)es/(n)o? [Yn?] "
        read COMMAND

        if [ -z "$COMMAND" ]; then
            COMMAND=y
        fi

        case "$COMMAND" in
            [yY])
                rm -rf -- "$repo_dir"
                break
                ;;
            [nN])
                break
                ;;
            ?)
                printf "y - delete directory and contents\n"
                printf "n - leave the directory and contents\n"
                printf "? - this help\n"
                ;;
        esac
    done
done

unset COMMAND bundle_dir install_plugin installed_repos repo_dir
