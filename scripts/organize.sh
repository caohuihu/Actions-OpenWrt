#!/bin/bash
set -euo pipefail

cd openwrt/bin/targets/*/* || exit 1

for f in openwrt-*.img*; do
  [ -f "$f" ] && mv "$f" "${SOURCE_NAME}-${f#openwrt-}"
done

KEEP_ARGS=()
for ext in $KEEP_EXTS; do
  KEEP_ARGS+=(! -name "*$ext")
done

find . -type f "${KEEP_ARGS[@]}" -delete

rm -rf packages

echo -e "\n✅ 最终保留文件："
ls -lh

echo "FIRMWARE=$PWD" >> $GITHUB_ENV
echo "status=success" >> $GITHUB_OUTPUT
