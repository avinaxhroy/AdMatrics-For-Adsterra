#!/bin/bash

echo "🧪 Testing Widget API Key Access"
echo "================================="
echo ""

API_KEY_FILE=~/Library/Application\ Support/AdMetrics/api_key.txt

if [ -f "$API_KEY_FILE" ]; then
    echo "✅ API key file exists"
    echo "   Location: $API_KEY_FILE"
    echo "   Size: $(wc -c < "$API_KEY_FILE") bytes"
    echo "   Permissions: $(ls -l "$API_KEY_FILE" | awk '{print $1}')"
    echo ""
    
    # Check if it's readable
    if [ -r "$API_KEY_FILE" ]; then
        echo "✅ File is readable"
        echo "   First 10 chars: $(head -c 10 "$API_KEY_FILE")..."
    else
        echo "❌ File is NOT readable"
    fi
else
    echo "❌ API key file does NOT exist"
fi

echo ""
echo "📁 All files in shared directory:"
ls -lh ~/Library/Application\ Support/AdMetrics/
echo ""

echo "🔍 Checking if widget_data.json was created:"
if [ -f ~/Library/Application\ Support/AdMetrics/widget_data.json ]; then
    echo "✅ widget_data.json exists"
    echo "   Size: $(wc -c < ~/Library/Application\ Support/AdMetrics/widget_data.json) bytes"
    echo "   Modified: $(stat -f "%Sm" ~/Library/Application\ Support/AdMetrics/widget_data.json)"
else
    echo "❌ widget_data.json NOT found"
    echo "   This means either:"
    echo "   1. App hasn't fetched data yet (tap Refresh in app)"
    echo "   2. API key is invalid"
    echo "   3. Network error"
fi

echo ""
echo "💡 To test: Open the app and tap the refresh button"
