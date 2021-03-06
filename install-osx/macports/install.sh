FILE="${src}/install.sh"

notify_dir="/Library/Application Support/Dotfiles"

if ! [ -f /opt/local/bin/port ]; then
    printf "MacPorts not found, skipping update script install.\n" 1>&2
    return 0
fi

# Ensure the application directories exists
if ! [ -d "$notify_dir" ]; then
    sudo -p "Enter password to create $notify_dir:" mkdir "$notify_dir"
    sudo chown $UID "$notify_dir"
    chmod 700 "$notify_dir"
    mkdir -p "$notify_dir/notifications"
fi

# Copy over the relevant shell scripts
install_config "$src/macports-update" "$notify_dir/macports-update"

# If growlnotify is present, install the notification job and load it into
# launchd.
if hash growlnotify 2>/dev/null; then
    sudo_install_config "$src/com.dotfiles.macports.plist" \
                        "/Library/LaunchDaemons/com.dotfiles.macports.plist"

    # If a job is loaded AND a new plist was installed, unload the old job
    # before loading the new one.
    if [ $updated -eq 1 ] && list_loaded com.dotfiles.macports; then
        sudo launchctl remove com.dotfiles.macports
    fi

    # If no plist is loaded, load the new plist.
    if ! sudo_list_loaded com.dotfiles.macports 2>/dev/null; then
        sudo launchctl load /Library/LaunchDaemons/com.dotfiles.macports.plist
    fi
else
    printf "MacPorts not found. Auto-updating not enabled.\n" 1>&2
fi
