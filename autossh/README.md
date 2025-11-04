# Home Assistant AutoSSH Tunnel 

[![Base Image](https://img.shields.io/badge/Base%20Image-3.22-blue)](https://github.com/home-assistant/docker-base)  [![alpine-armhf](https://img.shields.io/badge/armhf-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-armv7](https://img.shields.io/badge/armv7-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-aarch64](https://img.shields.io/badge/aarch64-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-amd64](https://img.shields.io/badge/amd64-yes-brightgreen)](https://alpinelinux.org/releases/) 
[![alpine-i386](https://img.shields.io/badge/i386-yes-brightgreen)](https://alpinelinux.org/releases/)
[![autossh-tunnel-release](https://img.shields.io/github/v/release/racksync/hass-addons-autossh-tunnel)](https://github.com/racksync/hass-addons-autossh-tunnel/releases) [![last commit](https://img.shields.io/github/last-commit/racksync/hass-addons-autossh-tunnel)](https://github.com/racksync/hass-addons-autossh-tunnel/commit/)


## How to configure

1. Add repository : https://github.com/racksync/hass-addons-autossh-tunnel into Home Assistant Add-ons Section
2. Install and Setup ```hostname```  ```user``` ```remote_forwarding``` for destination expose
3. Start adddon and copy public key into ```~/.ssh/authorized_keys``` 
4. Restart addon again

5. Enable GatewayPorts in ```sshd_config```

  ```
  GatewayPorts clientspecified
  ```
### Forwarding Explanation

```
127.0.0.1:8123:192.168.0.10:8123
```


| Host & Port          | Explain |
|------------------|------|
| ``127.0.0.1:8123``              | Destination | 
| ``192.168.0.10:8123``              | Origin | 


## Caution

- Beware to use root permit login on production!
- Do not expose to 0.0.0.0 or public address

## Welcome for any issue ticket

### Automation Training

- [Services & Products](http://racksync.com)
- [Automation Course](https://facebook.com/racksync)

### Community

- [Home Automation Thailand](https://www.facebook.com/groups/hathailand)
- [Home Automation Marketplace](https://www.facebook.com/groups/hatmarketplace)
- [Home Automation Thailand Discord](https://discord.gg/Wc5CwnWkp4) 

## [RACKSYNC CO., LTD.](https://racksync.com)

We helps our customers to create life easier across the border of entire technology stack with household and business solutions. We modernize life with Information Technology, Optimize and collect data to make everything possible, secure & trusty
\
\
RACKSYNC COMPANY LIMITED \
Suratthani, Thailand 84100 \
Email : devops@racksync.com \
Tel : +66 85 880 8885 

[![Home Automation Thailand Discord](https://img.shields.io/discord/986181205504438345?style=for-the-badge)](https://discord.gg/Wc5CwnWkp4) [![Github](https://img.shields.io/github/followers/racksync?style=for-the-badge)](https://github.com/racksync) 
[![WebsiteStatus](https://img.shields.io/website?down_color=grey&down_message=Offline&style=for-the-badge&up_color=green&up_message=Online&url=https%3A%2F%2Fracksync.com)](https://racksync.com)