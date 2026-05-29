#!/bin/bash
set -euo pipefail

#配置项（未传参时使用默认值）
KEEP_LATEST="${KEEP_LATEST:-3}"
KEEP_DAYS="${KEEP_DAYS:-7}"
CLEAN_TYPE="${CLEAN_TYPE:-}"

# 变量合法性检查
if [[ ! "$KEEP_LATEST" =~ ^[0-9]+$ || ! "$KEEP_DAYS" =~ ^[0-9]+$ ]]; then
  echo "❌ KEEP_LATEST 和 KEEP_DAYS 必须是纯数字"
  exit 1
fi

# 清理旧Workflows运行记录
if [[ "${CLEAN_TYPE}" == "workflow" ]]; then
  echo
  echo "保留最新条数：$KEEP_LATEST 条"
  echo "保留最近天数：$KEEP_DAYS 天"

  echo -e "📅 清理超时记录..."
  gh run list --limit 1000 --json databaseId,createdAt -q '.[] | [.databaseId, .createdAt] | @tsv' | while read -r id createdAt; do  
    [ -z "$id" ] && continue
    if [[ $(date -d "$createdAt" +%s) -lt $(date -d "-${KEEP_DAYS} days" +%s) ]]; then
      echo "⚠️ 删除记录：$id"
      gh run delete "$id" || echo "❌ 删除失败跳过"
    fi
  done

  echo -e "🔄 清理超量记录..."
  gh run list --limit 1000 --json databaseId -q ".[${KEEP_LATEST}:] | .[].databaseId" | while read -r id; do
    [ -n "$id" ] || continue
    echo "⚠️ 删除记录：$id"
    gh run delete "$id" || echo "❌ 删除失败跳过"
  done
fi

# 清理旧Releases和Tags
if [[ "${CLEAN_TYPE}" == "release" ]]; then
  echo
  echo "保留最新版本：$KEEP_LATEST 个"
  echo "保留最近天数：$KEEP_DAYS 天"

  echo -e "📅 清理超时版本..."
  gh release list --json tagName,publishedAt -q '.[] | [.tagName, .publishedAt] | @tsv' | while read -r tag pubTime; do
    [ -z "$tag" ] && continue
    if [[ $(date -d "$pubTime" +%s) -lt $(date -d "-${KEEP_DAYS} days" +%s) ]]; then
      echo "⚠️ 删除版本：$tag"
      gh release delete "$tag" --yes || true
      git push origin --delete "$tag" || true
    fi
  done

  echo -e "🔄 清理超量版本..."
  gh release list --json tagName -q ".[${KEEP_LATEST}:] | .[].tagName" | while read -r tag; do
    [ -z "$tag" ] && continue
    echo "⚠️ 删除版本：$tag"
    gh release delete "$tag" --yes || true
    git push origin --delete "$tag" || true
  done
fi

# 清理旧Cache缓存记录
if [[ "${CLEAN_TYPE}" == "cache" ]]; then
  echo
  echo "保留最新缓存条数：$KEEP_LATEST 条"
  echo "保留缓存时长：$KEEP_DAYS 天"

  echo -e "📅 清理过期缓存..."
  gh cache list --json id,createdAt --jq '.[] | [.id, .createdAt] | @tsv' | while read -r id createdAt; do
    [ -z "$id" ] && continue
    if [[ $(date -d "$createdAt" +%s) -lt $(date -d "-${KEEP_DAYS} days" +%s) ]]; then
      echo "⚠️ 删除缓存：$id"
      gh cache delete "$id" || echo "❌ 删除失败跳过"
    fi
  done

  echo -e "🔄 清理超量缓存..."
  gh cache list --json id --jq ".[${KEEP_LATEST}:] | .[].id" | while read -r id; do
    [ -n "$id" ] || continue
    echo "⚠️ 删除缓存：$id"
    gh cache delete "$id" || echo "❌ 删除失败跳过"
  done
fi
