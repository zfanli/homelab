FROM nextcloud:apache

# setup cdn for speed up download
RUN sed -i 's#http://deb.debian.org#https://mirrors.163.com#g' /etc/apt/sources.list

# install supervisor and ffmpeg
RUN apt-get update \
    && apt-get install -y supervisor ffmpeg libmagickcore-6.q16-6-extra ghostscript \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/log/supervisord /var/run/supervisord

# enable preview for pdf files
RUN cat /etc/ImageMagick-6/policy.xml | sed -i \
    's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/' \
    /etc/ImageMagick-6/policy.xml

# copy config file
COPY supervisord.conf /

ENV NEXTCLOUD_UPDATE=1
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
