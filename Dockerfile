FROM python:3.12-slim-bullseye

ARG connectors=all

RUN apt-get -qq update \
    && apt-get -qqy --no-install-recommends install \
        apt-utils \
        alien \
        gnupg \
        libaio1 \
        mbuffer \
        wget \
        tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && pip install -U --no-cache-dir pip

# Add Mongodb ppa
RUN ARCH=$(dpkg --print-architecture) && \
    wget -qO- https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor > /usr/share/keyrings/mongodb-archive-keyring.gpg && \
    echo "deb [ arch=${ARCH} signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" > /etc/apt/sources.list.d/mongodb.list && \
    apt-get -qq update && \
    apt-get -qqy --no-install-recommends install \
        mongodb-database-tools && \
    rm -rf /var/lib/apt/lists/*

# M1-specific steps
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2
# M1-specific steps end...

COPY . /app

RUN cd /app \
    && ./exo_install.sh --connectors=$connectors --acceptlicenses --nousage --notestextras \
    && ln -s /root/.pipelinewise /app/.pipelinewise

ENTRYPOINT ["/app/entrypoint.sh"]
