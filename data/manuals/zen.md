---
zen: 1.23.3b
---

# Zen Browser

## Disable Encrypted Client-Hello (ECH)

In `about:config`, set

```ini
network.dns.echconfig.enabled=false
network.dns.http3_echconfig.enabled=false
```

## Custom CSS

In `about:config`, set

```ini
toolkit.legacyUserProfileCustomizations.stylesheets=true
```

Then open `about:support`, click "Open Directory" for the "Profile Directory". Create a new directory called "`chrome/`". In this new directory, create a new file `userChrome.css` with the following content:

```css
* {
  box-shadow: none !important;
}

.zen-current-workspace-indicator {
  display: none !important;
}

.zen-essentials-container {
  padding-bottom: 5px;
}

#tabbrowser-tabs:has(.zen-essentials-container) #zen-tabs-wrapper {
  margin-top: 6px !important;
}
```
