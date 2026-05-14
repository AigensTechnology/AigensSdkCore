#!/bin/bash

# =====================================================
# Aigens SDK - Swift Package Manager 部署脚本
# =====================================================
# 说明：
# 1. SPM 不需要登录，只需要将代码推送到 GitHub 并打标签
# 2. 确保你已经有 GitHub 仓库的访问权限
# 3. 确保已安装 git 并且配置了 GitHub 认证
# =====================================================

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Aigens SDK - SPM 部署脚本${NC}"
echo -e "${GREEN}========================================${NC}"

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}错误: 当前目录不是 git 仓库${NC}"
    exit 1
fi

# 检查是否有未提交的更改
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${YELLOW}警告: 有未提交的更改${NC}"
    read -p "是否继续？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}部署已取消${NC}"
        exit 1
    fi
fi

# 获取当前分支
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${YELLOW}当前分支: ${CURRENT_BRANCH}${NC}"

# 确保在 main/master 分支
if [[ "$CURRENT_BRANCH" != "main" && "$CURRENT_BRANCH" != "master" ]]; then
    echo -e "${YELLOW}警告: 不在 main/master 分支上${NC}"
    read -p "是否继续？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}部署已取消${NC}"
        exit 1
    fi
fi

# =====================================================
# 部署 Aigens SDK (所有模块在同一个 Package.swift 中)
# =====================================================
echo -e "\n${GREEN}----------------------------------------${NC}"
echo -e "${GREEN}部署 Aigens SDK${NC}"
echo -e "${GREEN}----------------------------------------${NC}"

# 统一版本号
SDK_VERSION="0.1.3"
echo -e "${YELLOW}版本: ${SDK_VERSION}${NC}"

# 检查标签是否已存在
if git rev-parse "${SDK_VERSION}" >/dev/null 2>&1; then
    echo -e "${YELLOW}标签 ${SDK_VERSION} 已存在${NC}"
    read -p "是否删除并重新创建？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -d "${SDK_VERSION}"
        git push origin :refs/tags/${SDK_VERSION}
        echo -e "${GREEN}已删除旧标签${NC}"
    else
        echo -e "${YELLOW}跳过部署${NC}"
        exit 0
    fi
fi

echo -e "${YELLOW}创建标签 ${SDK_VERSION}...${NC}"
git tag -a "${SDK_VERSION}" -m "Release Aigens SDK version ${SDK_VERSION} - Includes Core, Applepay, Wechatpay"
echo -e "${GREEN}标签已创建${NC}"

# =====================================================
# 推送到 GitHub
# =====================================================
echo -e "\n${GREEN}----------------------------------------${NC}"
echo -e "${GREEN}推送到 GitHub${NC}"
echo -e "${GREEN}----------------------------------------${NC}"

echo -e "${YELLOW}推送代码和标签到 GitHub...${NC}"
git push origin ${CURRENT_BRANCH} --follow-tags

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}部署完成！${NC}"
echo -e "${GREEN}========================================${NC}"

echo -e "\n${YELLOW}SPM 使用示例：${NC}"
echo -e "在 Xcode 或 Package.swift 中添加："
echo -e ""
echo -e ".package(url: \"https://github.com/AigensTechnology/AigensSdkCore.git\", from: \"0.1.3\")"
echo -e ""
echo -e "然后在 dependencies 中选择需要的模块："
echo -e \"  .product(name: \"AigensSdkCore\", package: \"AigensSdkCore\")\"
echo -e \"  .product(name: \"AigensSdkApplepay\", package: \"AigensSdkCore\")\"
echo -e \"  .product(name: \"AigensSdkWechatpay\", package: \"AigensSdkCore\")\"
echo -e ""

echo -e "${YELLOW}验证 SPM 包：${NC}"
echo -e "swift package describe"
echo -e ""

echo -e "${GREEN}完成！${NC}"
