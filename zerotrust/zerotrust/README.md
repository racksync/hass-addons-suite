# Cloudflare Zero Trust Tunnel Add-on for Home Assistant

[![Base Image](https://img.shields.io/github/v/release/hassio-addons/addon-base?color=orange&label=Hassio%20Image)](https://github.com/home-assistant/docker-base)
[![alpine-armhf](https://img.shields.io/badge/armhf-yes-brightgreen)](https://alpinelinux.org/releases/)
[![alpine-armv7](https://img.shields.io/badge/armv7-yes-brightgreen)](https://alpinelinux.org/releases/)
[![alpine-aarch64](https://img.shields.io/badge/aarch64-yes-brightgreen)](https://alpinelinux.org/releases/)
[![alpine-amd64](https://img.shields.io/badge/amd64-yes-brightgreen)](https://alpinelinux.org/releases/)
[![alpine-i386](https://img.shields.io/badge/i386-yes-brightgreen)](https://alpinelinux.org/releases/)
[![cloudflare-tunnel-release](https://img.shields.io/github/v/release/racksync/hass-addons-cloudflared-tunnel)](https://github.com/racksync/hass-addons-cloudflared-tunnel/releases)
[![last commit](https://img.shields.io/github/last-commit/racksync/hass-addons-cloudflared-tunnel)](https://github.com/racksync/hass-addons-cloudflared-tunnel/commit/)

This Home Assistant add-on provides Cloudflare Zero Trust Tunnel functionality, enabling secure remote access to your Home Assistant instance and other local services through Cloudflare's global network.

## Features

- ✅ **Zero Trust Security**: Enterprise-grade security through Cloudflare
- ✅ **Universal Architecture**: Supports all Home Assistant hardware platforms
- ✅ **Easy Configuration**: Token-based setup for beginners
- ✅ **Advanced Options**: Custom config file support for power users
- ✅ **Protocol Support**: QUIC and HTTP/2 for optimal performance
- ✅ **Multiple Services**: Route multiple domains and services through one tunnel

## Quick Setup (Token Method)

**Perfect for beginners and simple setups**

1. **Install Add-on**: Add repository `https://github.com/racksync/hass-addons-cloudflared-tunnel` to Home Assistant
2. **Create Tunnel**: Generate tunnel from [Cloudflare Zero Trust Dashboard](https://dash.teams.cloudflare.com/)
3. **Configure**: Enter tunnel token in add-on configuration
4. **Start**: Select protocol (QUIC recommended) and restart add-on

## Advanced Setup (Config File Method)

**For complex setups with multiple tunnels or custom routing**

1. **Create Configuration**: Build your custom `config.yaml` file
2. **Upload Files**: Place `config.yaml` and `credentials.json` in `/ssl/` directory
3. **Enable Override**: Toggle "Config" option in add-on settings
4. **Configure**: Leave token field empty, select protocol, and restart

## 📖 Complete Documentation

For detailed installation steps, troubleshooting, and advanced configuration options, see the **[Complete Documentation](DOCS.md)**

## Configuration Options

| Option | Type | Required | Description |
|--------|------|----------|-------------|
| **Token** | String | No* | Cloudflare tunnel token (not needed when using Config method) |
| **Protocol** | Select | No | Connection protocol (QUIC/HTTP2, default: QUIC) |
| **Config** | Boolean | No | Enable custom config file override (default: false) |
| **Additional Args** | String | No | Extra cloudflared command line arguments |

*Required when not using Config file method

## Supported Services

- **Home Assistant**: Primary use case with full WebSocket support
- **Grafana**: Analytics dashboards
- **Unifi Controller**: Network management
- **Router Interfaces**: Admin panels
- **Any HTTP/HTTPS Service**: Custom local applications

## Home Assistant Configuration

Required `configuration.yaml` updates:

```yaml
http:
  cors_allowed_origins:
    - https://your-homeassistant-domain.com
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
    - 172.30.33.0/24
    - 172.30.32.0/24
    - ::1
```

## Security Features

- 🔒 **Cloudflare Access**: Add authentication layers
- 🌍 **Geo-fencing**: Restrict access by location
- 📊 **Access Logs**: Monitor tunnel usage
- 🛡️ **DDoS Protection**: Cloudflare's network protection
- 🔐 **TLS Encryption**: End-to-end encrypted connections

## Architecture Support

This add-on supports all Home Assistant hardware:

- **Raspberry Pi**: All models (armhf, armv7, aarch64)
- **Intel/AMD**: 64-bit and 32-bit systems (amd64, i386)
- **Virtual Machines**: Any supported architecture
- **Docker**: Standard Linux containers

## Getting Help

- 📚 **Documentation**: See [DOCS.md](DOCS.md) for complete setup instructions
- 🐛 **Issues**: Report bugs on [GitHub Issues](https://github.com/racksync/hass-addons-cloudflared-tunnel/issues)
- 💬 **Community**: [Home Assistant Community](https://community.home-assistant.io/)
- 📺 **Discord**: [Home Automation Thailand Discord](https://discord.gg/Wc5CwnWkp4)

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