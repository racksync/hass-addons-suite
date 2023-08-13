# Home Assistant AutoSSH Tunnel 

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
