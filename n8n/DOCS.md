# n8n Configuration

## Default Configuration - Edit in YAML

```yaml
timezone: Asia/Bangkok
env_vars_list: []
cmd_line_args: ""
```

## Example of Extra Environment Variables

Add environment variables as a list in the addon configuration. Each variable should be on a new line following this format:

```yaml
env_vars_list:
  - "N8N_HOST: localhost"
  - "N8N_PORT: 5678"
  - "N8N_PROTOCOL: http"
  - "WEBHOOK_URL: https://your-tunnel-url.com" 
  - "N8N_EDITOR_BASE_URL: http://localhost:5678"
  - "N8N_ENCRYPTION_KEY: your-secret-key"
  - "NODE_ENV: development" 
  - "N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS: true" 
  - "N8N_SECURE_COOKIE: false" 
  - "N8N_USER_MANAGEMENT_JWT_SECRET: secret-key"
  - "N8N_RUNNERS_ENABLED: true" 
  - "N8N_PERSONALIZATION: false" 
  - "N8N_LOG_LEVEL: info" 
  - "N8N_LOG_OUTPUT: console" 
  - "N8N_LOG_FILE: /home/node/.n8n/logs/n8n.log" 
  - "N8N_LOG_FILE_MAX_SIZE: 120mb" 
  - "N8N_LOG_FILE_MAX_FILES: 10" 
  - "N8N_LOG_FILE_COMPRESSION: true" 
  - "N8N_LOG_FILE_ROTATE: true" 
  - "N8N_LOG_FILE_ROTATE_INTERVAL: 1d" 
  - "DB_TYPE: postgresdb"
  - "DB_POSTGRESDB_HOST: postgres"
  - "DB_POSTGRESDB_PORT: 5432"
  - "DB_POSTGRESDB_DATABASE: n8n"
  - "DB_POSTGRESDB_USER: n8n"
  - "DB_POSTGRESDB_PASSWORD: n8n"
  - "OLLAMA_HOST: host.docker.internal:11434"
```

[View all available environment variables](https://docs.n8n.io/hosting/environment-variables/environment-variables/)

### External Packages
To use external npm packages, add them to `env_vars_list`:
```yaml
env_vars_list:
  - "NODE_FUNCTION_ALLOW_EXTERNAL: axios,moment,lodash"
```

Multiple packages should be comma-separated without spaces.

## Network Configuration

### Webhooks and API Access
For secure external access to webhooks and the n8n API, we strongly recommend using Cloudflared:

1. Install [Cloudflared addon](https://github.com/racksync/hass-addons-suite)
2. Create a tunnel for port 7123 (webhook/API port)
3. Add the tunnel URL to your configuration:
```yaml
env_vars_list:
  - "WEBHOOK_URL: https://your-tunnel.cloudflare.com"
```

## Override Default Web Interface 

You can override the default web interface via `N8N_EDITOR_BASE_URL` and `N8N_PATH` to forward to a different port or path.

```yaml
env_vars_list:
  - "N8N_EDITOR_BASE_URL: http://YOUR-IP-ADDRESS:5678"
  - "N8N_PATH: /"
``` 

## Workflows and Credentials Migration on First Run

If you want to pre-load workflows and credentials into n8n when the add-on is started for the first time, simply place your files in the following locations **before starting the add-on**:

- Workflows directory: `/config/n8n/workflows/` (for multiple workflow files)
- Credentials directory: `/config/n8n/credentials/` (for multiple credential files)
- Single credentials file: `/config/n8n/creds.json`
- Single workflows file: `/config/n8n/flows.json`

**Don't forget to fill `N8N_ENCRYPTION_KEY` in the addon configuration before starting the add-on**

Example: `N8N_ENCRYPTION_KEY: YOUR_ENCRYPTION_KEY` add space between the key and the value.

**How it works:**
- On the first run, the add-on will automatically import all workflows and credentials found in these directories and/or single files if present.
- This process only happens once, when the add-on is started for the first time (tracked by a marker file at `/media/n8n_import.json`).
- If you add or change files in these locations after the first run, they will **not** be imported automatically. To re-import, you must delete the marker file or reset the add-on's data.

**Steps:**
1. Place your exported workflow and credential files in the appropriate directories or single files above.
2. Start the add-on for the first time.
3. The add-on will log messages about the import process.
4. After import, your workflows and credentials will be available in n8n.

> Tip: For security, make sure to remove sensitive files from these locations after import if you do not want them to persist in plain text.
