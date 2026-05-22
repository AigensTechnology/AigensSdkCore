#!/bin/sh

# 启用更严格的错误处理
set -e

echo "正在清除 Swift Package Manager (SPM) 缓存..."

# 1. 删除全局 SPM 缓存
SPM_CACHE_DIR="$HOME/Library/Caches/org.swift.swiftpm"
if [ -d "$SPM_CACHE_DIR" ]; then
    echo "正在删除 SPM 全局缓存: $SPM_CACHE_DIR"
    rm -rf "$SPM_CACHE_DIR"
else
    echo "SPM 全局缓存目录未找到。"
fi

# 2. 删除 Xcode 的 DerivedData
DERIVED_DATA_DIR="$HOME/Library/Developer/Xcode/DerivedData"
if [ -d "$DERIVED_DATA_DIR" ]; then
    echo "正在删除 Xcode DerivedData: $DERIVED_DATA_DIR"
    rm -rf "$DERIVED_DATA_DIR"
else
    echo "Xcode DerivedData 目录未找到。"
fi

echo "✅ SPM 缓存已成功清除！"
echo "下次 Xcode 打开项目时，将会重新解析和下载所有包依赖。"
