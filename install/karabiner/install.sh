if [ "$(uname)" != "Darwin" ]; then
    # Don't try to install on non-OSX
    return 0
fi

karabiner_dir="${HOME}/Library/Application Support/Karabiner/"

if [ ! -d "${karabiner_dir}" ]; then
    printf "%s\n" "Karabiner config directory not found, skipping custom "\
           "binding installation." 1>&2
    return 0
fi

symlink_config "${src}/private.xml" "${karabiner_dir}/private.xml"
