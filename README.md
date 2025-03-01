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

### docker-compose.yml
```yml
version: "3.9"

services:
  dev:
    image: ubuntu:22.04
    container_name: dev-env
    hostname: dev-nas
    restart: unless-stopped
    tty: true
    stdin_open: true
    environment:
      - TZ=Europe/Stockholm
    volumes:
      - /volume1/docker/dev-env:/root
      - /volume1/projects:/projects
    ports:
      - "60000-61000:60000-61000/udp"  # Mosh default port range
    command: >
      bash -c "curl -fsSL https://gist.githubusercontent.com/ViktorJT/0beed64647d907bf721225fcd0d8c201/raw/ipad-host-install.sh | bash"
```