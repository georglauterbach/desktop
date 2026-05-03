# Yubikey

## PAM

To use your Yubikey with PAM, install `libpam-u2f` and associate the key with your account:

```bash
sudo apt --yes install libpam-u2f
mkdir -p "${HOME}/.config/Yubico"

# may prompt a pin and requires to touch the key once it flashes
pamu2fcfg >"${HOME}/.config/Yubico/u2f_keys"

# register backup keys
pamu2fcfg -n >>"${HOME}/.config/Yubico/u2f_keys"

sudo bash
cat >/etc/pam.d/common-u2f <<"EOF"
# enable passwordless auuthentication via Yubikeys
auth    sufficient                      pam_u2f.so
EOF
```

You can now edit services by

1. adding the Yubikey as the first factor by adding `@include common-u2f` **before** `@include common-auth`
2. adding the Yubikey as a second factor by adding `@include common-u2f` **after** `@include common-auth`

The following services could be added (non-exhaustive):

| Service   | File                |
| :-------- | :------------------ |
| `sudo`    | `/etc/pam.d/sudo`   |
| `sudo -i` | `/etc/pam.d/sudo-i` |
| `su`      | `/etc/pam.d/su`     |

## SSH & GPG

There is an excellent community guide on how to set up SSH and GPG with your Yubikey at [`drduh/YubiKey-Guide`](https://github.com/drduh/YubiKey-Guide).
