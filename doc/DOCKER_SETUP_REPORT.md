# Odoo Docker setup report

## Project analysis

This repository is the Odoo 20.0 server source tree. The version is declared in `../odoo/release.py`; the server entry point is `odoo-bin`. The repository includes Odoo's core addons under `odoo/addons` and the larger standard addon collection under `addons`. Python dependencies are pinned in the root `requirements.txt`. There was no root Dockerfile or Compose stack in the project before this setup.

Odoo needs PostgreSQL for its database and a persistent data directory for uploaded files, sessions, and generated data. The stack therefore uses a separate PostgreSQL 16 service and named volumes for both PostgreSQL and Odoo data. PostgreSQL 16 also meets the minimum declared by this Odoo source tree.

## Files added

- `../Dockerfile` builds the checked-out Odoo source on Python 3.12, installs the pinned Python requirements and native libraries, and includes `wkhtmltopdf` plus fonts for PDF reports.
- `../docker-compose.yml` runs Odoo and PostgreSQL, waits for PostgreSQL health before starting Odoo, exposes the HTTP and gevent/bus ports, and persists both services' data.
- `../docker/odoo.conf` sets the source addon paths, data directory, listener ports, and development-oriented single-process mode.
- `../.env.example` documents the required local secrets and optional host port settings.
- `../.dockerignore` keeps Git metadata, IDE files, local secrets, and generated files out of the build context.

The master password for database management and PostgreSQL password are supplied through Compose environment substitution rather than stored in the Odoo config. The database is only reachable on the internal Compose network; only Odoo ports are published to the host.

## Run locally

```sh
cp .env.example .env
# Edit .env and set unique, long random values for both passwords.
docker compose up --build -d
```

Open <http://localhost:8069> and create the first database. Use `ODOO_MASTER_PASSWORD` from `.env` for database management operations. The gevent endpoint is available on port `8072` for bus/live updates. To view startup output, run `docker compose logs -f odoo`.

Stop the services while keeping data with `docker compose down`. To remove the database and filestore as well, use `docker compose down -v`; this deletes the named volumes.

## Scope and operational notes

This configuration targets local development and evaluation. The Odoo source is copied into the image at build time, so source changes require rebuilding the image. The app runs with `workers = 0` and proxy mode disabled. For a production deployment, use a trusted reverse proxy with TLS, configure proxy mode and worker/resource limits, manage secrets outside a checked-in `.env`, and add backup/restore procedures for both named volumes. Do not expose PostgreSQL directly to the public network.

The root `../requirements.txt` is installed as maintained by this Odoo branch. `wkhtmltopdf` is included for PDF report generation; its rendering behavior can depend on the distribution package and should be checked if pixel-identical reports are required.
