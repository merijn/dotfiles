#!/usr/bin/env bash
if install_config "$PWD/install-osx/latex-input/latex.cin" \
        "${HOME}/Library/Input Methods/latex.cin"
then
    printf "Installed macOS LaTeX input method.\n"
fi
