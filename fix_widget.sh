#!/bin/bash

echo "🔍 WIDGET TROUBLESHOOTING"
echo "========================="
echo ""

echo "Checking widget setup..."
echo ""

# Check if SharedDataManager exists
if [ -f "./Shared/Services/SharedDataManager.swift" ]; then
    echo "✅ SharedDataManager.swift exists"
else
    echo "❌ SharedDataManager.swift missing!"
fi

# Check if widget files exist
if [ -f "./AdMetricsWidget/AdMetricsWidget.swift" ]; then
    echo "✅ Widget main file exists"
else
    echo "❌ Widget main file missing!"
fi

# Check if widget views exist
if [ -f "./AdMetricsWidget/SmallWidgetView.swift" ]; then
    echo "✅ SmallWidgetView exists"
else
    echo "❌ SmallWidgetView missing!"
fi

if [ -f "./AdMetricsWidget/MediumWidgetView.swift" ]; then
    echo "✅ MediumWidgetView exists"
else
    echo "❌ MediumWidgetView missing!"
fi

if [ -f "./AdMetricsWidget/LargeWidgetView.swift" ]; then
    echo "✅ LargeWidgetView exists"
else
    echo "❌ LargeWidgetView missing!"
fi

echo ""
echo "📋 REQUIRED STEPS TO FIX:"
echo "========================="
echo ""
echo "1. BUILD WIDGET EXTENSION FIRST"
echo "   ---------------------------"
echo "   In Xcode toolbar:"
echo "   • Click scheme dropdown (currently 'AdMetrics')"
echo "   • Select 'AdMetricsWidgetExtension'"
echo "   • Make sure device is 'My Mac'"
echo "   • Press ⌘ + B (just build, don't run)"
echo "   • Wait for 'Build Succeeded' message"
echo ""
echo "2. CHECK FOR BUILD ERRORS"
echo "   ---------------------"
echo "   • Look in Xcode Issue Navigator (⌘ + 5)"
echo "   • If you see errors, tell me what they are"
echo "   • Common issue: SharedDataManager not found"
echo ""
echo "3. ADD SHAREDDATAMANAGER TO WIDGET TARGET"
echo "   --------------------------------------"
echo "   If build fails with 'SharedDataManager not found':"
echo "   • Select SharedDataManager.swift in Project Navigator"
echo "   • Open File Inspector (⌘ + Option + 1)"
echo "   • Under 'Target Membership', check:"
echo "     ☑ AdMetrics"
echo "     ☑ AdMetricsWidgetExtension  ← MUST BE CHECKED"
echo ""
echo "4. BUILD AGAIN"
echo "   -----------"
echo "   • Scheme: AdMetricsWidgetExtension"
echo "   • Press: ⌘ + B"
echo "   • Should succeed now"
echo ""
echo "5. RUN MAIN APP"
echo "   ------------"
echo "   • Switch scheme back to 'AdMetrics'"
echo "   • Press: ⌘ + R"
echo ""
echo "6. ADD WIDGET"
echo "   ----------"
echo "   • Right-click Desktop → Edit Widgets"
echo "   • Search 'AdMetrics'"
echo "   • Should appear now!"
echo ""
echo "🆘 STILL NOT WORKING?"
echo "===================="
echo ""
echo "Try this in Xcode:"
echo ""
echo "1. Product → Clean Build Folder (⌘ + Shift + K)"
echo "2. Close Xcode completely"
echo "3. Delete DerivedData:"
echo "   rm -rf ~/Library/Developer/Xcode/DerivedData/AdMetrics-*"
echo "4. Re-open project"
echo "5. Build widget extension: ⌘ + B"
echo "6. Run main app: ⌘ + R"
echo ""
echo "If still not working, tell me the exact error message!"
echo ""
