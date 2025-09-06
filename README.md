MCSAST
===
[![Discord](https://img.shields.io/discord/891325967203729472?color=5865F2&label=discord&style=for-the-badge)](https://discord.gg/uQ4UXANnP2)
[![GitHub branch check runs](https://img.shields.io/github/check-runs/MagicTeaMC/Minecraft-server-auto-setup/v2?style=for-the-badge)](https://github.com/MagicTeaMC/Minecraft-server-auto-setup/actions)
[![Crates.io Total Downloads](https://img.shields.io/crates/d/mcsast?style=for-the-badge)](https://crates.io/crates/mcsast)
[![Crates.io Version](https://img.shields.io/crates/v/mcsast?style=for-the-badge)](https://crates.io/crates/mcsast)
[![AUR Version](https://img.shields.io/aur/version/mcsast?style=for-the-badge)](https://aur.archlinux.org/packages/mcsast)

Manage Minecraft server / proxy / plugins quickly and easily!
## Quick start
### Install via Cargo  
#### Latest stable build from crates.io
```bash
cargo install mcsast
```
#### Latest code from GitHub
```bash
cargo install --git https://github.com/MagicTeaMC/Minecraft-server-auto-setup.git --branch v2
```
#### Latest stable build from AUR
```bash
paru -S mcsast
```
Or with yay
```bast
yay -S mcsast
```
### Run with command
```
mcsast setup
```
Give information to us with terminal:
<img width="1378" alt="terminal look" src="https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/refs/heads/v2/images/terminal.png" />
## Supported softwares
- [Paper](https://github.com/PaperMC/Paper)
- [Folia](https://github.com/PaperMC/Folia)
- [Purpur](https://github.com/PurpurMC/Purpur/)
- [Velocity](https://github.com/PaperMC/Velocity)
- [Gate](https://github.com/minekube/gate)
- [Nukkit](https://github.com/CloudburstMC/Nukkit)
- [Geyser](https://github.com/GeyserMC/Geyser)

Want to add other software support? [Open an Issue](https://github.com/MagicTeaMC/Minecraft-server-auto-setup/issues).  

## Servers commands
### Setup a server
```bash
mcsast setup
```
If you want it to setup automantic, here is a command  
Note: The `--mc-version` and `--eula` flags are only required for Java Edition servers (not proxies).
```bash
mcsast setup --software=paper --mc-version=1.21.1 --eula=true -y
```
### Sync latest build of current Minecraft version
```bash
mcsast sync
```
### Upgrade Minecraft version
```bash
mcsast upgrade
```
or
```bash
mcsast upgrade --version 1.21.6
```
## Plugins commands
### Help message
```bash
mcsast plugins
```
### List plugins
```bash
mcsast plugins list
```
### Add plugin 
Note: `--force` to install latest unstable version  
```bash
mcsast plugins add <name>
```
### Load plugins setup
```bash
mcsast plugins load <file.json>
```
### Update plugins
Note: `--force` to install latest unstable version  
```bash
mcsast plugins update <name/all>
```
### Remove plugin
```bash
mcsast plugins remove <name>
```
### Search plugins
```bash
mcsast plugins search <name>
```
### Get plugin information
```bash
mcsast plugins info <name/ID>
```
### Export plugins setup
Note: `--output <filename.json>` to custom output file name  
```bash
mcsast plugins export
```