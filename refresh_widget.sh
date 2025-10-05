#!/bin/bash

echo "🔄 Refreshing AdMetrics Widget..."
echo ""

# Check shared storage
echo "📁 Checking shared files:"
ls -lh ~/Library/Application\ Support/AdMetrics/
echo ""

# Kill and restart widget extension to force refresh
echo "♻️  Restarting widget extension..."
killall WidgetKit 2>/dev/null
killall Dock 2>/dev/null

sleep 2

echo ""
echo "✅ Widget refresh triggered!"
echo ""
echo "The widget should update within 30 seconds."
echo "If it still shows 'No Data', check:"
echo "  1. API key is entered in the app"
echo "  2. App has fetched data (check for widget_data.json)"
echo "  3. Widget is added to desktop"
