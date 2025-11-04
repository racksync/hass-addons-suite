# Prometheus Node Exporter for Home Assistant

This add-on exposes hardware and OS metrics for Prometheus monitoring. It collects comprehensive system statistics like CPU, memory, disk, and network usage from your Home Assistant host and makes them available through the Prometheus metrics format.

## Features

- **Hardware Metrics**: CPU, memory, disk usage, and temperature monitoring
- **Network Statistics**: Real-time network interface monitoring
- **Security-First**: AppArmor protection, minimal permissions, principle of least privilege
- **Configurable**: Enable/disable specific collectors based on your needs
- **Prometheus Compatible**: Standard metrics endpoint for integration with Prometheus/Grafana
- **Multi-Architecture**: Support for amd64, aarch64, and armv7 systems

## Architecture

This repository follows a source-to-monorepo architecture:

- **Source**: Here (node-exporter/ directory) - Development and updates
- **Target**: [Home Assistant Add-ons Suite](https://github.com/racksync/hass-addons-suite) - Distribution to users

All changes made to the node-exporter directory are automatically validated and synced to the monorepo via GitHub Actions.

## Installation

This add-on is available through the Home Assistant Add-ons Suite repository:

1. **Add Repository to Home Assistant**:
   ```
   https://github.com/racksync/hass-addons-suite
   ```
   Go to Settings → Add-ons → Add-on Store → ⋮ → Add Repository

2. **Install Prometheus Node Exporter**:
   - Find "Prometheus Node Exporter" in the store
   - Click **INSTALL**
   - Configure as needed (see Configuration section)
   - **START** the add-on

## Configuration

### Basic Setup

```yaml
# Default configuration - works out of the box
log_level: "info"  # trace|debug|info|warn|error
enable_basic_auth: false
enable_tls: false
```

### Advanced Configuration

```yaml
# Enable/disable specific collectors
collectors:
  cpu: true          # CPU usage and utilization
  meminfo: true      # Memory statistics
  diskstats: true    # Disk I/O statistics
  netdev: true       # Network interface stats
  netstat: true      # Network connection stats
  filesystem: true   # Filesystem usage
  loadavg: true      # System load average
  time: true         # Current time metrics
  wifi: false        # WiFi statistics (if applicable)
  hwmon: true        # Hardware monitoring (temperature/fans)

# Ignore specific mount points or network devices
ignore_mount_points:
  - "/tmp"
  - "/run"

ignore_network_devices:
  - "docker0"
  - "veth*"

# Custom command line arguments for node_exporter
cmdline_extra_args: "--collector.disable-defaults --collector.cpu"
```

### Security Options

```yaml
# Enable HTTP Basic Authentication
enable_basic_auth: true
basic_auth_user: "your_username"
basic_auth_pass: "your_bcrypt_hash"

# Enable TLS/HTTPS
enable_tls: true
cert_file: "/ssl/fullchain.pem"
cert_key: "/ssl/privkey.pem"
```

## Metrics Endpoint

Once running, the add-on exposes metrics at:

- **HTTP**: `http://your-home-assistant:9100/metrics`
- **HTTPS** (if TLS enabled): `https://your-home-assistant:9100/metrics`
- **With Auth**: Include Basic Auth headers if enabled

### Example Prometheus Configuration

```yaml
scrape_configs:
  - job_name: 'homeassistant-node-exporter'
    static_configs:
      - targets: ['your-home-assistant:9100']
    metrics_path: '/metrics'
    # Add authentication if enabled
    basic_auth:
      username: 'your_username'
      password: 'your_password'
```

## Development

### Source Code Structure

```
node-exporter/
├── config.yaml          # Add-on configuration and schema
├── build.yaml           # Build configuration
├── Dockerfile           # Container image definition
├── CHANGELOG.md         # Version history and release notes
├── README.md           # This file
├── icon.png           # Add-on icon
├── logo.png           # Add-on logo
├── rootfs/            # Container filesystem
│   ├── etc/
│   │   ├── cont-init.d/
│   │   └── services.d/
│   └── run.sh
└── translations/
    └── en.yaml        # English translations
```

### Making Changes

1. Edit files in the `node-exporter/` directory
2. Test configuration changes locally
3. Commit and push to this repository
4. GitHub Actions will automatically validate and sync to the monorepo

### Automated Sync Process

- **Validation**: Configuration files are validated before sync
- **Version Management**: Automatic tagging with version information
- **Monorepo Update**: Files are synced to `racksync/hass-addons-suite`
- **Release Creation**: Automatic release tag creation

## Security Considerations

- **AppArmor**: Enabled for container isolation
- **Minimal Permissions**: Only requests necessary system access
- **Principle of Least Privilege**: Reduces attack surface
- **Authentication**: Optional Basic Auth and TLS support
- **Network Access**: Host network access required for system metrics

## Support & Contributing

- **Issues**: [GitHub Issues](https://github.com/racksync/hass-addons-suite/issues) in the monorepo
- **Discussions**: Community support and feature requests
- **Contributions**: Pull requests welcome in this source repository

## Version

**Current Version**: `2025.11.1`
**Release**: [View in Add-ons Suite](https://github.com/racksync/hass-addons-suite/releases/tag/node-exporter-v2025.11.1)

## License

This add-on follows the same licensing as the [Home Assistant Add-ons Suite](https://github.com/racksync/hass-addons-suite).

---

**Maintained by**: [RACKSYNC CO., LTD.](https://racksync.com) - ALL ABOUT AUTOMATION
**Location**: Bangkok, Thailand
**Email**: devops@racksync.com
**Website**: [www.racksync.com](https://www.racksync.com)
**X (Twitter)**: [@racksync](https://twitter.com/racksync)
**Facebook**: [racksync](https://www.facebook.com/racksync)