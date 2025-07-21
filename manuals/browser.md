# ZEN

## What

I use the [Zen browser](https://zen-browser.app/), which is based on Firefox. Like Firefox, [Zen is FOSS](https://github.com/zen-browser).

## Why

I like Zen because

- I think it looks better than Firefox, including the vertical tab bar
- I love the shortcuts, e.g. for copying the URL quickly
- it somehow actually appears _calmer_ than Firefox

## Installation

```bash
flatpak install flathub app.zen_browser.zen
```

## Modifications

>[!NOTE]
>
> To see the profile directory, open `about:profiles`, choose the profile (default is "Profile: Default (release)"), and note the "Local Directory", which is the profile directory.

Next to some shortcuts and the usual settings I change, I

1. added custom CSS by
    1. setting `toolkit.legacyUserProfileCustomizations.stylesheets=true` in `about:config`
    2. going into the profile directory
    3. creating the directory `chrome/` if it is not there yet
    4. creating the file `chrome/userChrome.css` with the following content:

        ```css
        * {
          box-shadow: none !important;
        }
        ```
2. added custom settings from [`yokoffing/Betterfox`](https://github.com/yokoffing/Betterfox/blob/main/zen/user.js) by
    1. going into the profile directory
    2. running `curl -sSfL -o user.js https://raw.githubusercontent.com/yokoffing/Betterfox/refs/heads/main/zen/user.js`

## Extensions

### Permanent

- [Grammar and Spell Checker - LanguageTool](https://addons.mozilla.org/en-US/firefox/addon/languagetool/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
- [Consent-O-Matic](https://addons.mozilla.org/en-US/firefox/addon/consent-o-matic/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
- [Dark Background and Light Text](https://addons.mozilla.org/en-US/firefox/addon/dark-background-light-text/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
- [Kagi Search for Firefox](https://addons.mozilla.org/en-US/firefox/addon/kagi-search-for-firefox/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

### Situational

- [Simple Modify Headers - Extended](https://addons.mozilla.org/en-US/firefox/addon/simple-modify-headers-extended/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
