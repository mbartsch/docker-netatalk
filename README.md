Netatalk Container


To run this container use

docker run -v /my/config/for/netatalk/etc:/netatalk/etc mbartsch/netatalk:3.1.10.1

to use AVAHI on the container, needed for timemachine use

docker run -e AVAHI=1 -v /my/config/for/netatalk/etc:/netatalk/etc mbartsch/netatalk:3.1.10.1
