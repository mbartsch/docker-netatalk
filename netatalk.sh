#!/bin/bash -x
export PATH=$PATH:/netatalk/bin:/netatalk/sbin

if [ ! -z "${AFP_USER}" ]; then
    if [ ! -z "${AFP_UID}" ]; then
        cmd="$cmd --uid ${AFP_UID}"
    fi
    if [ ! -z "${AFP_GID}" ]; then
        cmd="$cmd --gid ${AFP_GID}"
    fi
    adduser $cmd --no-create-home --disabled-password --gecos '' "${AFP_USER}"
    if [ ! -z "${AFP_PASSWORD}" ]; then
        echo "${AFP_USER}:${AFP_PASSWORD}" | chpasswd
    fi
fi

if [ ! -d /media/share ]; then
  mkdir /media/share
  chown "${AFP_USER}" /media/share
  echo "use -v /my/dir/to/share:/media/share" > readme.txt
fi

sed -i'' -e "s,%USER%,${AFP_USER:-},g" /netatalk/etc/afp.conf

echo ---begin-afp.conf--
cat /netatalk/etc/afp.conf
echo ---end---afp.conf--

if [ "${AVAHI}" == "1" ]; then
    rm -rf /var/run/dbus
    rm -rf /var/run/dbus.pid
    rm -rf /var/run/dbus.pid
    rm -rf /var/run/avahi-daemon/pid
    mkdir -p /var/run/dbus
    dbus-daemon --system
    avahi-daemon -D --debug --no-rlimits
else
    echo "Skipping avahi daemon, enable with env variable AVAHI=1"
fi
rm -vf /var/lock/netatalk
exec /netatalk/sbin/netatalk -d -F /netatalk/etc/afp.conf
