# Home Assistant Cloudflare Tunnel - Zero Trust

## Disclaimer ###

addon ตัวนี้เหมาะสำหรับคนที่มีเชี่ยวชาญการทำ tunnel ด้วย Cloudflare Zero Trust อยู่แล้ว 

## How to Install Add-on

1. ติดตั้ง addon ด้วยการ add repository : https://github.com/racksync/hass-addons-cloudflared-tunnel เข้าไปยัง addon list ตามปกติ
2. สร้าง Tunnel จาก [Zero Trust Dashboard](https://dash.teams.cloudflare.com/)
3. เข้าไปตั้งค่า addon กรอก token ที่ได้จากข้อ 2 (หากเป็นกรณีใช้ไฟล์ config.yaml ที่สร้างขึ้นเองให้นำไฟล์ไปวางไว้ที่ /ssl จากนั้น add-on จะดึง configuration มาใช้อัตโนมัติ
4. ตั้งค่า configuration.yaml จากนั้น Restart Home Assistant

```
http:
  cors_allowed_origins:
    - [YOUR-HOSTNAME]
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
```

![racksync-screenshot](https://github.com/racksync/hass-addons-cloudflared-tunnel/blob/main/zerotrust/screenshot.png?raw=true)

### Automation Training

- [สินค้าและบริการ](http://racksync.com)
- [เทรนนิ่งคอร์ส](https://facebook.com/racksync)

### Community

- [Home Automation Thailand](https://www.facebook.com/groups/hathailand)
- [Home Automation Marketplace](https://www.facebook.com/groups/hatmarketplace)
- [Home Automation Thailand Discord](https://discord.gg/Wc5CwnWkp4)