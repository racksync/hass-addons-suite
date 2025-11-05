# Home Assistant Cloudflare Zero Trust Tunnel

[![Base Image](https://img.shields.io/badge/Base%20Image-Home%20Assistant%20Docker%20Base-blue)](https://github.com/home-assistant/docker-base)
[![Base Image](https://img.shields.io/github/v/release/hassio-addons/addon-base?color=orange&label=Hassio%20Image)](https://github.com/hassio-addons/addon-base)
[![raspbian-armhf](https://img.shields.io/badge/armhf-yes-brightgreen)](https://www.raspbian.org/)
[![alpine-armv7](https://img.shields.io/badge/armv7-yes-brightgreen)](https://alpinelinux.org/releases/)
[![alpine-aarch64](https://img.shields.io/badge/aarch64-yes-brightgreen)](https://alpinelinux.org/releases/)
[![alpine-amd64](https://img.shields.io/badge/amd64-yes-brightgreen)](https://alpinelinux.org/releases/)
[![alpine-i386](https://img.shields.io/badge/i386-yes-brightgreen)](https://alpinelinux.org/releases/)
[![cloudflare-tunnel-release](https://img.shields.io/github/v/release/racksync/hass-addons-cloudflared-tunnel)](https://github.com/racksync/hass-addons-cloudflared-tunnel/releases)
[![last commit](https://img.shields.io/github/last-commit/racksync/hass-addons-cloudflared-tunnel)](https://github.com/racksync/hass-addons-cloudflared-tunnel/commit/)

## Overview

This Home Assistant add-on provides Cloudflare Zero Trust Tunnel functionality, allowing secure remote access to your Home Assistant instance through Cloudflare's global network.

## Supported Architectures

- ✅ **armhf** - Raspberry Pi (1, Zero, Zero W)
- ✅ **armv7** - Raspberry Pi 2, 3
- ✅ **aarch64** - Raspberry Pi 3, 4, 5 (64-bit)
- ✅ **amd64** - Intel/AMD 64-bit systems
- ✅ **i386** - Intel/AMD 32-bit systems

## Quick Start

### Installation

1. Add this repository to your Home Assistant add-on store:
   ```
   https://github.com/racksync/hass-addons-cloudflared-tunnel
   ```

2. Install the **Cloudflare Zero Trust Tunnel** add-on

3. Create a tunnel from your [Cloudflare Zero Trust Dashboard](https://dash.teams.cloudflare.com/)

4. Configure the add-on with your tunnel token and restart

### Configuration Options

- **Token Authentication** (Recommended): Simply enter your tunnel token
- **Config File Override**: For advanced users with custom tunnel configurations

📖 **For detailed setup instructions and advanced configuration, see the [documentation](zerotrust/DOCS.md)**

## Features

- ✅ **Zero Trust Security**: Leverages Cloudflare's security features
- ✅ **Protocol Support**: QUIC and HTTP/2 for optimal performance
- ✅ **Universal Architecture**: Supports all Home Assistant hardware
- ✅ **Easy Setup**: Token-based configuration for beginners
- ✅ **Advanced Configuration**: Custom config file support for power users
- ✅ **Stable Versioning**: No automatic binary updates for reliability

![Cloudflare Tunnel Setup](https://github.com/racksync/hass-addons-cloudflared-tunnel/blob/main/zerotrust/screenshot.png?raw=true)

### Automation Training

- [Products and Services](http://racksync.com)
- [Training Courses](https://facebook.com/racksync)

### Community

- [Home Automation Thailand](https://www.facebook.com/groups/hathailand)
- [Home Automation Marketplace](https://www.facebook.com/groups/hatmarketplace)
- [Home Automation Thailand Discord](https://discord.gg/Wc5CwnWkp4) 

## [RACKSYNC CO., LTD.](https://racksync.com)

RACKSYNC COMPANY LIMITED is an expert in Automation and Smart Solutions of all sizes. We provide consulting services including system design, installation, and monitoring by experts. We are also a full-service Software as a Service development company.
\
\
RACKSYNC COMPANY LIMITED \
Suratthani, Thailand 84000 \
Email : devops@racksync.com \
Tel : +66 85 880 8885 

[![Home Automation Thailand Discord](https://img.shields.io/discord/986181205504438345?style=for-the-badge)](https://discord.gg/Wc5CwnWkp4) [![Github](https://img.shields.io/github/followers/racksync?style=for-the-badge)](https://github.com/racksync) 
[![WebsiteStatus](https://img.shields.io/website?down_color=grey&down_message=Offline&style=for-the-badge&up_color=green&up_message=Online&url=https%3A%2F%2Fracksync.com)](https://racksync.com)



