#!/bin/bash

# ============================================================================
# 发布 aigens_sdk_core 到 pub.dev
# ============================================================================

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}发布 aigens_sdk_core 到 pub.dev${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

PLUGIN_DIR="/Users/chenpeijue/Desktop/workspace/AigensSdkCore/aigens_sdk_core"

cd "$PLUGIN_DIR"

# 步骤 1：检查配置
echo -e "${YELLOW}📋 步骤 1/5: 检查配置...${NC}"

if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ 错误: pubspec.yaml 不存在${NC}"
    exit 1
fi

echo -e "${GREEN}✅ pubspec.yaml 存在${NC}"

# 检查必要文件
if [ ! -d "ios/Sources/aigens_sdk_core" ]; then
    echo -e "${RED}❌ 错误: iOS 源代码目录不存在${NC}"
    exit 1
fi

echo -e "${GREEN}✅ iOS 源代码存在${NC}"

if [ ! -d "android/src/main" ]; then
    echo -e "${RED}❌ 错误: Android 源代码目录不存在${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Android 源代码存在${NC}"

# 步骤 2：运行 dry run
echo -e ""
echo -e "${YELLOW}📋 步骤 2/5: 运行发布前检查...${NC}"

flutter pub publish --dry-run

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 发布前检查失败，请修复上述问题${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 发布前检查通过${NC}"

# 步骤 3：确认发布
echo -e ""
echo -e "${YELLOW}📋 步骤 3/5: 确认发布${NC}"
echo -e ""
echo -e "${BLUE}即将发布到 pub.dev，是否继续？(y/n)${NC}"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}❌ 已取消发布${NC}"
    exit 0
fi

# 步骤 4：发布
echo -e ""
echo -e "${YELLOW}📋 步骤 4/5: 发布到 pub.dev...${NC}"

flutter pub publish

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 发布失败${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 发布成功！${NC}"

# 步骤 5：创建 Git 标签
echo -e ""
echo -e "${YELLOW}📋 步骤 5/5: 创建 Git 标签...${NC}"

VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}')
TAG_NAME="flutter-v$VERSION"

echo -e "${BLUE}创建标签: $TAG_NAME${NC}"

cd ..
git tag -a "$TAG_NAME" -m "Release Flutter plugin version $VERSION"
git push origin "$TAG_NAME"

echo -e "${GREEN}✅ 标签已创建并推送${NC}"

# 完成
echo -e ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 发布完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e ""
echo -e "${BLUE}用户现在可以通过以下方式安装:${NC}"
echo -e ""
echo -e "${YELLOW}pubspec.yaml:${NC}"
echo -e "  dependencies:"
echo -e "    aigens_sdk_core: ^$VERSION"
echo -e ""
echo -e "${YELLOW}命令行:${NC}"
echo -e "  flutter pub add aigens_sdk_core"
echo -e ""
echo -e "${BLUE}查看发布:${NC}"
echo -e "  https://pub.dev/packages/aigens_sdk_core"
echo -e ""
