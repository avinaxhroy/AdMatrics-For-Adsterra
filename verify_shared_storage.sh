#!/bin/bash
# Verification script for AdMetrics widget file-based storage

echo "🔍 Checking AdMetrics Shared File Storage"
echo "=========================================="
echo ""

SHARED_DIR="$HOME/Library/Application Support/AdMetrics"
API_KEY_FILE="$SHARED_DIR/api_key.txt"
WIDGET_DATA_FILE="$SHARED_DIR/widget_data.json"

echo "📁 Shared directory: $SHARED_DIR"
echo ""

# Check if directory exists
if [ -d "$SHARED_DIR" ]; then
    echo "✅ Shared directory exists"
    ls -la "$SHARED_DIR"
    echo ""
else
    echo "❌ Shared directory does not exist yet"
    echo "   Will be created when you save API key in the app"
    echo ""
fi

# Check API key file
if [ -f "$API_KEY_FILE" ]; then
    echo "✅ API key file exists: $API_KEY_FILE"
    echo "   Size: $(wc -c < "$API_KEY_FILE") bytes"
    echo "   Permissions: $(stat -f "%Sp" "$API_KEY_FILE")"
    echo ""
else
    echo "❌ API key file not found"
    echo "   Expected at: $API_KEY_FILE"
    echo "   ACTION NEEDED: Enter your API key in the app's Settings"
    echo ""
fi

# Check widget data cache
if [ -f "$WIDGET_DATA_FILE" ]; then
    echo "✅ Widget data cache exists: $WIDGET_DATA_FILE"
    echo "   Size: $(wc -c < "$WIDGET_DATA_FILE") bytes"
    echo "   Last modified: $(stat -f "%Sm" "$WIDGET_DATA_FILE")"
    echo ""
else
    echo "⚠️  Widget data cache not found (normal if widget hasn't run yet)"
    echo ""
fi

echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Open AdMetrics app (it's already open)"
echo "2. Go to Settings"
echo "3. Enter your Adsterra API key"
echo "4. The key will be saved to: $API_KEY_FILE"
echo "5. Widget will read from there and fetch data"
echo ""
echo "To verify after entering key:"
echo "./verify_shared_storage.sh"
