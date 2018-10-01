FILE="macos-keyboard/install.sh"

if [ "$(uname)" != "Darwin" ]; then
    # Don't try to install on non-OSX
    return 0
fi

symlink_config "${src}/latex.cin" "${HOME}/Library/Input Methods/latex.cin"
