# Install

Run the Gist, enter password, tap a few buttons, then voilà: your mac is set up.
```bash
curl -s https://gist.githubusercontent.com/ViktorJT/d1d7d488057827ab16af656ce828b166/raw/72138d53393d7e206fa53b096e4c0aa4e77c10d5/install.sh | bash
```


# Export

Follow these steps if you plan to export settings:

1. Export custom mac keyboard shortcuts
```bash
defaults export com.apple.symbolichotkeys - > $HOME/Code/Configs/macos-keyboard-shortcuts.xml
```

2. Export Raycast preferences from app, then update file in $HOME/Code/Configs/raycast.Raycast.raycastconfig
```bash
Raycast Settings > Advanced > Import / Export > Export
```

3. Push changes to this repo
