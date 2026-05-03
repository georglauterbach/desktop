# `bwrap` AppArmor `userns` Fix

In case applications relying on `bwrap` run into issues with AppArmor, you can unconfine `bwrap` in so far as to running `userns`. Create or edit the file `/etc/apparmor.d/bwrap`:

```ini
# Gives bwrap a named profile so it may create unprivileged user
# namespaces while kernel.apparmor_restrict_unprivileged_userns=1.
abi <abi/4.0>,
include <tunables/global>
profile bwrap /usr/bin/bwrap flags=(unconfined) {
  userns,
  # Site-specific additions and overrides.
  include if exists <local/bwrap>
}
```

Then run

```bash
# load now
sudo apparmor_parser -r /etc/apparmor.d/bwrap

# verify and test
sudo aa-status | grep bwrap # should list the bwrap profile
bwrap --unshare-all --ro-bind /usr /usr --dev /dev \
  --symlink usr/lib /lib --symlink usr/lib64 /lib64 /usr/bin/echo ok
```
