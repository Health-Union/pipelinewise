FROM python:3.9-slim-buster

ARG connectors=all

RUN apt-get -qq update \
    && apt-get -qqy --no-install-recommends install \
    apt-utils \
    alien \
    gnupg \
    libaio1 \
    mbuffer \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && pip install -U --no-cache-dir pip

RUN apt-get -qq update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential && \
    apt-get install -y git

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
