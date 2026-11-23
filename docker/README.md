# Voigt Odoo container candidate

This repository currently tracks Odoo `master` (version 20.0 in the checked out commit). No approved release line or Voigt-specific addon list was present in the referenced TASK-06.1. The image is therefore a validation candidate pinned to the local source commit, not an approved production release.

The image uses a digest-pinned Python 3.12 Debian base, the repository's Python requirements plus a constraints file, a non-root runtime user (`10001`), and the Odoo source already in this checkout. No external addons are added implicitly. `lxml` is pinned to 6.1.3 for Python 3.12 because the pinned `lxml-html-clean` release requires it; this differs from the upstream Noble pin and needs project compatibility tests before production.

Build locally from the repository root:

```bash
docker build --tag voigt-odoo-candidate:local \
  --build-arg ODOO_SOURCE_REV="$(git rev-parse HEAD)" .
```

`constraints-voigt.txt` freezes the resolved Python 3.12 dependency set, including transitive packages. Refresh and review that lock whenever `requirements.txt` or the Python runtime changes; do not let pip resolve floating transitive versions during a deployment build.

The runtime expects `HOST`, `PORT`, `USER`, `PASSWORD`, and `ADMIN_PASSWD` from a secret. The entrypoint maps the PostgreSQL variables to `PGHOST`, `PGPORT`, `PGUSER`, and `PGPASSWORD`; it writes the database-manager master password to a mode-0600 temporary Odoo config file, then starts `odoo-bin` on `0.0.0.0:8069`. Mount `/var/lib/odoo` on persistent storage. Kubernetes must provide writable volume ownership to UID/GID 10001.

The image build was smoke-tested against a temporary PostgreSQL 16 container: Odoo initialized the `base` module, then served `/web/login` with HTTP 200. This does not replace the STORY-06 test suite, vulnerability scans, production PDF validation, backup/restore testing, or approval of the Odoo release and addons.
