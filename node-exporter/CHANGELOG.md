### CHANGELOG

## 2025.11.2

### Bug Fixes
  - Fixed configuration schema for custom_collectors, ignore_mount_points, and ignore_network_devices
  - Corrected Home Assistant add-on schema format from list(str)? to proper YAML list format
  - Resolves configuration validation errors on add-on startup

## 2025.11.1

### Release Notes
  - Major security improvements with AppArmor enabled and minimal API permissions
  - Added configurable collectors for fine-grained metrics control (cpu, meminfo, diskstats, netdev, etc.)
  - Enhanced configuration options including log levels and ignore lists
  - Updated Node Exporter to version 1.8.2 for latest features and security
  - Improved multi-architecture support (amd64, aarch64, armv7)
  - Added comprehensive documentation and translations
  - Source-to-monorepo architecture with automated deployment
  - Enhanced TLS and authentication support
  - Added hardware monitoring capabilities (hwmon collector)
  - Improved overall security posture and performance
  - Updated GitHub workflow for source-to-monorepo architecture
  - Fixed monorepo sync to target correct node-exporter directory
  - Added configuration validation before sync to monorepo
  - Updated repository URLs to reflect correct deployment target
  - Enhanced version tagging and release management

## 2023.10.1

### Release Notes
  - First Release




