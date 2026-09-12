#!/bin/bash
# ============================================================
#  Bonus Tracker App - Unified Dart Formatter (Linux / macOS)
# ============================================================
#  Run this script BEFORE pushing your code to avoid
#  formatting conflicts between team members.
#
#  Usage:
#    chmod +x format_code.sh   # (first time only)
#    ./format_code.sh
# ============================================================

set -e

# ── Colors for pretty output ──────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ── Navigate to project root (where this script lives) ────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   🎨  Bonus Tracker - Unified Code Formatter    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ── Find dart (check PATH first, then common install locations) ──
if ! command -v dart &> /dev/null; then
    echo -e "${YELLOW}⚠ 'dart' not in PATH, searching common locations...${NC}"

    FLUTTER_LOCATIONS=(
        "$HOME/development/flutter/bin"
        "$HOME/flutter/bin"
        "$HOME/snap/flutter/common/flutter/bin"
        "/opt/flutter/bin"
        "/usr/local/flutter/bin"
        "$HOME/fvm/default/bin"
    )

    FOUND=false
    for loc in "${FLUTTER_LOCATIONS[@]}"; do
        if [ -f "$loc/dart" ]; then
            export PATH="$loc:$PATH"
            echo -e "${GREEN}✔ Found dart at: $loc${NC}"
            FOUND=true
            break
        fi
    done

    if [ "$FOUND" = false ]; then
        echo -e "${RED}✖ Error: 'dart' command not found!${NC}"
        echo -e "${YELLOW}  Make sure Flutter/Dart is installed and in your PATH.${NC}"
        echo -e "${YELLOW}  Common install locations checked:${NC}"
        for loc in "${FLUTTER_LOCATIONS[@]}"; do
            echo -e "${YELLOW}    - $loc${NC}"
        done
        exit 1
    fi
fi

echo -e "${YELLOW}⏳ Formatting all Dart files in lib/ and test/ ...${NC}"
echo ""

# ── Run dart format ───────────────────────────────────────────
# --page-width=80   : Standard Dart line length (consistent for everyone)
# lib/ test/         : Only format project source files

CHANGED_FILES=0

# Format lib/
if [ -d "lib" ]; then
    OUTPUT=$(dart format --page-width=80 lib/ 2>&1)
    echo "$OUTPUT"
    # Count changed files (matches '(1 changed)', '(2 changed)', etc.)
    if echo "$OUTPUT" | grep -qE "\([1-9][0-9]* changed\)"; then
        CHANGED_FILES=$((CHANGED_FILES + 1))
    fi
fi

# Format test/
if [ -d "test" ]; then
    OUTPUT=$(dart format --page-width=80 test/ 2>&1)
    echo "$OUTPUT"
    if echo "$OUTPUT" | grep -qE "\([1-9][0-9]* changed\)"; then
        CHANGED_FILES=$((CHANGED_FILES + 1))
    fi
fi

echo ""
echo -e "${GREEN}══════════════════════════════════════════════════${NC}"

if [ "$CHANGED_FILES" -gt 0 ]; then
    echo -e "${GREEN}✔ Formatting complete! Files were updated.${NC}"
    echo -e "${YELLOW}  Don't forget to review the changes before committing.${NC}"
else
    echo -e "${GREEN}✔ All files are already properly formatted! 👌${NC}"
fi

echo -e "${GREEN}══════════════════════════════════════════════════${NC}"
echo ""
