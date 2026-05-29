#!/bin/bash
#
# 文件名字: Part1_Feeds.sh
# 文件说明: 添加软件源 (更新软件源之前执行)
# 使用说明: 把对应注释 "#" 去掉即可启用功能，按需修改或添加参数
#
# Copyright (c) 2026 frostcypress
#

# 清空原有软件源配置（彻底清空）
> feeds.conf.default

# 第三方插件源
#cat >> feeds.conf.default << EOF
#src-git helloworld https://github.com/fw876/helloworld.git
#EOF

# LEDE (20251001)
cat >> feeds.conf.default << EOF
src-git packages https://github.com/coolsnowwolf/packages
src-git luci https://github.com/coolsnowwolf/luci.git;openwrt-23.05
src-git routing https://github.com/coolsnowwolf/routing
src-git telephony https://github.com/coolsnowwolf/telephony.git
EOF

# immortalwrt (openwrt-24.10)
#cat >> feeds.conf.default << EOF
#src-git packages https://github.com/immortalwrt/packages.git;openwrt-24.10
#src-git luci https://github.com/immortalwrt/luci.git;openwrt-24.10
#src-git routing https://github.com/openwrt/routing.git;openwrt-24.10
#src-git telephony https://github.com/openwrt/telephony.git;openwrt-24.10
#EOF
