#!/bin/bash

# Complete widget registration script
# Tries all methods to register widgets on macOS

echo "🔧 AdMetrics Widget Registration Tool"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Step 1: Build the latest version
echo -e "${BLUE}Step 1: Building latest version...${NC}"
cd /Users/avinash/Documents/AdMetrics
xcodebuild -project AdMetrics.xcodeproj -scheme AdMetrics clean build > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    echo "Try building in Xcode to see errors"
    exit 1
fi
echo ""

# Step 2: Copy to Applications
echo -e "${BLUE}Step 2: Installing to /Applications...${NC}"
rm -rf /Applications/AdMetrics.app
DERIVED_DATA=$(find ~/Library/Developer/Xcode/DerivedData -name "AdMetrics.app" -path "*/Debug/*" | head -1)

if [ -z "$DERIVED_DATA" ]; then
    echo -e "${RED}❌ Could not find built app${NC}"
    exit 1
fi

cp -R "$DERIVED_DATA" /Applications/
echo -e "${GREEN}✅ Copied to /Applications${NC}"
echo ""

# Step 3: Clear widget caches
echo -e "${BLUE}Step 3: Clearing widget caches...${NC}"
rm -rf ~/Library/Caches/com.apple.widgetkit* 2>/dev/null
rm -rf ~/Library/Saved\ Application\ State/com.apple.widgetcenter* 2>/dev/null
echo -e "${GREEN}✅ Caches cleared${NC}"
echo ""

# Step 4: Kill running processes
echo -e "${BLUE}Step 4: Stopping running processes...${NC}"
killall AdMetrics 2>/dev/null
killall WidgetKit 2>/dev/null
echo -e "${GREEN}✅ Processes stopped${NC}"
echo ""

# Step 5: Manual registration
echo -e "${BLUE}Step 5: Manually registering widget extension...${NC}"
pluginkit -a /Applications/AdMetrics.app/Contents/PlugIns/AdMetricsWidgetExtension.appex 2>/dev/null
echo -e "${GREEN}✅ Registration attempted${NC}"
echo ""

# Step 6: Restart Dock
echo -e "${BLUE}Step 6: Restarting Dock...${NC}"
killall Dock
echo -e "${GREEN}✅ Dock restarted${NC}"
echo ""

# Step 7: Launch app
echo -e "${BLUE}Step 7: Launching AdMetrics app...${NC}"
sleep 3
open /Applications/AdMetrics.app
sleep 5
echo -e "${GREEN}✅ App launched${NC}"
echo ""

# Step 8: Check registration
echo -e "${BLUE}Step 8: Checking widget registration...${NC}"
if pluginkit -m -p com.apple.widgetkit-extension | grep -q -i admetrics; then
    echo -e "${GREEN}🎉 SUCCESS! Widget is registered!${NC}"
    echo ""
    echo "Now try adding the widget:"
    echo "1. Right-click on Desktop"
    echo "2. Select 'Edit Widgets'"
    echo "3. Search for 'AdMetrics'"
    echo "4. Drag widget to Desktop or Notification Center"
else
    echo -e "${YELLOW}⚠️  Widget not found in pluginkit registry${NC}"
    echo ""
    echo -e "${YELLOW}This might be a limitation of free Apple Developer accounts on macOS.${NC}"
    echo ""
    echo "Alternative options:"
    echo ""
    echo -e "${BLUE}Option 1: Run from Xcode${NC}"
    echo "  - Open project in Xcode"
    echo "  - Press ⌘ + R to run"
    echo "  - Try adding widget while Xcode is running"
    echo ""
    echo -e "${BLUE}Option 2: Use iOS Simulator (RECOMMENDED)${NC}"
    echo "  - In Xcode, select iPhone simulator"
    echo "  - Press ⌘ + R"
    echo "  - Widgets work perfectly on iOS!"
    echo ""
    echo -e "${BLUE}Option 3: Check System Settings${NC}"
    echo "  - System Settings → Privacy & Security"
    echo "  - Look for AdMetrics blocks"
    echo ""
    echo "See WIDGET_TROUBLESHOOTING.md for more details"
fi
echo ""

# Step 9: Show widget info
echo -e "${BLUE}Widget Extension Info:${NC}"
echo "Bundle ID: me.avinas.AdMetrics.AdMetricsWidget"
echo "Location: /Applications/AdMetrics.app/Contents/PlugIns/"
echo "Extension: AdMetricsWidgetExtension.appex"
echo ""

# Check NSExtension
if plutil -p /Applications/AdMetrics.app/Contents/PlugIns/AdMetricsWidgetExtension.appex/Contents/Info.plist | grep -q "NSExtension"; then
    echo -e "${GREEN}✅ NSExtension key present in Info.plist${NC}"
else
    echo -e "${RED}❌ NSExtension key missing!${NC}"
fi

echo ""
echo "═══════════════════════════════════"
echo "Done! Check Widget Gallery now."
echo "═══════════════════════════════════"
