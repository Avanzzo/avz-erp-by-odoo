#!/bin/sh
set -eu

export PGHOST="${PGHOST:-${HOST:-}}"
export PGPORT="${PGPORT:-${PORT:-5432}}"
export PGUSER="${PGUSER:-${USER:-}}"
export PGPASSWORD="${PGPASSWORD:-${PASSWORD:-}}"

: "${PGHOST:?Set HOST or PGHOST to the PostgreSQL endpoint}"
: "${PGUSER:?Set USER or PGUSER to the PostgreSQL username}"
: "${PGPASSWORD:?Set PASSWORD or PGPASSWORD to the PostgreSQL password}"
: "${ADMIN_PASSWD:?Set ADMIN_PASSWD from a secret to protect Odoo database management}"

umask 077
printf '[options]\nadmin_passwd = %s\n' "$ADMIN_PASSWD" >/tmp/odoo.conf
export ODOO_RC=/tmp/odoo.conf

exec python /opt/odoo/odoo-bin \
    --http-interface=0.0.0.0 \
    --data-dir=/var/lib/odoo \
    "$@"
