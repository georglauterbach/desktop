#! /bin/sh

build_alacritty() {
  cargo build --release --no-default-features --features=wayland
  install -s -Dm755 target/release/alacritty -t "${INSTALLATION_PREFIX}/bin/"

  scdoc < extra/man/alacritty.1.scd          | gzip -c >"${INSTALLATION_PREFIX}/share/man/man1/alacritty.1.gz"
  scdoc < extra/man/alacritty-msg.1.scd      | gzip -c >"${INSTALLATION_PREFIX}/share/man/man1/alacritty-msg.1.gz"
  scdoc < extra/man/alacritty.5.scd          | gzip -c >"${INSTALLATION_PREFIX}/share/man/man5/alacritty.5.gz"
  scdoc < extra/man/alacritty-bindings.5.scd | gzip -c >"${INSTALLATION_PREFIX}/share/man/man5/alacritty-bindings.5.gz"
}

build_wleave() {
  cargo build --release
  install -s -Dm755 target/release/wleave -t "${INSTALLATION_PREFIX}/bin/"
  # TODO also install icons
}

build_lightctl() {
  cargo build --release
  install -s -Dm755 target/release/lightctl -t "${INSTALLATION_PREFIX}/bin/"
}

build_satty() {
  cargo build --release
  install -s -Dm755 target/release/satty -t "${INSTALLATION_PREFIX}/bin/"

  install -Dm644 assets/satty.svg "${INSTALLATION_PREFIX}/share/icons/hicolor/scalable/apps/satty.svg"
  install -Dm644 satty.desktop    "${INSTALLATION_PREFIX}/share/applications/satty.desktop"
}

build_shikane() {
  cargo build --release

  install -s -Dm755 target/release/shikane    -t "${INSTALLATION_PREFIX}/bin/"
  install -s -Dm755 target/release/shikanectl -t "${INSTALLATION_PREFIX}/bin/"
}
