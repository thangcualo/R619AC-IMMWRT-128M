#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改主机名字，把OpenWrt-123修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/OpenWrt-R619AC/g' ./package/base-files/files/bin/config_generate

# echo "修改wifi名称"
# sed -i "s/OpenWrt/$wifi_name/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

cp -f patch/rc.local openwrt/package/base-files/files/etc/rc.local
sed '14 iuci\ commit\ network' -i package/emortal/default-settings/files/99-default-settings-chinese
sed '14 iset\ network.globals.packet_steering=1' -i package/emortal/default-settings/files/99-default-settings-chinese
sed '4 iset\ system.@system[0].hostname=NeoBird' -i package/emortal/default-settings/files/99-default-settings-chinese
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate
# Rooter Support untuk modem rakitan
svn co https://github.com/thangcualo/ROOterSource2102/trunk/package/rooter-builds/0protocols/luci-proto-3x package/luci-proto-3x
svn co https://github.com/thangcualo/ROOterSource2102/trunk/package/rooter-builds/0protocols/luci-proto-mbim package/luci-proto-mbim
svn co https://github.com/thangcualo/ROOterSource2102/trunk/package/rooter/0drivers/rmbim package/rmbim
svn co https://github.com/thangcualo/ROOterSource2102/trunk/package/rooter/0drivers/rqmi package/rqmi
svn co https://github.com/thangcualo/ROOterSource2102/trunk/package/rooter/0basicsupport/ext-sms package/ext-sms
svn co https://github.com/thangcualo/ROOterSource2102/trunk/package/rooter/0basicsupport/ext-buttons package/ext-buttons
svn co https://github.com/thangcualo/ROOterSource2102/trunk/package/rooter/ext-rooter-basic package/ext-rooter-basic
# Rooter splash
svn co https://github.com/karnadii/rooter/trunk/package/rooter/0splash/status package/status
svn co https://github.com/karnadii/rooter/trunk/package/rooter/0splash/splash package/splash
svn co https://github.com/karnadii/rooter/trunk/package/rooter/0splash/ext-splashconfig package/ext-splashconfig
svn co https://github.com/karnadii/rooter/trunk/package/rooter/0splash/ext-splash package/ext-splash
# Rooter Bandwith monitor
svn co https://github.com/karnadii/rooter/trunk/package/rooter/0optionalapps/bwallocate package/bwallocate
svn co https://github.com/karnadii/rooter/trunk/package/rooter/0optionalapps/bwmon package/bwmon
svn co https://github.com/karnadii/rooter/trunk/package/rooter/0optionalapps/ext-throttle package/ext-throttle

# disable banner from rooter
sudo chmod -x package/ext-rooter-basic/files/etc/init.d/bannerset
sed -i 's/luci-theme-openwrt-2020/luci-theme-argon/g' package/ext-rooter-basic/Makefile
# Add luci-app-atinout-mod
svn co https://github.com/4IceG/luci-app-atinout-mod/trunk package/luci-app-atinout-mod

# internet detector
svn co https://github.com/gSpotx2f/luci-app-internet-detector/trunk/luci-app-internet-detector package/luci-app-internet-detector
svn co https://github.com/gSpotx2f/luci-app-internet-detector/trunk/internet-detector package/internet-detector
# iStore
svn co https://github.com/linkease/istore-ui/trunk/app-store-ui package/app-store-ui
svn co https://github.com/linkease/istore/trunk/luci package/istore
# Set modemmanager to disable
mkdir -p feeds/luci/protocols/luci-proto-modemmanager/root/etc/uci-defaults
cat << EOF > feeds/luci/protocols/luci-proto-modemmanager/root/etc/uci-defaults/70-modemmanager
[ -f /etc/init.d/modemmanager ] && /etc/init.d/modemmanager disable
exit 0
EOF
