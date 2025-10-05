#!/bin/bash

# Quick test script for widget data sharing
# For FREE Apple Developer Account

echo "🧪 Testing AdMetrics Widget Setup..."
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: Shared directory
echo "1️⃣ Checking shared data directory..."
SHARED_DIR="$HOME/Library/Application Support/AdMetrics-Shared"
if [ -d "$SHARED_DIR" ]; then
    echo -e "${GREEN}✅ Shared directory exists${NC}"
    ls -la "$SHARED_DIR"
else
    echo -e "${YELLOW}⚠️  Shared directory not found. Will be created when app runs.${NC}"
fi
echo ""

# Check 2: Widget data file
echo "2️⃣ Checking widget data file..."
DATA_FILE="$SHARED_DIR/widget-data.json"
if [ -f "$DATA_FILE" ]; then
    echo -e "${GREEN}✅ Widget data file exists${NC}"
    echo "File size: $(wc -c < "$DATA_FILE") bytes"
    echo "Last modified: $(stat -f "%Sm" "$DATA_FILE")"
    echo ""
    echo "Preview:"
    head -c 200 "$DATA_FILE"
    echo "..."
else
    echo -e "${YELLOW}⚠️  Widget data file not found. Run the main app first.${NC}"
fi
echo ""

# Check 3: Build artifacts
echo "3️⃣ Checking build artifacts..."
BUILD_DIR="$HOME/Library/Developer/Xcode/DerivedData/AdMetrics-"*"/Build/Products/Release"
if ls $BUILD_DIR/AdMetrics.app 2>/dev/null; then
    echo -e "${GREEN}✅ Main app built${NC}"
    
    if ls $BUILD_DIR/AdMetrics.app/Contents/PlugIns/AdMetricsWidgetExtension.appex 2>/dev/null; then
        echo -e "${GREEN}✅ Widget extension built and embedded${NC}"
    else
        echo -e "${RED}❌ Widget extension not found${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No build artifacts found. Build the project first.${NC}"
fi
echo ""

# Check 4: Widget registration
echo "4️⃣ Checking widget registration..."
if pluginkit -m -v | grep -i "admetrics" | grep -i "widget"; then
    echo -e "${GREEN}✅ Widget extension is registered${NC}"
else
    echo -e "${YELLOW}⚠️  Widget not registered yet. Run the app once.${NC}"
fi
echo ""

# Summary
echo "📋 Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "To make widgets work:"
echo "1. Build and run the main app (⌘R in Xcode)"
echo "2. Load data with your API key"
echo "3. Right-click Desktop → Edit Widgets"
echo "4. Search for 'AdMetrics' and add widget"
echo ""
echo "For detailed instructions, see:"
echo "FREE_ACCOUNT_WIDGET_SETUP.md"
echo ""
