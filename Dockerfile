# Candidate image for the exact local Odoo checkout. This is not a production
# release until the business approves an Odoo release line and addon set.
FROM python:3.12-slim-bookworm@sha256:6a0e06f5ba0b373d051aabd3fffb9b873f27f9a2a3a14bcbe37dee6f0e3bbc70 AS python-deps

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        libffi-dev \
        libfreetype6-dev \
        libfribidi-dev \
        libharfbuzz-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        liblcms2-dev \
        libmagic-dev \
        libopenjp2-7-dev \
        libpq-dev \
        libsasl2-dev \
        libssl-dev \
        libtiff-dev \
        libwebp-dev \
        libxcb1-dev \
        libxml2-dev \
        libxslt1-dev \
        pkg-config \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY requirements.txt constraints-voigt.txt ./
RUN python -m pip install --prefix=/python-deps -r requirements.txt -c constraints-voigt.txt

FROM python:3.12-slim-bookworm@sha256:6a0e06f5ba0b373d051aabd3fffb9b873f27f9a2a3a14bcbe37dee6f0e3bbc70

ARG ODOO_SOURCE_REV=local-uncommitted
LABEL org.opencontainers.image.title="Voigt ERP Odoo candidate" \
      org.opencontainers.image.source="https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo" \
      org.opencontainers.image.revision="$ODOO_SOURCE_REV"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/opt/python-deps/lib/python3.12/site-packages \
    HOME=/var/lib/odoo \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        fonts-dejavu-core \
        fonts-freefont-ttf \
        fonts-liberation \
        fonts-noto-core \
        libffi8 \
        libfreetype6 \
        libfribidi0 \
        libharfbuzz0b \
        libjpeg62-turbo \
        libldap-2.5-0 \
        liblcms2-2 \
        libmagic1 \
        libopenjp2-7 \
        libpq5 \
        libsasl2-2 \
        libssl3 \
        libtiff6 \
        libwebp7 \
        libxcb1 \
        libxml2 \
        libxslt1.1 \
        wkhtmltopdf \
        zlib1g \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 10001 odoo \
    && useradd --uid 10001 --gid 10001 --home-dir /var/lib/odoo --create-home --shell /usr/sbin/nologin odoo

COPY --from=python-deps /python-deps/ /opt/python-deps/
WORKDIR /opt/odoo
COPY --chown=odoo:odoo . /opt/odoo/
COPY --chmod=0755 docker/odoo-entrypoint.sh /usr/local/bin/odoo-entrypoint

RUN mkdir -p /var/lib/odoo \
    && chown -R odoo:odoo /var/lib/odoo

USER 10001:10001
EXPOSE 8069
VOLUME ["/var/lib/odoo"]
ENTRYPOINT ["/usr/local/bin/odoo-entrypoint"]
CMD []
