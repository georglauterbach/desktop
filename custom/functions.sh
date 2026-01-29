#! /bin/sh

set -e -u

readonly INSTALLATION_PREFIX='/usr/local'

# -----------------------------------------------
# ----  Functions  ------------------------------
# -----------------------------------------------

log_important() {
  printf "\033[1m%s\033[0m\n" "${*}"
}

prepare_sources() {
  GIT_URI=${1:?URI for cloning is required}
  GIT_REV=${2:?git revision is required}
  shift 2

  DIR_NAME=$(echo "${GIT_URI}" | sed -E 's|.*/(.*)\.git$|\1|')
  log_important "Preparing ${DIR_NAME} (${GIT_REV})"
  git clone --quiet --depth 1 --branch "${GIT_REV}" "${GIT_URI}"
}

apt_install() {
  sudo apt-get install --quiet --yes --no-install-recommends "${@}"
}

build() {
  log_important "Building '${1:?Directory to build in is required}'"
  (
    cd "${1}" || exit 1
    shift 1
    "${@}"
  )
}

meson_ninja() {
  # cSpell: ignore warnlevel
  meson setup build     \
    --reconfigure       \
    --backend=ninja     \
    --buildtype=release \
    --warnlevel=0   \
    --prefix="${INSTALLATION_PREFIX}" "${@}"
  ninja -C build install
}

setup_rust() {
  log_important 'Setting up Rust'
  export CARGO_HOME='/src/rust/cargo/home' RUSTUP_HOME='/src/rust/rustup/home'
  readonly CARGO_HOME RUSTUP_HOME
  # shellcheck source=/dev/null
  . "${HOME}/.cargo/env"
  rustup --quiet default 1.92.0
}

finalize_runtime_libs() {
  for PROGRAM in "${INSTALLATION_PREFIX}/bin/"*; do
    file "${PROGRAM}" | grep --quiet 'dynamically linked' || continue
    strip --strip-all "${PROGRAM}"


    ldd "${PROGRAM}" | grep ' /lib' | while read -r _ _ FILE _; do
      [ -e "${INSTALLATION_PREFIX}${FILE}" ] && continue
      case "${FILE}" in
        ( *libc*.so* | *libstdc\+\+*.so* ) continue ;;
        ( * ) : ;;
      esac

      echo "Copying '${FILE}' to '${INSTALLATION_PREFIX}${FILE}'"
      mkdir --parents "${INSTALLATION_PREFIX}/$(dirname "${FILE}")"
      cp "${FILE}" "${INSTALLATION_PREFIX}${FILE}"

      if [ -L "${FILE}" ]; then
        LINK_TARGET=$(realpath --canonicalize-existing --logical "${FILE}")
        [ -e "${INSTALLATION_PREFIX}/${LINK_TARGET}" ] && continue
        echo "Copying symbolic link target '${LINK_TARGET}' of '${FILE}'"
        cp "${LINK_TARGET}" "${INSTALLATION_PREFIX}/${LINK_TARGET#/usr}"
      fi
    done
  done
}

[ ${#} -eq 0 ] || "${@}"
