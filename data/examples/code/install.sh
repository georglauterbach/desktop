#! /usr/bin/env bash

# cSpell: ignore vsextensions vspackage

set -eE -u -o pipefail
shopt -s inherit_errexit

function log() {
  declare -r level=${1:?log level required}
  declare -r message=${2:?log message required}
  printf "%s \033[1m%5s\033[0m %s\n" "$(date --iso-8601=s)" "${level^^}" "${message}"
}

if [[ ${EUID} -ne 0 ]]; then
  log error 'This script must be run as root'
  exit 1
fi

log info 'Downloading GPG signing key'
curl -sSfL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
  | gpg --dearmor \
  | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

log info 'Adding PPA source'
cat >/etc/apt/sources.list.d/vscodium.sources <<'EOF'
Types: deb
URIs: https://download.vscodium.com/debs
Suites: vscodium
Components: main
Architectures: amd64
Signed-by: /usr/share/keyrings/vscodium-archive-keyring.gpg
EOF

log info 'Installing codium'
apt-get --quiet=2 update
apt-get --quiet=2 install codium
