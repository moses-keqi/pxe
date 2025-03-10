#!/bin/sh
echo "Running dnsmasq --no-daemon $CMDLINE"
export IP_DELIMITER=`echo "${HOST_IP}" | awk -F "." '{print $1"."$2"."$3}'`
echo  "$IP_DELIMITER"
rm -rf /var/lib/tftpboot/debian-installer/arm64/grub/grub.cfg
envsubst < /var/lib/tftpboot/grub.cfg.tpl > /var/lib/tftpboot/debian-installer/arm64/grub/grub.cfg
envsubst < /etc/dnsmasq.conf.tpl > /etc/dnsmasq.conf
envsubst < /etc/resolv.dnsmasq.conf.tpl > /etc/resolv.dnsmasq.conf

dnsmasq --no-daemon $CMDLINE
