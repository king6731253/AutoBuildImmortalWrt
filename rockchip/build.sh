#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."


# 定义所需安装的包列表 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filebrowser-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"

# Tadaye 添加的软件包
PACKAGES="$PACKAGES luci-app-frpc"
PACKAGES="$PACKAGES luci-app-frps"
PACKAGES="$PACKAGES luci-i18n-frpc-zh-cn"
PACKAGES="$PACKAGES luci-i18n-frpc-zh-tw"
PACKAGES="$PACKAGES luci-i18n-frps-zh-cn"
PACKAGES="$PACKAGES luci-i18n-frps-zh-tw"
PACKAGES="$PACKAGES luci-app-unblockneteasemusic"
PACKAGES="$PACKAGES luci-app-acme"
PACKAGES="$PACKAGES luci-app-adblock"
PACKAGES="$PACKAGES luci-app-advanced-reboot"
PACKAGES="$PACKAGES luci-app-airplay2"
PACKAGES="$PACKAGES luci-app-alist"
PACKAGES="$PACKAGES luci-app-aria2"
PACKAGES="$PACKAGES luci-app-autoreboot"
PACKAGES="$PACKAGES luci-app-cifs-mount"
PACKAGES="$PACKAGES luci-app-cloudflared"
PACKAGES="$PACKAGES luci-i18n-cloudflared-zh-cn"
PACKAGES="$PACKAGES luci-app-commands"
PACKAGES="$PACKAGES luci-app-cpufreq"
PACKAGES="$PACKAGES luci-app-ddns-go"
PACKAGES="$PACKAGES luci-app-ddns"
PACKAGES="$PACKAGES luci-app-https-dns-proxy"
PACKAGES="$PACKAGES luci-app-ipsec-vpnd"
PACKAGES="$PACKAGES luci-app-kcptun"
PACKAGES="$PACKAGES luci-app-keepalived"
PACKAGES="$PACKAGES luci-app-ksmbd"
PACKAGES="$PACKAGES luci-app-ledtrig-rssi"
PACKAGES="$PACKAGES luci-app-ledtrig-switch"
PACKAGES="$PACKAGES luci-app-ledtrig-usbport"
PACKAGES="$PACKAGES luci-app-lxc"
PACKAGES="$PACKAGES luci-app-nfs"
PACKAGES="$PACKAGES luci-app-nft-qos"
PACKAGES="$PACKAGES luci-app-ngrokc"
PACKAGES="$PACKAGES luci-app-openvpn-server"
PACKAGES="$PACKAGES luci-app-openvpn"
PACKAGES="$PACKAGES luci-app-p910nd"
PACKAGES="$PACKAGES luci-app-passwall"
PACKAGES="$PACKAGES luci-app-qos"
PACKAGES="$PACKAGES luci-app-pppoe-relay"
PACKAGES="$PACKAGES luci-app-pppoe-server"
PACKAGES="$PACKAGES luci-app-privoxy"
PACKAGES="$PACKAGES luci-app-ps3netsrv"
PACKAGES="$PACKAGES luci-app-samba4"
PACKAGES="$PACKAGES luci-app-softethervpn"
PACKAGES="$PACKAGES luci-app-ttyd"
PACKAGES="$PACKAGES luci-app-udpxy"
PACKAGES="$PACKAGES luci-app-uhttpd"
PACKAGES="$PACKAGES luci-app-upnp"
PACKAGES="$PACKAGES luci-app-usb-printer"
PACKAGES="$PACKAGES luci-app-usb3disable"
PACKAGES="$PACKAGES luci-app-v2raya"
PACKAGES="$PACKAGES luci-app-vnstat2"
PACKAGES="$PACKAGES luci-app-vsftpd"
PACKAGES="$PACKAGES luci-app-zerotier"
PACKAGES="$PACKAGES luci-i18n-dashboard-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ddns-go-zh-cn"
PACKAGES="$PACKAGES luci-i18n-hd-idle-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ksmbd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-lxc-zh-cn"
PACKAGES="$PACKAGES luci-i18n-upnp-zh-cn"
PACKAGES="$PACKAGES luci-i18n-usb-printer-zh-cn"
PACKAGES="$PACKAGES luci-i18n-usb3disable-zh-cn"
PACKAGES="$PACKAGES luci-i18n-v2raya-zh-cn"
PACKAGES="$PACKAGES luci-i18n-vnstat2-zh-cn"
PACKAGES="$PACKAGES luci-i18n-watchcat-zh-cn"
PACKAGES="$PACKAGES luci-app-watchcat"
PACKAGES="$PACKAGES luci-i18n-zerotier-zh-cn"
PACKAGES="$PACKAGES luci-mod-dashboard"

# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
