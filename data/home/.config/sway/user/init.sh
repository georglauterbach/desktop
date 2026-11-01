#! /usr/bin/env bash

systemd_start_user_service wlsunset

ssh-add "${HOME}/.ssh/keys/github" &>/dev/null
ssh-add "${HOME}/.ssh/keys/gitlab" &>/dev/null
ssh-add "${HOME}/.ssh/keys/power" &>/dev/null
ssh-add "${HOME}/.ssh/keys/tower" &>/dev/null
