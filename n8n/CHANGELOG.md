# Release 2025.11.2

- MAJOR ARCHITECTURE SIMPLIFICATION: Remove nginx reverse proxy complexity
- Direct n8n access through Home Assistant ingress (no proxy layer)
- Fix ingress connectivity issues with ultra-minimal configuration approach
- Add configurable deprecation warning fixes (SQLite pool, Code Node access, Git security)
- Update version to 2025.11.2 to reflect simplified architecture
- Add new configuration options: db_sqlite_pool_size, n8n_block_env_access_in_node, n8n_git_node_disable_bare_repos
- Improve user interface with better default values (0.0.0.0, 5678)
- Update translations for new configuration options
- Ensure future n8n compatibility with recommended environment variables

# Release 2025.11.1

- Add comprehensive environment variable configuration to add-on interface
- Include n8n_host, n8n_port, n8n_protocol, webhook_url, editor_base_url, path, and metrics options
- Maintain env_vars_list for advanced user overrides
- Update translations for English and Thai languages
- Fix repository.yaml and config.yaml validation errors
- Ensure proper Home Assistant add-on repository listing

# Release 2025.11.0

- Initial stable release with basic n8n functionality
- Support for workflows and credentials import on first run
- Home Assistant ingress integration
- Multi-architecture support (amd64, armhf, armv7, aarch64, i386)
- SSL certificate support
- Webhook and API port configuration

# Release 2025.6.0

- remove `n8n-nightly variant to focus on stable release only.
- simplify workflow and remove dual-variant complexity.
- streamline mono-repo structure to single `n8n/` directory.
- remove build.yaml file completely (use Dockerfile directly).
- use official n8n:stable image declared directly in Dockerfile.
- simplify GitHub Actions workflow to focus on file sync only.
- remove custom container building steps completely.
- add commonly used environment variables to add-on interface for easy configuration.
- include n8n_host, n8n_port, n8n_protocol, webhook_url, editor_base_url, path, and metrics options.
- maintain env_vars_list for advanced user overrides.

# Release 2025.5.3

- add `N8N_EDITOR_BASE_URL` and `N8N_PATH` to override default web interface.
- change import marker file to JSON format.

# Release 2025.5.2

- bulk workflows and credentials migration support (single files and directories).
- add manual encryption key input schema.
- revoke `backup` and `share` permissions as read only.

# Release 2025.5.1

- initial release