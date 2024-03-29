#!/usr/bin/env bash
os_name="$(uname)"
if [[ "$os_name" != "Darwin" ]]; then
    printf "Tarsnap configuration is currently only set up for OSX.\n" 1>&2
    # Don't try to install on non-OSX
    return 0
elif ! hash tarsnap 2>/dev/null; then
    printf "Tarsnap not found!\n" 1>&2
    return 0
fi

tarsnap_dir="/Library/Application Support/Tarsnap"

# Ensure the application directories exists
if ! [[ -d "$tarsnap_dir" ]]; then
    sudo -p "Enter password to create $tarsnap_dir:" mkdir "$tarsnap_dir"
    sudo chown "$UID" "$tarsnap_dir"
    chmod 700 "$tarsnap_dir"
fi

# shellcheck disable=SC2174
mkdir -m 755 -p "$tarsnap_dir/etc/"
# shellcheck disable=SC2174
mkdir -m 755 -p "$tarsnap_dir/errors/"

# Copy over the relevant shell scripts and config file
install_config "$PWD/install/tarsnap/backup" "$tarsnap_dir/backup"
install_config "$PWD/install/tarsnap/tarsnap.conf" "$tarsnap_dir/etc/tarsnap.conf"

# If the tarsnap binary is installed, install the scheduled backup job and load
# it into launchd.
tarsnap_exe="$tarsnap_dir/bin/tarsnap"
if [[ -f "$tarsnap_exe" ]] && [[ -x "$tarsnap_exe" ]]; then
    # If a job is loaded AND a new plist was installed, unload the old job
    # before loading the new one.
    if sudo_install_config "$PWD/install/tarsnap/com.tarsnap.backup.plist" \
                            "/Library/LaunchDaemons/com.tarsnap.backup.plist" \
        && sudo_list_loaded com.tarsnap.backup
    then
        sudo launchctl remove com.tarsnap.backup
    fi

    # If no plist is loaded, load it.
    if ! sudo_list_loaded com.tarsnap.backup; then
        sudo launchctl load /Library/LaunchDaemons/com.tarsnap.backup.plist
    fi
else
    printf "Tarsnap binary not found or not executable!\n%s\n%s\n" \
           "Install Tarsnap in prefix: $tarsnap_dir" \
           "Backup job not enabled." 1>&2
fi
