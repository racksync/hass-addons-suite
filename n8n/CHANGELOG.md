# Release 2025.6.0

- remove `n8n-nightly` variant to focus on stable release only.
- simplify workflow and remove dual-variant complexity.
- streamline mono-repo structure to single `n8n/` directory.
- remove build.yaml file completely (use Dockerfile directly).
- use official n8n:stable image declared directly in Dockerfile.
- simplify GitHub Actions workflow to focus on file sync only.
- remove custom container building steps completely.

# Release 2025.5.3

- add `N8N_EDITOR_BASE_URL` and `N8N_PATH` to override default web interface.
- change import marker file to JSON format.

# Release 2025.5.2

- bulk workflows and credentials migration support (single files and directories).
- add manual encryption key input schema.
- revoke `backup` and `share` permissions as read only.

# Release 2025.5.1

- initial release