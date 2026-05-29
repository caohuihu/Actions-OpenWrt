#!/bin/bash
set -euo pipefail

[ $# -ne 4 ] && { echo "⚠️ 用法: $0 sync/backup 名称 源目录 目标目录"; exit 1; }

MODE=$1 NAME=$2 SRC=$3 DST=$4

sync() {
  [ -d "$SRC" ] || { echo "⚠️ $NAME 不存在，跳过"; return; }
  [ -z "$(ls -A "$SRC" 2>/dev/null)" ] && { echo "⚠️ $NAME 为空，跳过"; return; }
  mkdir -p "$DST"
  rsync -a --delete "$SRC"/ "$DST"/
  echo "✅ $NAME 同步完成"
}

backup() {
  [ -d "$SRC" ] || { echo "❌ $NAME 不存在，备份失败"; exit 1; }
  rm -rf "$DST"/*
  mkdir -p "$DST"
  rsync -a --delete "$SRC"/ "$DST"/
  echo "✅ $NAME 备份完成"
}

case "$MODE" in
  sync) sync ;;
  backup) backup ;;
  *) echo "❌ 模式错误"; exit 1 ;;
esac
