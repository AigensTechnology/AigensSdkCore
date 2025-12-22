#!/bin/bash


# Exit on error
set -e

# 分析代码
flutter analyze

# 格式化代码
dart format .



if [[ -z $(git status -s) ]]
then
  echo "tree is clean"
else
  echo "tree is dirty, please commit changes before running this"
  exit 0
fi


echo ""
echo "Step 1: Running dry-run..."
if flutter pub publish --dry-run; then
    echo "✓ Dry-run succeeded!"
    echo ""
    echo "Step 2: Publishing to pub.dev..."
    flutter pub publish
    echo "✓ Published successfully!"
    exit 0
else
    echo "✗ Dry-run failed. Publishing aborted."
    exit 1
fi