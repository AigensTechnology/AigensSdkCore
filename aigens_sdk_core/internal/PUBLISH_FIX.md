# Publishing Issues Fix Guide

## Current Issue

The `flutter pub publish --dry-run` is failing with:
1. Warning: 14 checked-in files are modified in git
2. Error: "Failed to update packages"

## Solution

The main issue is that you need to commit your changes before publishing. Here are the steps:

### Option 1: Commit All Changes (Recommended)

```bash
cd /Users/chenpeijue/Desktop/workspace/AigensSdkCore

# Check what files are modified
git status

# Add all new/modified files for the plugin
git add aigens_sdk_core/

# Commit the changes
git commit -m "Add Flutter plugin aigens_sdk_core v0.1.1"

# Now try publishing again
cd aigens_sdk_core
flutter pub publish --dry-run
```

### Option 2: Use --force (Not Recommended)

If you want to publish without committing (not recommended by pub.dev):

```bash
cd aigens_sdk_core
flutter pub publish --dry-run --force
```

However, pub.dev may still reject the publication if there are uncommitted changes.

### Option 3: Stash Changes Temporarily

If you don't want to commit yet:

```bash
cd /Users/chenpeijue/Desktop/workspace/AigensSdkCore
git stash

cd aigens_sdk_core
flutter pub publish --dry-run

# After publishing, restore your changes
cd ..
git stash pop
```

## Files That Should NOT Be Published

The following files are now properly excluded via `.pubignore`:
- `.dart_tool/` (build artifacts)
- `publish.sh` (development script)
- `.gitignore`
- `.idea/`, `.vscode/` (IDE files)
- `.DS_Store` (OS files)

## Notes

- `pubspec.lock` should NOT be committed for packages/plugins (only for apps)
- `.dart_tool/` should NOT be committed
- Always publish from a clean git state as recommended by pub.dev

