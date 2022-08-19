#!/usr/bin/env bash
notify_dir="/Library/Application Support/Dotfiles"

# Ensure the application directories exists
if ! [[ -d "$notify_dir" ]]; then
    sudo -p "Enter password to create $notify_dir:" mkdir "$notify_dir"
    sudo chown "$UID" "$notify_dir"
    chmod 700 "$notify_dir"
    mkdir -p "$notify_dir/notifications"
fi

# Copy over the relevant shell scripts
if install_config "$PWD/install-osx/notify/notify" "$notify_dir/notify"
then
    printf "Installed notify script!\n"
fi

# If growlnotify is present, install the notification job and load it into
# launchd.
if hash growlnotify 2>/dev/null; then
    # If a job is loaded AND a new plist was installed, unload the old job
    # before loading the new one.
    if install_config "$PWD/install-osx/notify/com.dotfiles.notify.plist" \
                   "$HOME/Library/LaunchAgents/com.dotfiles.notify.plist" \
        && list_loaded com.dotfiles.notify
    then
        launchctl remove com.dotfiles.notify
    fi

    # If no plist is loaded, load the new plist.
    if ! list_loaded com.dotfiles.notify 2>/dev/null; then
        launchctl load "$HOME/Library/LaunchAgents/com.dotfiles.notify.plist"
    fi
else
    printf "Growlnotify not found. Launchd notifications not enabled.\n" 1>&2
fi
