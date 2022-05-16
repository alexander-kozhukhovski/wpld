# WPLD - WordPress Local Development

Simple docker compose solution for local development.

## Info

- PHP 7.4

## Tools

- Traefik
- phpMyAdmin
- Composer
- MailHog
- WP-CLI

## Requirements

- mkcert
- Docker & Docker Compose
- Bash or WSL

## Install and start WordPress

1. Create your own `.env` from `.env-example`
2. Create certificates `make install-certs`
3. Download and run WordPress `make install-wp`
4. Continue with WordPress Core installation `make install-core`

## Available commands

```bash
install-certs              Install certificates for the project
install-wp                 Start default WordPress Docker configuration
install-core               Install WordPress Core
status                     Show docker status
logs                       Show docker logs
stop                       Stop docker project
stop-clean                 Stop docker project, remove containers, volumes and network
start                      Start docker project
restart                    Restart docker project
uninstall                  Uninstall docker project
rebuild                    Rebuild docker project
wpcli                      Run WP-CLI commands. Put wpcli parameters into $args, e.g. make wpcli args='plugin list --status="active"'
wpcli                      Run Composer commands
mysql-backup               Backup MySQL Database
mysql-restore              Restore MySQL Database from file, e.g. make mysql-restore mysql-2021-04-02.sql.gz
help                       Generate command list
```
