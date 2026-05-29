#!/bin/bash
set -euo pipefail

SOURCE_HASH=$({
  git ls-remote --exit-code --heads "$REPO_URL" "$REPO_BRANCH" ||
  git ls-remote --exit-code --tags "$REPO_URL" "$REPO_BRANCH"
} | awk '{print $1}')

if [[ -z "$SOURCE_HASH" ]]; then
  echo "❌ 无法获取源码哈希值！"
  exit 1
fi

echo "sourceHash=$SOURCE_HASH" >> "$GITHUB_OUTPUT"
echo "✅ 获取成功：$SOURCE_HASH"
