#!/bin/bash
set -e
TOP="$(cd "$(dirname "$0")/../../../.." && pwd)"
PATCH_DIR="$(cd "$(dirname "$0")" && pwd)"

git -C "$TOP/frameworks/base" apply --check "$PATCH_DIR/frameworks_base.patch" && \
    git -C "$TOP/frameworks/base" apply "$PATCH_DIR/frameworks_base.patch"

git -C "$TOP/packages/modules/Connectivity" apply --check "$PATCH_DIR/packages_modules_Connectivity.patch" && \
    git -C "$TOP/packages/modules/Connectivity" apply "$PATCH_DIR/packages_modules_Connectivity.patch"

echo "All caraka22 patches applied successfully."
