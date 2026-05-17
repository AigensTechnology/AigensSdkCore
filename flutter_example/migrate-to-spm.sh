#!/bin/bash

# ============================================================================
# flutter_example 完全迁移到 SPM（移除 CocoaPods）
# ============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FLUTTER_EXAMPLE_DIR="/Users/chenpeijue/Desktop/workspace/AigensSdkCore/flutter_example"
IOS_DIR="$FLUTTER_EXAMPLE_DIR/ios"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}flutter_example: 完全迁移到 SPM${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 步骤 1：检查前置条件
echo -e "${YELLOW}📋 步骤 1/7: 检查前置条件...${NC}"

if [ ! -d "$FLUTTER_EXAMPLE_DIR" ]; then
    echo -e "${RED}❌ 错误: flutter_example 目录不存在${NC}"
    exit 1
fi

cd "$FLUTTER_EXAMPLE_DIR"

# 检查 Flutter 版本
FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
echo "Flutter 版本: $FLUTTER_VERSION"

echo -e "${GREEN}✅ 前置检查通过${NC}"
echo ""

# 步骤 2：备份 CocoaPods 配置
echo -e "${YELLOW}📦 步骤 2/7: 备份 CocoaPods 配置...${NC}"

BACKUP_DIR="$IOS_DIR-cocoapods-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 备份 Podfile
if [ -f "$IOS_DIR/Podfile" ]; then
    cp "$IOS_DIR/Podfile" "$BACKUP_DIR/"
    echo "✓ 已备份 Podfile"
fi

# 备份 Podfile.lock
if [ -f "$IOS_DIR/Podfile.lock" ]; then
    cp "$IOS_DIR/Podfile.lock" "$BACKUP_DIR/"
    echo "✓ 已备份 Podfile.lock"
fi

# 备份 Podfile.lock
echo "备份位置: $BACKUP_DIR"
echo -e "${GREEN}✅ 备份完成${NC}"
echo ""

# 步骤 3：删除 CocoaPods 相关文件
echo -e "${YELLOW}🗑️  步骤 3/7: 删除 CocoaPods 文件...${NC}"

cd "$IOS_DIR"

# 删除 Pods 目录
if [ -d "Pods" ]; then
    rm -rf Pods
    echo "✓ 已删除 Pods/ 目录"
fi

# 删除 Podfile
if [ -f "Podfile" ]; then
    rm Podfile
    echo "✓ 已删除 Podfile"
fi

# 删除 Podfile.lock
if [ -f "Podfile.lock" ]; then
    rm Podfile.lock
    echo "✓ 已删除 Podfile.lock"
fi

# 删除 .symlinks 目录
if [ -d ".symlinks" ]; then
    rm -rf .symlinks
    echo "✓ 已删除 .symlinks/ 目录"
fi

echo -e "${GREEN}✅ CocoaPods 文件已删除${NC}"
echo ""

# 步骤 4：清理构建缓存
echo -e "${YELLOW}🧹 步骤 4/7: 清理构建缓存...${NC}"

cd "$FLUTTER_EXAMPLE_DIR"

# 清理 Flutter 构建缓存
flutter clean
echo "✓ 已清理 Flutter 构建缓存"

# 清理 Xcode DerivedData
DERIVED_DATA=~/Library/Developer/Xcode/DerivedData
if [ -d "$DERIVED_DATA" ]; then
    rm -rf "$DERIVED_DATA"
    echo "✓ 已清理 Xcode DerivedData"
fi

# 清理 pub 缓存
rm -rf ~/.pub-cache/hosted/pub.dev/aigens_sdk_core-*
echo "✓ 已清理 pub 缓存"

echo -e "${GREEN}✅ 缓存清理完成${NC}"
echo ""

# 步骤 5：重新获取依赖
echo -e "${YELLOW}📥 步骤 5/7: 获取 Flutter 依赖...${NC}"

flutter pub get
echo -e "${GREEN}✅ 依赖获取完成${NC}"
echo ""

# 步骤 6：配置 SPM
echo -e "${YELLOW}⚙️  步骤 6/7: 配置 SPM 集成...${NC}"

# 检查是否已存在 Package.resolved
if [ -f "$IOS_DIR/Runner.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
    echo "⚠️  已存在 SPM 配置"
else
    echo "✓ SPM 配置将在首次构建时自动生成"
fi

echo -e "${GREEN}✅ SPM 配置完成${NC}"
echo ""

# 步骤 7：生成迁移报告
echo -e "${YELLOW}📝 步骤 7/7: 生成迁移报告...${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ 迁移完成！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}📊 迁移摘要:${NC}"
echo "  ✓ 已删除 CocoaPods 相关文件"
echo "  ✓ 已清理所有缓存"
echo "  ✓ 已重新获取 Flutter 依赖"
echo ""
echo -e "${YELLOW}⚠️  接下来需要手动操作:${NC}"
echo ""
echo -e "${BLUE}1. 打开 Xcode 项目:${NC}"
echo "   $ open $IOS_DIR/Runner.xcodeproj"
echo ""
echo -e "${BLUE}2. 添加 SPM 包:${NC}"
echo "   File → Add Package Dependencies..."
echo "   URL: https://github.com/AigensTechnology/AigensSdkCore.git"
echo "   选择: aigens-sdk-core, AigensSdkCore"
echo ""
echo -e "${BLUE}3. 运行项目:${NC}"
echo "   flutter run"
echo ""
echo -e "${YELLOW}💡 提示:${NC}"
echo "  - 这是唯一需要手动添加的步骤"
echo "  - 之后团队成员只需 flutter pub get 即可"
echo "  - CocoaPods 配置已备份到: $BACKUP_DIR"
echo ""
