FROM alpine:latest AS builder
MAINTAINER Marcelo Bartsch <spam-mb+github@bartsch.cl>
VOLUME ["/netatalk/var", "/netatalk/etc"]

RUN apk add  --no-cache make gcc g++ dbus-glib dbus-glib-dev openssl openssl-dev avahi db dbus curl db-dev bzip2 avahi-dev dbus-dev file bash dbus avahi acl libacl acl-dev py-dbus libgcrypt-dev libgcrypt 
RUN curl -L "http://prdownloads.sourceforge.net/netatalk/netatalk-3.1.11.tar.bz2?download" | bunzip2 -c - | tar -x -f - -C /tmp 
WORKDIR /tmp/netatalk-3.1.11
RUN ./configure --prefix=/netatalk  --with-acls --enable-zeroconf --enable-dbus  && make && make install 

FROM alpine:latest
WORKDIR /
RUN apk add --no-cache dbus-glib openssl dbus libacl libgcrypt avahi bash
COPY netatalk.sh /
COPY --from=builder /netatalk /netatalk
COPY afp.conf /netatalk/etc/afp.conf
RUN chmod +x /netatalk.sh && rm -f /etc/avahi/services/*
ENTRYPOINT [ "/netatalk.sh" ]
EXPOSE "548/tcp"  "5353/udp"
HEALTHCHECK CMD /netatalk/bin/afpstats
