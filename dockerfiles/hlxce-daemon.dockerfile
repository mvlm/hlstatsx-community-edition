FROM alpine:3.11.5

ENV DB_NAME=hlxce \
    DB_USERNAME=hlxce \
    DB_PASSWORD=hlxce \
    DB_HOST=db

WORKDIR /home/hlxce/

RUN set -x \
    && apk add --no-cache \
        perl \
        perl-utils \
        bash \
        su-exec \
        perl-dbd-mysql \
        perl-dbi \
        dcron \
        curl \
    && addgroup -S hlxce \
    && adduser -S -h /home/hlxce/ -s /bin/bash -g hlxce hlxce \
    && rm -rf /var/cache/apk/*

COPY dockerfiles/docker-hlxce-daemon-entrypoint /usr/local/bin/
COPY scripts .

RUN chmod +x /usr/local/bin/docker-hlxce-daemon-entrypoint \
    && chmod +x hlstats-awards.pl hlstats.pl hlstats-resolve.pl run_hlstats \
    && echo $'*/5 * * * * cd /home/hlxce/ && su-exec hlxce ./run_hlstats start >/dev/null 2>&1' >> /root/daemon.txt \
    && echo $'15 00 * * * cd /home/hlxce/ && su-exec hlxce ./hlstats-awards.pl >/dev/null 2>&1\n' >> /root/daemon.txt \
    && chown hlxce:hlxce -R .

EXPOSE 27500/udp

ENTRYPOINT ["docker-hlxce-daemon-entrypoint"]

CMD ["crond", "-l", "2", "-f"]
