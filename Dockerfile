# https://github.com/letsencrypt/letsencrypt/pull/431#issuecomment-103659297
# it is more likely developers will already have ubuntu:trusty rather
# than e.g. debian:jessie and image size differences are negligible
FROM alpine:latest
MAINTAINER Marcelo Bartsch <spam-mb+github@bartsch.cl>

RUN apk update && apk add make gcc g++ dbus-glib dbus-glib-dev openssl openssl-dev avahi db dbus curl db-dev bzip2 avahi-dev dbus-dev file bash dbus avahi acl libacl acl-dev && curl -L "http://prdownloads.sourceforge.net/netatalk/netatalk-3.1.10.tar.bz2?download" | bunzip2 -c - | tar -x -f - -C /tmp && cd /tmp/netatalk-3.1.10 && ./configure --prefix=/netatalk  --with-acls --enable-zeroconf --enable-dbus  && echo '#define O_IGNORE 0' >> config.h && make && make install && apk del make gcc g++ openssl-dev db-dev avahi-dev dbus-dev acl-dev && rm -rf /tmp/netatalk-3.1.10 && cp /netatalk/etc/dbus-1/system.d/* /usr/share/dbus-1/system.d/
VOLUME [ "/netatalk/etc" ]
COPY netatalk.sh /
COPY afp.conf /netatalk/etc/afp.conf
RUN chmod +x /netatalk.sh
ENTRYPOINT [ "/netatalk.sh" ]
