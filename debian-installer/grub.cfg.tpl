set menu_color_normal=cyan/blue
set menu_color_highlight=white/blue
set menu_color_highlight=black/light-gray

insmod gzio
insmod part_gpt
insmod ext2
insmod gfxmenu
insmod png
export theme

set default=0
set timeout=10
set is_preload=false

menuentry 'Start Kylin diskless'{
    set backgroud_color=black
    set gfxpayload=keep
    echo 'Start Kylin diskless Please wait ...'
    linux /debian-installer/arm64/kylin/vmlinuz console=tty boot=casper ethdevice-timeout=120 ip=dhcp netboot=nfs nfsroot=${HOST_IP}:${NFS_BASE_PATH}/data components union=overlay locales=zh_CN.UTF-8 livecd-installer --
    #linux /debian-installer/arm64/kylin/vmlinuz boot=casper netboot=nfs nfsroot=${HOST_IP}:${NFS_BASE_PATH}/data quiet splash ip=dhcp audit=0 live
    initrd /debian-installer/arm64/kylin/initrd.lz
}
