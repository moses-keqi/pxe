FROM alpine:3.20.0
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.nju.edu.cn/g' /etc/apk/repositories && apk update && apk upgrade
RUN  mkdir -p /var/lib/tftpboot
COPY etc/dnsmasq.conf.tpl /etc/dnsmasq.conf.tpl
COPY etc/dnsmasq_hosts /etc/dnsmasq_hosts
COPY etc/resolv.dnsmasq.conf.tpl /etc/resolv.dnsmasq.conf.tpl
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY webproc_0.4.0_linux_arm64.gz /opt/webproc_0.4.0_linux_arm64.gz
ADD debian-installer /var/lib/tftpboot/

# dnsmasq dns
# busybox-extras telnet
# netcat-openbsd (UDP nc cmd  le: nc -vu 192.168.0.180 [53 67 68 69])
# socat (UDP  le: socat - UDP:192.168.0.180:69)
# netstat -naltup
RUN apk update \
        && apk --no-cache add dnsmasq \
        && apk add bash busybox-extras  netcat-openbsd socat gettext tar curl \
        && apk add --no-cache --virtual .build-deps  \
        && gzip -d -c /opt/webproc_0.4.0_linux_arm64.gz  > /usr/local/bin/webproc \
        && chmod +x /usr/local/bin/webproc \
        && chmod +x /usr/local/bin/entrypoint.sh \
        && cd /var/lib/tftpboot/ && tar -zxvf netboot.tar.gz && rm -r netboot.tar.gz \
        && apk del .build-deps

RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq

RUN echo -e "nameserver 127.0.0.1 \n search pxe.svc.cluster.local svc.cluster.local cluster.local fritz.box \n options ndots:5" > /etc/resolv.conf

ENV  DNS_INTERFACE=eth0 HTTP_USER=admin HTTP_PASS=qsx123!@

EXPOSE 67/udp
EXPOSE 68/udp
EXPOSE 69/udp
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 8080/tcp

#run!
#ENTRYPOINT ["webproc","--config","/etc/dnsmasq.conf","--","dnsmasq", "--no-daemon"]
ENTRYPOINT ["webproc","-c","/etc/dnsmasq.conf"]
CMD ["entrypoint.sh"]


# docker build -t moese/alpine-pxe:20240806001 .


# docker build -t moese/alpine-pxe:20241030001 .

