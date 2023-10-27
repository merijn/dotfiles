#!/usr/bin/env bash
notify_dir="/Library/Application Support/Dotfiles"

if ! { [[ -f /usr/local/bin/brew ]] || [[ -f /opt/homebrew/bin/brew ]] ;}; then
    printf "HomeBrew not found, skipping update script install.\n" 1>&2
    return 0
fi

# Ensure the application directories exists
if ! [[ -d "$notify_dir" ]]; then
    sudo -p "Enter password to create $notify_dir:" mkdir "$notify_dir"
    sudo chown "$UID" "$notify_dir"
    chmod 700 "$notify_dir"
    mkdir -p "$notify_dir/notifications"
fi

# Copy over the relevant shell scripts
if install_config "$PWD/install-osx/homebrew/homebrew-update" \
                "$notify_dir/homebrew-update"
then
    # If growlnotify is present, install the notification job and load it into
    # launchd.
    if command -v growlnotify >/dev/null 2>&1; then
        # If a job is loaded AND a new plist was installed, unload the old job
        # before loading the new one.
        if sudo_install_config \
                "$PWD/install-osx/homebrew/com.dotfiles.homebrew.plist" \
                "/Library/LaunchDaemons/com.dotfiles.homebrew.plist" \
            && sudo_list_loaded com.dotfiles.homebrew
        then
            sudo launchctl remove com.dotfiles.homebrew
        fi

        # If no plist is loaded, load the new plist.
        if ! sudo_list_loaded com.dotfiles.homebrew 2>/dev/null; then
            sudo launchctl load /Library/LaunchDaemons/com.dotfiles.homebrew.plist
        fi
    else
        printf "growlnotify not found. Auto-updating not enabled.\n" 1>&2
    fi
fi
