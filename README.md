# Setup Scripts
Run the Gist, enter password, tap a few buttons, then voilà: everything is set up.

Scripts:
- Macbook
- Ipad Host

## Macbook
```bash
curl -s https://gist.githubusercontent.com/ViktorJT/d1d7d488057827ab16af656ce828b166/raw/macbook-install.sh | bash
```

#### Exporting Macbook configuration
1. Export custom mac keyboard shortcuts
```bash
defaults export com.apple.symbolichotkeys - > $HOME/Code/Configs/macos-keyboard-shortcuts.xml
```

2. Export Raycast preferences from app, then update file in $HOME/Code/Configs/raycast.Raycast.raycastconfig
```bash
Raycast Settings > Advanced > Import / Export > Export
```

## Ipad Host
```bash
curl -s https://gist.githubusercontent.com/ViktorJT/0beed64647d907bf721225fcd0d8c201/raw/ipad-host-install.sh | bash
```
