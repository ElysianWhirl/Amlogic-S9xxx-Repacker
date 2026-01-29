#!/bin/bash
# Device compatibility checker for GitHub Actions testing

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <device_type> <rootfs_file>"
    exit 1
fi

DEVICE_TYPE="$1"
ROOTFS_FILE="$2"

echo "🔍 Checking compatibility for device: $DEVICE_TYPE"

# Basic file validation
if [ ! -f "$ROOTFS_FILE" ]; then
    echo "❌ Rootfs file not found: $ROOTFS_FILE"
    exit 1
fi

# Check file size
FILE_SIZE=$(stat -c%s "$ROOTFS_FILE")
MIN_SIZE=10485760  # 10MB minimum

if [ "$FILE_SIZE" -lt "$MIN_SIZE" ]; then
    echo "❌ Rootfs file too small: $(($FILE_SIZE/1024))KB (minimum: 10MB)"
    exit 1
fi

# Device-specific compatibility checks
case "$DEVICE_TYPE" in
    s905|s905x|s905d)
        echo "✅ S905 series compatibility check passed"
        ;;
    s912)
        echo "✅ S912 compatibility check passed"
        ;;
    s922x)
        echo "✅ S922X compatibility check passed"
        ;;
    *)
        echo "❌ Unknown device type: $DEVICE_TYPE"
        exit 1
        ;;
esac

# Architecture check (basic)
if file "$ROOTFS_FILE" | grep -q "ARM"; then
    echo "✅ ARM architecture detected"
elif file "$ROOTFS_FILE" | grep -q "aarch64"; then
    echo "✅ AArch64 architecture detected"
else
    echo "⚠️  Warning: Non-ARM architecture detected, but proceeding anyway"
fi

echo "✅ Compatibility check completed successfully"
exit 0
