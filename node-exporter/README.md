# Prometheus Node Exporter

Exposes hardware and OS metrics for Prometheus monitoring. Collects system statistics like CPU, memory, disk, and network usage from your Home Assistant host.

## Quick Start

1. **Add Repository**: `https://github.com/racksync/hass-addons-suite`
2. **Install**: Find "Prometheus Node Exporter" and click **INSTALL**
3. **Configure**: Set log level, collectors, and security options as needed
4. **Start**: Click **START** to begin monitoring

## Key Features

- **Hardware Monitoring**: CPU, memory, disk, temperature metrics
- **Network Statistics**: Real-time interface and connection monitoring
- **Security-First**: AppArmor protection with minimal permissions
- **Configurable**: Enable/disable specific collectors
- **Multi-Architecture**: amd64, aarch64, armv7 support

## Configuration

### Basic Setup
```yaml
log_level: "info"
enable_basic_auth: false
enable_tls: false
```

### Advanced Features
- Configurable metrics collectors (cpu, meminfo, diskstats, etc.)
- HTTP Basic Authentication support
- TLS/HTTPS encryption
- Custom node_exporter arguments
- Mount point and network device filtering

## Access Metrics

- **Endpoint**: `http://your-home-assistant:9100/metrics`
- **Prometheus Integration**: Standard metrics format
- **Authentication**: Optional Basic Auth and TLS

## Documentation

For detailed configuration, development information, and advanced features, see [DOCS.md](DOCS.md).

## Support

- **Issues**: [GitHub Issues](https://github.com/racksync/hass-addons-suite/issues)
- **Source**: [Source Repository](https://github.com/racksync/hass-addons-prometheus-node-exporter)
- **Distribution**: [Home Assistant Add-ons Suite](https://github.com/racksync/hass-addons-suite/tree/main/node-exporter)

**Version**: 2025.11.1 | **Maintained by**: [RACKSYNC CO., LTD.](https://racksync.com) - ALL ABOUT AUTOMATION