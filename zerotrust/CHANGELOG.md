### CHANGELOG

## 2025.12.1
### Feature
  - **NEW**: Native Cloudflared tunnel metrics monitoring
  - Add configurable native metrics exposure using cloudflared's `--metrics` flag
  - Support for custom metrics port configuration (default: 2025)
  - Direct port access to cloudflared's built-in metrics endpoint
  - Binds metrics to all network interfaces (0.0.0.0) for external access
  - Native Prometheus-format metrics from Cloudflare's tunnel service
  - Perfect integration with Prometheus, Grafana, and monitoring tools
### Enhancement
  - Update minimum Home Assistant version to 2025.12.1
  - Improve tunnel performance visibility and debugging capabilities
  - Add comprehensive metrics documentation and usage examples
  - Simplified architecture using cloudflared's native metrics server
  - No additional services required - zero overhead metrics exposure
### Localization
  - Add English and Thai translations for metrics configuration options
  - Update documentation with metrics monitoring setup guide

## 2025.11.2
### Consolidation
  - Merge zerotrust and zerotrust-pi into single universal addon
  - Remove duplicate Raspberry Pi specific version
  - Update documentation to reflect universal architecture support
  - Add Raspberry Pi support with armhf-base-raspbian
### Feature
  - Replace free-form flag field with protocol dropdown (HTTP2/QUIC)
  - Add user-friendly protocol selection interface
  - Improve logging to show selected protocol
### Security
  - Enable auth_api for improved security rating
  - Maintain custom AppArmor profile for enhanced security protection
  - Improve overall security score while maintaining functionality
### Localization
  - Add English (en) translations for addon configuration
  - Add Thai (th) translations for addon configuration
  - Improve user experience with multi-language support
  - Add descriptive field names and help text in both languages

## 2025.11.1
### Update
  - Fix Docker build issues with read-only file system permissions
  - Update base image to ```3.22```
  - Fix Dockerfile warnings and improve build consistency

## 2024.8.1
### Update
  - add docker internal into ```http```integration
  - bump base image to 3.20

## 2023.8.1
### Update
  - remove ```host_pid``` and ```map```
  - Minimum Home Assistant 2023.8.1 Requirement

## 2023.7.1
### Update
  - Legacy mode discontinued
  - Use release format as Home Assistant (eg: 2023.7.1)
  - Minimum Home Assistant 2021.7.1 Requirement
  - Update Base Image to 3.18

## 2023.04.26
### Update
  - Remove ```--force``` argument

## 2022.11.14b
### Update

  - Remove apk add

## 2022.11.14a
### Update

  - Update Finish Script


## 2022.11.14
### Add

  - Add Separate Raspberry Pi Support

## 2022.11.13
### Change

  - Change to home-assistant base image 3.16

## 2022.11.09
### Change

  - Change Base Image to hassio-addons:12.2.6

## 2022.08.21
### Change

  - Change Base Image to hassio-addons:12.2.3

## 2022.07.10a
### Fix

  - Fix Typo

## 2022.07.10
### Remove

  - Deprecated Legacy 
```
Cloudflare will no longer support legacy deployments of Cloudflare Tunnel on On October, 2022. 
```

## 2022.07.08
### Fix

  - Fix Legacy Condition

## 2022.06.26
### Added

  - More debug info
  - Add-on Translation

### Changed

  - Handle ```cloudflared``` running method with more complexity (Need to be improve)

## 2022.06.23
### Changed

  - Need Advance Mode Enabled
  - Minimum Home Assistant 2022.6.6 Requirement

### Bug Fix

  - Fix error when no cred.json (mark as option)


## 2022.06.21 
### Added

  - Additional argument with "flag"
  - Legacy Option
  - net.core.rmem_max = 2500000

## 2022.06.19
### Added

- add "--no-autoupdate" option
- customizable additional flag

## 2022.06.14a
### Add LTS Tunnel as Minor Release 

- Recommend [LTS] Instead of [Legacy]


## 2022.06.14
### First Release of LTS

- Bye bye [Legacy Mode] Say Hello to [LTS]
- S6-Overlay-v3
- Base Image v3.15




