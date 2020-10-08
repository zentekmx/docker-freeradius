FROM alpine:3.12.0

MAINTAINER Marco A Rojas <marco.rojas@zentek.com.mx>

# Use make build push

RUN apk --update add freeradius freeradius-mysql freeradius-eap openssl mysql-client tzdata

EXPOSE 1812/udp 1813/udp

ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_USER=radius
ENV DB_PASS=radpass
ENV DB_NAME=radius
ENV RADIUS_KEY=testing123
ENV RAD_CLIENTS=172.16.0.0/16
ENV RAD_DEBUG=yes
ENV TIMEOUT=60
ENV TZ=America/Mexico_City

ADD --chown=root:radius ./etc/raddb/ /etc/raddb
RUN /etc/raddb/certs/bootstrap && \
    chown -R root:radius /etc/raddb/certs && \
    chmod 640 /etc/raddb/certs/*.pem && \
    install -d -m 0755 -o radius -g radius -p /var/run/radiusd/


ADD ./scripts/start.sh /start.sh
ADD ./scripts/wait-for.sh /wait-for.sh
ADD ./scripts/testusers.sql /testusers.sql

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo "$TZ" > /etc/timezone

RUN chmod +x /start.sh wait-for.sh

CMD ["/start.sh"]
