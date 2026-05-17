#!/bin/bash

# ============================================================================
# 自动化添加 SPM 包到 Flutter iOS 项目
# 注意：此脚本使用 Xcode CLI 工具，需要先安装 Xcode Command Line Tools
# ============================================================================

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$1"
PACKAGE_URL="$2"
PACKAGE_VERSION="$3"

if [ -z "$PROJECT_DIR" ] || [ -z "$PACKAGE_URL" ]; then
    echo -e "${YELLOW}用法:${NC}"
    echo -e "  $0 <项目路径> <包URL> [版本号]"
    echo -e ""
    echo -e "${YELLOW}示例:${NC}"
    echo -e "  # 本地路径"
    echo -e "  $0 ./flutter_example/ios ../aigens_sdk_core"
    echo -e ""
    echo -e "  # GitHub 仓库"
    echo -e "  $0 ./flutter_example/ios https://github.com/AigensTechnology/AigensSdkCore.git spm-6.0.1"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}自动添加 SPM 包到 Flutter 项目${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e ""
echo -e "${BLUE}项目路径: $PROJECT_DIR${NC}"
echo -e "${BLUE}包 URL: $PACKAGE_URL${NC}"
echo -e "${BLUE}版本: ${PACKAGE_VERSION:-最新}${NC}"
echo -e ""

# 检查 Xcode 命令行工具
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${YELLOW}❌ 错误: 未找到 xcodebuild${NC}"
    echo -e "${YELLOW}   请安装 Xcode Command Line Tools:${NC}"
    echo -e "   xcode-select --install"
    exit 1
fi

# 检查项目是否存在
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}❌ 错误: 项目目录不存在${NC}"
    exit 1
fi

# 获取 Xcode 项目文件
XCODE_PROJECT=$(find "$PROJECT_DIR" -name "*.xcodeproj" -type d | head -1)

if [ -z "$XCODE_PROJECT" ]; then
    echo -e "${YELLOW}❌ 错误: 未找到 Xcode 项目文件${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 找到项目: $XCODE_PROJECT${NC}"
echo -e ""

# 说明：由于 Xcode 没有官方命令行工具来添加 SPM 包
# 以下提供两种方案

echo -e "${YELLOW}⚠️  说明:${NC}"
echo -e ""
echo -e "${BLUE}由于 Xcode 没有提供命令行工具来添加 SPM 包，${NC}"
echo -e "${BLUE}目前有两种方案：${NC}"
echo -e ""
echo -e "${GREEN}方案 1：使用 Xcode GUI（推荐）${NC}"
echo -e "  1. 打开 Xcode:"
echo -e "     ${YELLOW}open $XCODE_PROJECT${NC}"
echo -e "  2. File → Add Package Dependencies..."
echo -e "  3. 输入: $PACKAGE_URL"
echo -e "  4. 选择版本: ${PACKAGE_VERSION:-最新}"
echo -e "  5. 点击 Finish"
echo -e ""
echo -e "${GREEN}方案 2：手动编辑 project.pbxproj（高级）${NC}"
echo -e "  可以使用 sed/awk 脚本自动修改 project.pbxproj"
echo -e "  但这需要精确的 UUID 生成和配置"
echo -e ""

# 提供自动打开 Xcode 的选项
echo -e "${BLUE}是否现在打开 Xcode 项目？(y/n)${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}🚀 正在打开 Xcode...${NC}"
    open "$XCODE_PROJECT"
    echo -e ""
    echo -e "${GREEN}✅ 请在 Xcode 中手动添加 SPM 包${NC}"
else
    echo -e "${YELLOW}💡 稍后可以运行以下命令打开 Xcode:${NC}"
    echo -e "   ${YELLOW}open $XCODE_PROJECT${NC}"
fi
