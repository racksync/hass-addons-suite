# Home Assistant Cloudflare Zero Trust Tunnel - Complete Documentation

## Table of Contents

1. [Installation](#installation)
2. [Configuration Methods](#configuration-methods)
3. [Method 1: Token Authentication](#method-1-token-authentication-recommended)
4. [Method 2: Config File Override](#method-2-config-file-override-advanced)
5. [Home Assistant Configuration](#home-assistant-configuration)
6. [Troubleshooting](#troubleshooting)
7. [Security Considerations](#security-considerations)
8. [Advanced Features](#advanced-features)
9. [Tunnel Metrics Monitoring](#tunnel-metrics-monitoring)

## Installation

### Prerequisites

- Home Assistant OS or Supervised installation
- Cloudflare account with Zero Trust access
- Custom domain configured in Cloudflare

### Step 1: Add Repository

1. Navigate to **Home Assistant Supervisor**
2. Go to **Add-on Store**
3. Click the three dots menu (⋮) and select **Repositories**
4. Add: `https://github.com/racksync/hass-addons-cloudflared-tunnel`
5. Refresh the add-on store

### Step 2: Create Cloudflare Tunnel

1. Go to [Cloudflare Zero Trust Dashboard](https://dash.teams.cloudflare.com/)
2. Navigate to **Access > Tunnels**
3. Click **Create tunnel**
4. Choose **Cloudflared tunnel** and give it a name
5. Save the tunnel token - you'll need it for configuration

## Configuration Methods

This add-on supports two configuration methods:

| Method | Difficulty | Use Case | Recommended |
|--------|------------|----------|-------------|
| Token Authentication | ⭐ Beginner | Simple single tunnel setup | ✅ Yes |
| Config File Override | ⭐⭐⭐ Advanced | Multiple tunnels, custom routing | ⚠️ Power users only |

---

## Method 1: Token Authentication (Recommended)

This is the simplest method for most users.

### Step 1: Configure Add-on

1. Install the **Cloudflare Zero Trust Tunnel** add-on
2. Go to the add-on **Configuration** tab
3. Enter your tunnel **Token** in the token field
4. Select **Protocol** (QUIC recommended for better performance)
5. Click **Save**

### Step 2: Start and Test

1. Start the add-on
2. Check the logs for successful connection
3. Test access via your configured tunnel URL

### Step 3: Home Assistant Configuration

Update your `configuration.yaml`:

```yaml
http:
  cors_allowed_origins:
    - https://your-homeassistant-domain.com
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
    - 172.30.33.0/24  # Home Assistant Supervisor network
    - ::1
```

Restart Home Assistant after making changes.

---

## Method 2: Config File Override (Advanced)

Use this method for complex setups with multiple tunnels or custom routing rules.

### Step 1: Create Cloudflare Tunnel Config File

Create a `config.yaml` file with your tunnel configuration:

```yaml
tunnel: your-tunnel-id-here
credentials-file: /root/.cloudflared/credentials.json

ingress:
  # Primary Home Assistant instance
  - hostname: homeassistant.yourdomain.com
    service: http://homeassistant.local:8123
    originRequest:
      noTLSVerify: false

  # Additional services (optional)
  - hostname: nabucasa.yourdomain.com
    service: http://homeassistant.local:8123

  # Local network services (optional)
  - hostname: router.yourdomain.com
    service: http://192.168.1.1:80

  # Catch-all rule (required)
  - service: http_status:404
```

### Step 2: Place Files in Home Assistant

Upload your configuration files to the Home Assistant SSL directory:

**Required Files:**
- `/ssl/config.yaml` - Your tunnel configuration
- `/ssl/credentials.json` - Cloudflare credentials file

**Upload Methods:**

1. **File Editor Add-on:**
   - Install the official File Editor add-on
   - Navigate to `/ssl/` directory
   - Upload both files

2. **Samba Share:**
   - Enable Samba share in Home Assistant
   - Access `\\homeassistant.local\ssl\`
   - Copy files to the directory

3. **Terminal/SSH:**
   ```bash
   # Copy files to Home Assistant
   scp config.yaml root@homeassistant.local:/ssl/
   scp credentials.json root@homeassistant.local:/ssl/
   ```

### Step 3: Configure Add-on

1. Go to the add-on **Configuration** tab
2. Enable **"Config"** toggle (set to `true`)
3. Leave the **Token** field empty
4. Select preferred **Protocol** (QUIC/HTTP2)
5. Click **Save** and restart the add-on

## Home Assistant Configuration

### Basic HTTP Configuration

Add this to your `configuration.yaml`:

```yaml
http:
  cors_allowed_origins:
    - https://homeassistant.yourdomain.com
    - https://nabucasa.yourdomain.com
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
    - 172.30.33.0/24  # Supervisor network
    - 172.30.32.0/24  # Docker network
    - ::1
```

### Security Headers (Recommended)

```yaml
http:
  # ... other config ...
  x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
    - 172.30.33.0/24
    - 172.30.32.0/24
  ip_ban_enabled: true
  login_attempts_threshold: 5
```

### Restart Required

After modifying `configuration.yaml`, restart Home Assistant from **Settings > System > Restart**.

## Troubleshooting

### Common Issues

#### Add-on Won't Start
- Check token is correct and not expired
- Verify internet connectivity
- Check add-on logs for specific error messages

#### Connection Timeout
- Ensure firewall allows outbound connections
- Check if DNS resolution works
- Try switching protocol from QUIC to HTTP2

#### Certificate Errors
- Verify your domain is properly configured in Cloudflare
- Check SSL/TLS settings in Cloudflare (should be Full or Full Strict)
- Ensure Cloudflare proxy is enabled (orange cloud)

#### Home Assistant Not Accessible
- Verify `http:` configuration in `configuration.yaml`
- Check if Home Assistant is running locally
- Confirm tunnel routing matches your local service URLs

### Log Locations

- **Add-on logs:** Supervisor > Add-ons > Cloudflare Tunnel > Log tab
- **Home Assistant logs:** Settings > System > Logs

### Debug Mode

Enable additional logging by adding to add-on options:
```yaml
additional_args: "--loglevel debug"
```

## Security Considerations

### 🔒 Recommended Practices

1. **Use Strong Tokens**: Generate new tunnel tokens if compromised
2. **Enable Cloudflare Access**: Add additional authentication layers
3. **Monitor Access Logs**: Regularly check tunnel usage
4. **Update Regularly**: Keep add-on and Home Assistant updated
5. **Network Segmentation**: Use firewall rules to limit access

### Cloudflare Security Features

Enable these in your Cloudflare Zero Trust dashboard:

- **Access Policies**: Require authentication before accessing services
- **Device Posture**: Check device compliance
- **Geo-fencing**: Restrict access by location
- **Rate Limiting**: Prevent abuse and brute force attacks

## Advanced Features

### Multiple Services

Configure multiple Home Assistant instances or services:

```yaml
ingress:
  - hostname: home.yourdomain.com
    service: http://homeassistant.local:8123
  - hostname: grafana.yourdomain.com
    service: http://192.168.1.10:3000
  - hostname: unifi.yourdomain.com
    service: https://192.168.1.1:8443
  - service: http_status:404
```

### Load Balancing

Configure multiple backend servers:

```yaml
ingress:
  - hostname: ha.yourdomain.com
    service: https://home1.local:8123,https://home2.local:8123
    originRequest:
      noTLSVerify: true
```

### WebSocket Support

For services requiring WebSocket support:

```yaml
ingress:
  - hostname: ha.yourdomain.com
    service: http://homeassistant.local:8123
    originRequest:
      noTLSVerify: true
      connectTimeout: 30s
      tcpKeepAlive: 30s
```

### Tunnel Metrics Monitoring

This add-on supports exposing tunnel metrics for monitoring and debugging purposes.

#### Enabling Metrics

1. Go to the add-on **Configuration** tab
2. Set **Enable Metrics** to `true`
3. Configure **Metrics Port** (default: 2025)
4. Save and restart the add-on

#### Accessing Metrics

Once enabled, metrics can be accessed directly on the configured port:

```
http://homeassistant.local:2025/metrics
```

Replace `2025` with your configured metrics port if different from default.

**Note**: These are cloudflared's native built-in metrics, providing real-time tunnel performance data directly from Cloudflare's tunnel service. The add-on configures cloudflared to expose these metrics on all network interfaces (0.0.0.0) instead of just localhost, making them accessible through the host network.

#### Technical Implementation

This add-on uses cloudflared's native `--metrics` flag to expose the built-in metrics server:

- **Default Behavior**: cloudflared only exposes metrics on localhost (127.0.0.1)
- **Our Configuration**: `--metrics 0.0.0.0:2025` binds to all network interfaces
- **Network Access**: Uses `host_network: true` for direct port access
- **Format**: Native Prometheus-compatible metrics format
- **Reliability**: No additional services - just cloudflared's own metrics server

This approach provides the most reliable and comprehensive tunnel monitoring without any additional overhead.

#### Available Metrics

The cloudflared metrics endpoint provides comprehensive Prometheus-style metrics including:

- **Tunnel Connections**: Active tunnel connections and their status
- **Request Metrics**: HTTP request counts, response times, error rates
- **Bandwidth Usage**: Data transfer statistics (bytes in/out)
- **Connection Events**: Tunnel establishment, reconnections, failures
- **Protocol Information**: QUIC/HTTP2 connection details
- **Location Data**: Edge server locations and performance
- **Latency Measurements**: Real-time latency and throughput data

#### Integration with Monitoring Tools

The metrics endpoint can be integrated with external monitoring tools:

- **Prometheus**: Add as scrape target:
  ```
  http://homeassistant.local:2025/metrics
  ```
- **Grafana**: Create dashboards using the metrics endpoint
- **Home Assistant Monitor**: Use REST sensor with direct URL

Example Home Assistant configuration:

```yaml
sensor:
  - platform: rest
    resource: http://homeassistant.local:2025/metrics
    name: Cloudflare Tunnel Metrics
    value_template: "{{ value.split(' ')[1] if '#' not in value else '0' }}"
    json_attributes:
      - tunnel_connections
      - response_time
      - bytes_transferred
```

**Note**: cloudflared metrics are in Prometheus format (text-based), not JSON. You may need to parse the text format for specific metrics.

**Note**: Direct access provides the most reliable and straightforward integration with monitoring tools, as it doesn't rely on Home Assistant's ingress system.

## Additional Resources

- [Cloudflare Zero Trust Documentation](https://developers.cloudflare.com/cloudflare-one/)
- [Home Assistant Remote Access](https://www.home-assistant.io/more-info/remote-access/)
- [Community Support](https://community.home-assistant.io/)

![Cloudflare Tunnel Setup](https://github.com/racksync/hass-addons-cloudflared-tunnel/blob/main/zerotrust/screenshot.png?raw=true)

### Automation Training

- [Products and Services](http://racksync.com)
- [Training Courses](https://facebook.com/racksync)

### Community

- [Home Automation Thailand](https://www.facebook.com/groups/hathailand)
- [Home Automation Marketplace](https://www.facebook.com/groups/hatmarketplace)
- [Home Automation Thailand Discord](https://discord.gg/Wc5CwnWkp4)