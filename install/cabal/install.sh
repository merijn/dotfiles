#!/usr/bin/env bash
if ! hash cabal 2>/dev/null; then
    printf "cabal not found, skipping Haskell config install.\n" 1>&2
    return 0
fi

if [[ ! -d "${HOME}/.cabal" ]]; then
    if ! cabal; then
        printf "%s\n"\
               "cabal failed and ${HOME}/.cabal is non-existent, skipping "\
               "Haskell config install." 1>&2
        return 0
    fi
fi

symlink_config "$PWD/install/cabal/config" "${HOME}/.cabal/config"
