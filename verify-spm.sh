#!/bin/bash

# =====================================================
# Aigens SDK - SPM 验证脚本
# =====================================================
# 用于验证 Package.swift 文件是否正确配置
# =====================================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Aigens SDK - SPM 验证脚本${NC}"
echo -e "${GREEN}========================================${NC}"

# 检查 Swift 是否安装
if ! command -v swift &> /dev/null; then
    echo -e "${RED}错误: Swift 未安装${NC}"
    exit 1
fi

echo -e "${YELLOW}Swift 版本:${NC}"
swift --version
echo ""

# 验证根目录的 Package.swift
echo -e "${GREEN}----------------------------------------${NC}"
echo -e "${GREEN}验证 Aigens SDK Package.swift${NC}"
echo -e "${GREEN}----------------------------------------${NC}"

if [ -f "Package.swift" ]; then
    echo -e "${GREEN}✓ Package.swift 存在${NC}"
    if swift package describe > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Package.swift 配置正确${NC}"
        echo -e "\n${YELLOW}包信息:${NC}"
        swift package describe
    else
        echo -e "${RED}✗ Package.swift 配置有误${NC}"
        echo -e "${YELLOW}尝试解析错误...${NC}"
        swift package describe 2>&1 || true
    fi
else
    echo -e "${RED}✗ Package.swift 不存在${NC}"
fi

echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}验证完成！${NC}"
echo -e "${GREEN}========================================${NC}"
