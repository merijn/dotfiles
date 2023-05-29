#!/usr/bin/env bash
if [[ -z "${SSH_AUTH_SOCK-}" ]]; then
    ssh_script="$(ssh-agent -s)"
    eval "${ssh_script}"
    # shellcheck disable=SC2154
    trap 'kill $SSH_AGENT_PID' ERR EXIT
    ssh-add
fi
