FROM python:3.10-alpine

# Install python-lxml
RUN apk add --no-cache --virtual .build-deps \
    gcc musl-dev \
    libxslt-dev libxml2-dev &&\
    pip install lxml && \
    apk del .build-deps && \
    apk add --no-cache libxslt libxml2

RUN mkdir -p /src
COPY . /src

RUN cd /src && \
    python3 ./setup.py install

RUN echo "$(( $RANDOM % 59 + 0 )) */2 * * * withings-sync" >> /var/spool/cron/crontabs/root

ENTRYPOINT ["crond", "-f", "-l", "4", "-L", "/dev/stdout"]
