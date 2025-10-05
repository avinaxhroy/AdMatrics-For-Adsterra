#!/bin/bash

echo "🔍 WIDGET DIAGNOSTIC CHECK"
echo "=========================="
echo ""

# Check if all required files exist
echo "📂 Checking Files:"
echo "------------------"

files=(
    "./AdMetricsWidget/AdMetricsWidget.swift"
    "./AdMetricsWidget/SmallWidgetView.swift"
    "./AdMetricsWidget/MediumWidgetView.swift"
    "./AdMetricsWidget/LargeWidgetView.swift"
    "./Shared/Services/SharedDataManager.swift"
    "./Shared/Services/CacheService.swift"
    "./Shared/Models/WidgetData.swift"
    "./Shared/Utilities/FormatHelpers.swift"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ MISSING: $file"
    fi
done

echo ""
echo "📋 WHAT TO DO NEXT:"
echo "-------------------"
echo ""
echo "1. VERIFY TARGET MEMBERSHIP"
echo "   For SharedDataManager.swift, CacheService.swift,"
echo "   WidgetData.swift, and FormatHelpers.swift:"
echo "   • Both targets should be checked in File Inspector"
echo "   • Both should show as highlighted in blue"
echo ""
echo "2. BUILD WIDGET EXTENSION"
echo "   • Scheme: AdMetricsWidgetExtension"
echo "   • Device: My Mac"
echo "   • Press: ⌘ + B"
echo ""
echo "3. CHECK BUILD OUTPUT"
echo "   Look for one of these:"
echo "   ✅ 'Build Succeeded' → Continue to step 4"
echo "   ❌ 'Build Failed' → Tell me the error message"
echo ""
echo "4. IF BUILD SUCCEEDED:"
echo "   • Clean: ⌘ + Shift + K"
echo "   • Switch to AdMetrics scheme"
echo "   • Run: ⌘ + R"
echo "   • Right-click Desktop → Edit Widgets"
echo "   • Widget should appear!"
echo ""
echo "5. IF WIDGET STILL NOT IN GALLERY:"
echo "   Run this command:"
echo "   killall Dock"
echo "   (This refreshes the widget gallery)"
echo ""
echo "6. NUCLEAR OPTION (if nothing else works):"
echo "   rm -rf ~/Library/Developer/Xcode/DerivedData/AdMetrics-*"
echo "   Then rebuild everything from scratch"
echo ""

echo "❓ TELL ME:"
echo "-----------"
echo "1. Did widget extension build succeed? (⌘ + B)"
echo "2. Any error messages?"
echo "3. What does Xcode say when you build?"
echo ""
