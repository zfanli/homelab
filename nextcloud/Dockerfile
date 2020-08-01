FROM nextcloud:apache

# setup cdn for speed up download
RUN sed -i 's#http://deb.debian.org#https://mirrors.163.com#g' /etc/apt/sources.listtou

RUN apt-get update \
    && apt-get install -y supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/log/supervisord /var/run/supervisord

COPY supervisord.conf /
ENV NEXTCLOUD_UPDATE=1
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
