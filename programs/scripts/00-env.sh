#! /usr/bin/env bash

function log_info() {
  echo -e " \e[1;34m INFO\e[0;1m ${*}\e[0m"
}

function log_warn() {
  echo -e " \e[1;33m WARN\e[0;1m ${*}\e[0m" 2>&2
}

function log_error() {
  echo -e " \e[1;31mERROR\e[0;1m ${*}\033[0m" 2>&2
}

function declare_variable() {
  local -n VAR_NAME=${1:?TODO}
  local VAR_VALUE=${2:?TODO}

  # shellcheck disable=SC2034,SC2163
  [[ -v ${1} ]] || { readonly VAR_NAME=${VAR_VALUE} ; export "${1}" ; }
}

function require_command() {
  local COMMAND=${1:?TODO}
  if ! command -v "${COMMAND}" &>/dev/null; then
    log_error "The command '${COMMAND}' could not be found" >&2
    exit 1
  fi
}

function require_run_as_root() {
  if [[ ${EUID} -ne 0 ]]; then
    log_error 'This script MUST run with superuser privileges' >&2
    exit 1
  fi
}

function require_run_as_user() {
  if [[ ${EUID} -eq 0 ]]; then
    log_error 'This script MUST NOT run with superuser privileges' >&2
    exit 1
  fi
}

if [[ ! -v SCRIPT_DIR ]]; then
  log_error 'The environment variable 'SCRIPT_DIR' is required' >&2
  exit 1
fi

BASE_DIR=$(realpath -eL "${SCRIPT_DIR}/..")
readonly SCRIPT_DIR BASE_DIR

declare_variable IMAGE_TAG localhost/desktop-builder:latest
declare_variable APT_DIR   "${BASE_DIR}/.apt"
declare_variable CACHE_DIR "${BASE_DIR}/.cache"
declare_variable OUT_DIR   "${BASE_DIR}/.out"
declare_variable SRC_DIR   "${BASE_DIR}/.src"

cd "${BASE_DIR}" || exit 1

trap '__RET=${?} ; if [[ ${__RET} -eq 0 ]]; then log_info Finished; else log_error "Finished (${__RET})"; fi' EXIT
