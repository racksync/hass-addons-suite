# Home Assistant Cloudflared Argo Tunnel - Zero Trust


[![Base Image](https://img.shields.io/github/v/release/hassio-addons/addon-base?color=orange&label=Hassio%20Image)](https://github.com/home-assistant/docker-base)  [![alpine-armhf](https://img.shields.io/badge/armhf-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-armv7](https://img.shields.io/badge/armv7-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-aarch64](https://img.shields.io/badge/aarch64-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-amd64](https://img.shields.io/badge/amd64-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-i386](https://img.shields.io/badge/i386-yes-brightgreen)](https://alpinelinux.org/releases/)[![cloudflare-argo-tunnel-release](https://img.shields.io/github/v/release/racksync/hass-addons-cloudflared-tunnel)](https://github.com/racksync/hass-addons-cloudflared-tunnel/releases) [![last commit](https://img.shields.io/github/last-commit/racksync/hass-addons-cloudflared-tunnel)](https://github.com/racksync/hass-addons-cloudflared-tunnel/commit/)

## How to Install & Setup

### Quick Setup (Token Method)
1. Install addon from repository: https://github.com/racksync/hass-addons-cloudflared-tunnel
2. Create tunnel from [Zero Trust Dashboard](https://dash.teams.cloudflare.com/)
3. Configure addon with your tunnel token
4. Select protocol (QUIC recommended) and restart

### Advanced Setup (Config File Method)
For advanced configuration with custom `config.yaml`:

1. Create your tunnel config file
2. Upload to `/ssl/config.yaml` in Home Assistant
3. Enable "Config" toggle in addon settings
4. Upload credentials to `/ssl/credentials.json`
5. Restart addon

📖 **Detailed documentation available in the addon's Documentation tab**

Read detailed manuals and methods through the Add-on's Documentation tab

### Automation Training

- [Products and Services](http://racksync.com)
- [Training Courses](https://facebook.com/racksync)

### Community

- [Home Automation Thailand](https://www.facebook.com/groups/hathailand)
- [Home Automation Marketplace](https://www.facebook.com/groups/hatmarketplace)
- [Home Automation Thailand Discord](https://discord.gg/Wc5CwnWkp4)


# [RACKSYNC CO., LTD.](https://racksync.com)

RACKSYNC COMPANY LIMITED is an expert in Automation and Smart Solutions of all sizes. We provide consulting services including system design, installation, and monitoring by experts. We are also a full-service Software as a Service development company.
\
\
RACKSYNC COMPANY LIMITED \
Suratthani, Thailand 84100 \
Email : devops@racksync.com \
Tel : +66 85 880 8885 

[![Home Automation Thailand Discord](https://img.shields.io/discord/986181205504438345?style=for-the-badge)](https://discord.gg/Wc5CwnWkp4) [![Github](https://img.shields.io/github/followers/racksync?style=for-the-badge)](https://github.com/racksync) 
[![WebsiteStatus](https://img.shields.io/website?down_color=grey&down_message=Offline&style=for-the-badge&up_color=green&up_message=Online&url=https%3A%2F%2Fracksync.com)](https://racksync.com)