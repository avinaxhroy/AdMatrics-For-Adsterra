#!/bin/bash

# Script to add AdMetricsShared framework to the project

cd /Users/avinash/Documents/AdMetrics

echo "🔨 Creating AdMetricsShared Framework..."

# Use xcodebuild to create a framework target
# We'll need to open Xcode to do this properly

osascript <<EOF
tell application "Xcode"
    activate
    open "/Users/avinash/Documents/AdMetrics/AdMetrics.xcodeproj"
end tell
EOF

echo ""
echo "✅ Xcode opened!"
echo ""
echo "📝 Manual steps to complete:"
echo "1. File → New → Target"
echo "2. Select 'Framework' under macOS"
echo "3. Name it: AdMetricsShared"
echo "4. Bundle Identifier: me.avinas.AdMetrics.AdMetricsShared"
echo "5. Click 'Finish'"
echo ""
echo "6. In Project Navigator, DELETE the generated 'AdMetricsShared' folder"
echo "7. Drag the existing 'AdMetricsShared' folder from Finder into the project"
echo ""
echo "8. Select AdMetrics target → General → Frameworks, Libraries, and Embedded Content"
echo "9. Click '+' and add 'AdMetricsShared.framework' (Embed & Sign)"
echo ""
echo "10. Select AdMetricsWidgetExtension target → General → Frameworks"
echo "11. Click '+' and add 'AdMetricsShared.framework' (Embed & Sign)"
echo ""
echo "12. Build the project!"
echo ""
echo "Or... let me do this programmatically instead! Press Ctrl+C and I'll create it properly."

read -p "Press Enter to continue with manual steps, or Ctrl+C to let me script it..."
EOF
