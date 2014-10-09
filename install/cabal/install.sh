if ! which cabal >/dev/null; then
    printf "cabal not found, skipping Haskell config install.\n" 1>&2
    return 0
fi

if [ ! -d "${HOME}/.cabal" ]; then
    if ! cabal; then
        printf "%s\n"\
               "cabal failed and ${HOME}/.cabal is non-existent, skipping "\
               "Haskell config install." 1>&2
        return 0
    fi
fi

install_file "${src}/config" "${HOME}/.cabal/config"
