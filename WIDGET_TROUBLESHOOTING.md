# Widget Not Showing - Advanced Troubleshooting

## Current Status
- ✅ Widget extension builds successfully
- ✅ Info.plist contains NSExtension key
- ✅ Code signing is valid
- ❌ Widget not appearing in Widget Gallery

## Possible Causes & Solutions

### Solution 1: Run from Xcode Directly
Widgets often work better when run directly from Xcode rather than copied to Applications.

```bash
# In Xcode:
1. Select "AdMetrics" scheme
2. Device: "My Mac"  
3. Press ⌘ + R (Run)
4. App will launch
5. Leave Xcode running
6. Open Widget Gallery (Right-click Desktop → Edit Widgets)
7. Search for "AdMetrics"
```

### Solution 2: Manual Registration via pluginkit

```bash
# Register the widget extension manually
pluginkit -a /Applications/AdMetrics.app/Contents/PlugIns/AdMetricsWidgetExtension.appex

# Or if running from DerivedData:
pluginkit -a ~/Library/Developer/Xcode/DerivedData/AdMetrics-*/Build/Products/Debug/AdMetrics.app/Contents/PlugIns/AdMetricsWidgetExtension.appex

# Restart Dock
killall Dock

# Check registration
pluginkit -m -p com.apple.widgetkit-extension | grep -i admetrics
```

### Solution 3: Archive and Export

For widgets to properly register on macOS without a paid account, you might need to:

```bash
# In Xcode:
1. Product → Archive
2. Distribute App → Custom
3. Copy App
4. Export to Desktop
5. Copy the archived app to /Applications
6. Run it from there
```

### Solution 4: Check System Preferences

```bash
# Check if System Extension Blocked notification appeared
# Go to: System Settings → Privacy & Security
# Look for any blocks related to "AdMetrics"
```

### Solution 5: Reset Widget Cache

```bash
# Clear widget cache
rm -rf ~/Library/Caches/com.apple.widgetkit*
rm -rf ~/Library/Saved\ Application\ State/com.apple.widgetcenter*

# Restart Dock and WidgetKit
killall Dock
killall WidgetKit

# Re-open the app
open /Applications/AdMetrics.app
```

### Solution 6: Check Console Logs

```bash
# Open Console.app
# Filter for: "widgetkit" OR "pluginkit" OR "admetrics"
# Look for error messages when:
# - App launches
# - You open Widget Gallery
```

### Solution 7: Verify Bundle IDs Match

```bash
# Check main app bundle ID
plutil -p /Applications/AdMetrics.app/Contents/Info.plist | grep CFBundleIdentifier

# Check widget extension bundle ID  
plutil -p /Applications/AdMetrics.app/Contents/PlugIns/AdMetricsWidgetExtension.appex/Contents/Info.plist | grep CFBundleIdentifier

# Widget ID should be: me.avinas.AdMetrics.AdMetricsWidget
# Main app ID should be: me.avinas.AdMetrics
```

### Solution 8: Known Issue with Free Accounts

macOS widgets **may require** a paid Apple Developer account for proper registration on some macOS versions. If none of the above works:

**Workaround Options:**
1. **Use iOS Simulator** - Widgets work perfectly in iOS Simulator without paid account
2. **Test on iOS Device** - Same code works on iPhone/iPad  
3. **Upgrade to Paid Account** - $99/year for full widget support

## Quick Test Commands

```bash
# Run all checks at once:
cd /Users/avinash/Documents/AdMetrics

# 1. Build latest version
xcodebuild -project AdMetrics.xcodeproj -scheme AdMetrics clean build

# 2. Copy to Applications
rm -rf /Applications/AdMetrics.app
cp -R ~/Library/Developer/Xcode/DerivedData/AdMetrics-*/Build/Products/Debug/AdMetrics.app /Applications/

# 3. Register manually
pluginkit -a /Applications/AdMetrics.app/Contents/PlugIns/AdMetricsWidgetExtension.appex

# 4. Clear cache
rm -rf ~/Library/Caches/com.apple.widgetkit*

# 5. Restart services
killall Dock
killall WidgetKit 2>/dev/null || true

# 6. Open app
sleep 3
open /Applications/AdMetrics.app

# 7. Check registration
sleep 5
pluginkit -m -p com.apple.widgetkit-extension | grep -i admetrics
```

## Alternative: Use iOS Simulator

Your widgets will work perfectly in iOS Simulator:

```bash
# In Xcode:
1. Select "AdMetrics" scheme
2. Device: "iPhone 15 Pro" (or any iOS simulator)
3. Press ⌘ + R
4. Once app launches, press ⌘ + H to go home
5. Long-press empty space on home screen
6. Tap "+" button (top-left)
7. Search for "AdMetrics"
8. Add widgets to home screen
```

## Last Resort: Debug Build Settings

If still not working, the issue might be related to your free developer account limitations on macOS. Consider:

1. Testing on iOS (works with free account)
2. Using Xcode Previews (shows widgets in canvas)
3. Upgrading to paid Apple Developer account

---

## Contact & Support

If you've tried all solutions and widgets still don't appear on macOS, this is likely a limitation of free Apple Developer accounts with macOS widget extensions. Apple's widget registration system on macOS is stricter than iOS.

**Recommendation**: Test your widgets on iOS Simulator where they will work perfectly with your free account!
