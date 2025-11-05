# Home Assistant Cloudflare Tunnel - Zero Trust

## How to Install Add-On

1. Install addon by adding repository: https://github.com/racksync/hass-addons-cloudflared-tunnel to your Home Assistant addon store
2. Create Tunnel from [Zero Trust Dashboard](https://dash.teams.cloudflare.com/)

## Configuration Methods

### Method 1: Token Authentication (Default)

1. Go to addon configuration and enter the token obtained from step 2
2. Select protocol (QUIC/HTTP2) - default is QUIC
3. Configure your configuration.yaml then restart Home Assistant

### Method 2: Config File Override (Advanced)

For advanced users who want to use a custom `config.yaml` file instead of token authentication:

#### Step 1: Create Cloudflare Tunnel Config File

Create a `config.yaml` file with your tunnel configuration:

```yaml
tunnel: your-tunnel-id-here
credentials-file: /root/.cloudflared/credentials.json

ingress:
  - hostname: your-homeassistant.everyha.com
    service: http://homeassistant.local:8123
  - hostname: your-nabu.everyha.com
    service: http://homeassistant.local:8123
  - service: http_status:404
```

#### Step 2: Place Config File in Home Assistant

Upload your `config.yaml` file to your Home Assistant SSL directory:

**Path:** `/ssl/config.yaml`

**Methods to upload:**
- **File Editor addon:** Navigate to `/ssl/` directory and upload
- **Samba share:** Access your Home Assistant share and place in `/ssl/`
- **Terminal/SSH:** Copy to the SSL directory
- **Web UI:** Use Supervisor > File Editor if available

#### Step 3: Enable Config Override in Addon

1. Go to addon configuration
2. Enable **"Config"** toggle (set to `true`)
3. Leave token field empty
4. Select preferred protocol (QUIC/HTTP2)
5. Save and restart the addon

#### Step 4: Place Credentials File

Place your `credentials.json` file in the same `/ssl/` directory:
- **Path:** `/ssl/credentials.json`

The addon will automatically copy both files to the container and use them.

## Home Assistant Configuration

Add this to your `configuration.yaml`:

```yaml
http:
  cors_allowed_origins:
    - https://your-homeassistant.everyha.com
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
    - 172.30.33.0/24
    - ::1
```

Restart Home Assistant after making changes.

![racksync-screenshot](https://github.com/racksync/hass-addons-cloudflared-tunnel/blob/main/zerotrust/screenshot.png?raw=true)

### Automation Training

- [Products and Services](http://racksync.com)
- [Training Courses](https://facebook.com/racksync)

### Community

- [Home Automation Thailand](https://www.facebook.com/groups/hathailand)
- [Home Automation Marketplace](https://www.facebook.com/groups/hatmarketplace)
- [Home Automation Thailand Discord](https://discord.gg/Wc5CwnWkp4)