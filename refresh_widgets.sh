#!/bin/bash

echo "🔄 Refreshing AdMetrics Widgets..."
echo ""

# Kill the app
echo "1. Stopping AdMetrics app..."
killall -9 AdMetrics 2>/dev/null
sleep 1

# Kill widget processes
echo "2. Killing widget processes..."
killall -9 WidgetKit 2>/dev/null
killall -9 "Widget Center" 2>/dev/null
killall -9 chronod 2>/dev/null
sleep 1

# Clear widget cache (macOS Sonoma+)
echo "3. Clearing widget cache..."
rm -rf ~/Library/Caches/com.apple.chronod/ 2>/dev/null
rm -rf ~/Library/Saved\ Application\ State/com.apple.WidgetCenter.savedState/ 2>/dev/null

# Restart the app
echo "4. Restarting AdMetrics..."
open /Applications/AdMetrics.app
sleep 2

echo ""
echo "✅ Done!"
echo ""
echo "📝 IMPORTANT STEPS TO SEE NEW DESIGN:"
echo ""
echo "1. Remove all existing AdMetrics widgets from your desktop"
echo "   (Right-click widget → Remove Widget)"
echo ""
echo "2. Open Widget Gallery:"
echo "   - Right-click desktop → Edit Widgets"
echo "   - Or Control+click desktop → Edit Widgets"
echo ""
echo "3. Search for 'AdMetrics' and add fresh widgets"
echo ""
echo "4. The new glass morphism design will appear!"
echo ""
echo "Note: macOS caches widgets heavily. You MUST remove old widgets"
echo "      and add fresh ones to see the new design."
