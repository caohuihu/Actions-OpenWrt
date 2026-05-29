#!/bin/bash
#
# 文件名字: Part2_Custom.sh
# 文件说明: 固件自定义配置脚本 (更新软件源之后执行)
# 使用说明: 使用说明: 把对应注释 "#" 去掉即可启用功能，按需修改或添加参数
#
# Copyright (c) 2026 frostcypress
#

# 文件路径
CFG_PATH_1=$(find package/base-files -name "config_generate" -type f)
CFG_PATH_2=package/base-files/files/etc/shadow

# 清理旧配置
sed -i '/vlmcsd/d' .config
sed -i '/CCACHE/d' .config
# 开启和指定缓存路径（默认）
echo "CONFIG_CCACHE=y" >> .config
echo "CONFIG_CCACHE_DIR=\"/workdir/openwrt/.ccache\"" >> .config

# 修改登录IP
NEW_IP="192.168.2.10"
# 修改登录密码
NEW_PASSWORD="123456"
# 执行IP、登录密码配置代码
sed -i "s/192\.168\.[0-9]\+\.[0-9]\+/$NEW_IP/g" $CFG_PATH_1
CRYPT_PASSWORD=$(openssl passwd -1 "$NEW_PASSWORD")
sed -i "s|^root:[^:]*:|root:$CRYPT_PASSWORD:|" $CFG_PATH_2

echo "⚠️ 配置完成，正在验证..."
grep -E 'CCACHE|vlmcsd' .config
grep -E 'root' $CFG_PATH_2
grep -E "ipaddr" $CFG_PATH_1
