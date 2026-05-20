#!/bin/bash

# =====================================================
# Aigens SDK - Clean Pod References Script
# =====================================================
# This script removes all Pod-related files and references
# =====================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Aigens SDK - Pod Cleanup Script${NC}"
echo -e "${GREEN}========================================${NC}"

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Find and remove Pods directories
echo -e "\n${YELLOW}Removing Pods directories...${NC}"
find "$PROJECT_ROOT" -type d -name "Pods" 2>/dev/null | while read -r pod_dir; do
    echo "  Removing: $pod_dir"
    rm -rf "$pod_dir"
done

# Find and remove Podfile.lock files
echo -e "\n${YELLOW}Removing Podfile.lock files...${NC}"
find "$PROJECT_ROOT" -type f -name "Podfile.lock" 2>/dev/null | while read -r lock_file; do
    echo "  Removing: $lock_file"
    rm -f "$lock_file"
done

# Find and remove .xcworkspace files (related to Pods)
echo -e "\n${YELLOW}Removing Pod-related .xcworkspace...${NC}"
find "$PROJECT_ROOT" -type d -name "*.xcworkspace" 2>/dev/null | while read -r workspace; do
    # Check if this workspace contains Pods reference
    if [[ "$workspace" == *".xcworkspace" ]] && [[ "$workspace" != *"Pods.xcworkspace"* ]]; then
        # Check if workspace folder has Pods folder or is the main Pods workspace
        workspace_dir="$(dirname "$workspace")"
        if [[ -d "$workspace_dir/Pods" ]] || [[ "$workspace" == *"Pods.xcworkspace"* ]]; then
            echo "  Removing workspace: $workspace"
            rm -rf "$workspace"
        fi
    fi
done

# Clean Pods.xcodeproj if exists
echo -e "\n${YELLOW}Removing Pods.xcodeproj...${NC}"
find "$PROJECT_ROOT" -type d -name "_Pods.xcodeproj" 2>/dev/null | while read -r pods_proj; do
    echo "  Removing: $pods_proj"
    rm -rf "$pods_proj"
done

# Clean Pods-*.frameworks references in xcconfig files
echo -e "\n${YELLOW}Cleaning xcconfig files...${NC}"
find "$PROJECT_ROOT" -type f -name "*.xcconfig" 2>/dev/null | while read -r xcconfig; do
    if grep -q "Pods" "$xcconfig" 2>/dev/null; then
        echo "  Cleaning: $xcconfig"
        # Remove Pods-related lines
        sed -i '' '/PODS/d' "$xcconfig"
        sed -i '' '/pod/d' "$xcconfig"
        sed -i '' '/FDAD/d' "$xcconfig"
        sed -i '' '/FRAMEWORK/d' "$xcconfig"
    fi
done

# Clean references in project.pbxproj files
echo -e "\n${YELLOW}Cleaning project.pbxproj files...${NC}"
find "$PROJECT_ROOT" -type f -name "project.pbxproj" 2>/dev/null | while read -r pbxproj; do
    if grep -q "Pods" "$pbxproj" 2>/dev/null; then
        echo "  Cleaning: $pbxproj"
        # Remove Pods references (XCBuildConfiguration sections)
        sed -i '' '/PODS_CONFIG/d' "$pbxproj"
        sed -i '' '/CLANG_ENABLE_MODULES/d' "$pbxproj"  # Common in Pods
        # Remove Pods target references
        sed -i '' '/\[CP\] /d' "$pbxproj"
        # Remove references to _Pods.xcodeproj
        sed -i '' '/_Pods/d' "$pbxproj"
        # Remove sourceTree = Pods; lines
        sed -i '' '/sourceTree = Pods/d' "$pbxproj"
    fi
done

# Remove Podfile if present in root
if [[ -f "$PROJECT_ROOT/Podfile" ]]; then
    echo -e "\n${YELLOW}Removing root Podfile...${NC}"
    rm -f "$PROJECT_ROOT/Podfile"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Cleanup completed!${NC}"
echo -e "${GREEN}========================================${NC}"

echo -e "\n${YELLOW}Note: You may need to restart Xcode and run 'pod install' again if needed.${NC}"
