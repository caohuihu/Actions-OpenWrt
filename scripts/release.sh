#!/bin/bash
set -euo pipefail

VERSION_PREFIX="${VERSION_PREFIX:-v2.0}"
NEXT_NUM=$(gh release list | awk -v p="$VERSION_PREFIX" '$0~p{print $1}' | sort -Vr | head -n1 | grep -oE '[0-9]+$' || echo 0)
RELEASE_TAG="${VERSION_PREFIX}.$((NEXT_NUM + 1))"

echo "release_tag=${RELEASE_TAG}" >> "$GITHUB_OUTPUT"
echo "status=success" >> "$GITHUB_OUTPUT"

echo "============================================="
echo "发布核心固件到Release"
echo "版本标签：$RELEASE_TAG"
echo "固件目录：$FIRMWARE"
echo "说明文件：$RELEASE_NOTES"
echo "============================================="

if ! gh release view "$RELEASE_TAG" >/dev/null 2>&1; then
  echo -e "\n🔄 创建新版本标签..."
  gh release create "$RELEASE_TAG" \
    --title "$RELEASE_TAG" \
    --notes-file "$RELEASE_NOTES"
else
  echo -e "\n⚠️ 版本标签已存在，跳过创建"
fi

echo -e "\n🔄 上传核心固件中 ..."
gh release upload "$RELEASE_TAG" \
  "${FIRMWARE}"/* \
  --clobber

echo -e "\n✅ 核心固件上传完成！"
