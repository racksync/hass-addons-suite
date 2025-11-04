### CHANGELOG

## 2025.11.1
### Improvements
  - Update version to follow calendar versioning (CalVer)
  - Modernize configuration with additional monitoring options
  - Remove Slack bot dependencies from CI/CD pipeline
  - Streamline GitHub Actions workflow for better maintainability
### Fixes
  - Fix Docker build by removing strict package version pinning
  - Improve Docker layer efficiency by combining RUN commands
  - Ensure compatibility with Alpine Linux 3.22 base image
  - Fix local/remote forwarding format validation with better error messages
  - Add comprehensive forwarding format validation to prevent SSH failures

### Major Updates
  - Upgrade Home Assistant base image to version 3.22
  - Modernize configuration schema with new options
  - Improve Dockerfile with security best practices
  - Enhanced run.sh script with better error handling and logging
   
### New Features
  - Add local forwarding support (local_forwarding option)
  - Configurable server alive interval and count max
  - Custom monitoring port configuration
  - Connection attempts configuration
  - Multiple log levels (info, debug, error, warning)
  - Configuration notes for personal reference
   
### Security Improvements
  - Use ED25519 SSH keys by default (fallback to RSA)
  - Strict host key checking enabled
  - Better known_hosts management
  - Enhanced connection testing
  
### UX Improvements
  - Updated translations for all new options
  - Better error messages and logging
  - Configuration validation and testing
  - More descriptive default values

## 2023.8.2
### Change
  - host_network: true

## 2023.8.1
### Change
  - Base Image 3.18
  - Minimum Home Assistant 2023.8.1 Requirement
  - Improve Security Rating
  - Apparmor Enabled

## 2022.07.19
### Change

  - S6-Overlay-v3
  - Base Image v3.16
  - Need Advance Mode Enabled
  - Minimum Home Assistant 2022.7.5 Requirement






