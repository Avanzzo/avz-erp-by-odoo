FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        fonts-dejavu-core \
        fonts-liberation \
        libffi-dev \
        libjpeg-dev \
        libldap2-dev \
        libmagic1 \
        libpq-dev \
        libsasl2-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        postgresql-client \
        wkhtmltopdf \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/odoo
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN pip install --no-cache-dir --no-deps --editable . \
    && groupadd --system --gid 10001 odoo \
    && useradd --system --uid 10001 --gid odoo --home-dir /var/lib/odoo --create-home odoo \
    && mkdir -p /var/lib/odoo \
    && chown -R odoo:odoo /var/lib/odoo

USER odoo
EXPOSE 8069 8072
ENTRYPOINT ["python3", "/opt/odoo/odoo-bin"]
CMD ["--config=/etc/odoo/odoo.conf"]
