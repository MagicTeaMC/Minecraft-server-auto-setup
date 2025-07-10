# MCSAST
[![Discord](https://img.shields.io/discord/891325967203729472?color=5865F2&label=discord&style=for-the-badge)](https://discord.gg/uQ4UXANnP2)
![GitHub branch check runs](https://img.shields.io/github/check-runs/MagicTeaMC/Minecraft-server-auto-setup/v2?style=for-the-badge)
![Crates.io Total Downloads](https://img.shields.io/crates/d/mcsast?style=for-the-badge)
![Crates.io Version](https://img.shields.io/crates/v/mcsast?style=for-the-badge)

Manage Minecraft server / proxy quickly and easily!
## Quick start
### Install via Cargo  
```
cargo install mcsast
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

## Commands
### Setup a server
```
mcsast setup
```
If you want it to setup automantic, here is a command  
Note: The `--mc-version` and `--eula` flags are only required for Java Edition servers.
```
mcsast setup --software=paper --mc-version=1.21.1 --eula=true -y
```
### Update to latest build of current Minecraft version
```
mcsast update
```
### Upgrade Minecraft version
```
mcsast upgrade
```
or
```
mcsast upgrade --version 1.21.6
```