# 🎉 macOS Widget Setup (FREE Apple Developer Account)

## ✅ Changes Made

Your app has been updated to work **WITHOUT** a paid Apple Developer account!

### What Was Fixed:
1. **Removed App Sandbox** - Not required for development
2. **Removed App Groups** - Requires paid account
3. **Removed Keychain Access Groups** - Requires paid account
4. **File-Based Data Sharing** - Uses shared Application Support directory

---

## 🚀 How to Test Your Widgets

### Step 1: Clean Build & Run
```bash
1. Open Terminal
2. Run this command:
   cd /Users/avinash/Documents/AdMetrics
   xcodebuild -project AdMetrics.xcodeproj -scheme AdMetrics clean build
   
3. Or in Xcode:
   - Select "AdMetrics" scheme
   - Device: "My Mac"
   - Product → Clean Build Folder (⌘⇧K)
   - Product → Build (⌘B)
   - Product → Run (⌘R)
```

### Step 2: Load Data in Main App
```bash
1. App launches on your Mac
2. Enter your Adsterra API key
3. Load data successfully
4. Check console output for:
   "✅ Widget data saved successfully to: /Users/.../Application Support/AdMetrics-Shared/widget-data.json"
```

### Step 3: Verify Data File
```bash
# Check if the data file was created:
ls -la ~/Library/Application\ Support/AdMetrics-Shared/

# You should see:
# widget-data.json
```

### Step 4: Add Widget to macOS

#### Method 1: Widget Gallery
```
1. Click on your Desktop
2. Right-click (or Control + Click)
3. Select "Edit Widgets"
4. Search for "AdMetrics"
5. Drag widget to Notification Center or Desktop
```

#### Method 2: Notification Center
```
1. Click the date/time in menu bar (top-right)
2. Scroll down
3. Click "Edit Widgets" button
4. Search for "AdMetrics"
5. Add your preferred widget
```

---

## 📊 Available Widget Sizes

**Small Widget - "Balance"**
- Shows: Balance + Today's Revenue
- Best for: Quick glance at earnings

**Medium Widget - "Quick Stats"**
- Shows: Balance, Revenue, Chart
- Best for: Desktop placement

**Large Widget - "Dashboard"**
- Shows: Complete stats with trends
- Best for: Notification Center

---

## 🐛 Troubleshooting

### Widget Not Appearing?
```bash
# 1. Check if widget extension is built:
ls -la ~/Library/Developer/Xcode/DerivedData/AdMetrics-*/Build/Products/Release/

# You should see:
# AdMetrics.app
# AdMetricsWidgetExtension.appex (inside AdMetrics.app)

# 2. Force refresh widgets:
killall Dock
```

### Widget Shows "No Data"?
```bash
# 1. Check data file exists:
cat ~/Library/Application\ Support/AdMetrics-Shared/widget-data.json

# 2. Re-run main app and load data again

# 3. Check console logs in Xcode when app saves data
```

### Widget Not Updating?
```bash
# Widgets update based on Timeline Provider
# Default: Every 30 minutes
# Force refresh by removing and re-adding widget
```

---

## 🔧 Technical Details

### Data Sharing Method
- **Location**: `~/Library/Application Support/AdMetrics-Shared/`
- **Format**: JSON file
- **Files**:
  - `widget-data.json` - Main stats data
  - `refresh-interval.txt` - Update frequency
  - `widget-theme.txt` - Theme preference

### Why This Works Without App Groups:
- Both app and widget can access Application Support directory
- No special entitlements needed
- Works on free Apple Developer account
- No code signing issues

---

## ✨ Next Steps

1. **Run the main app** (⌘R in Xcode)
2. **Load your data** with API key
3. **Verify file creation** in Terminal
4. **Add widget** to macOS
5. **Enjoy your stats!**

---

## 📝 Notes

- Widgets work on **macOS 14.0+**
- No iOS Simulator needed
- Main app must run at least once to create data
- Widgets update automatically based on Timeline
- You can have multiple widgets on screen

---

## 🎯 Success Indicators

✅ Build succeeds without errors
✅ Console shows "Widget data saved successfully"
✅ Data file exists in Application Support
✅ Widget appears in Widget Gallery
✅ Widget shows your real data

---

Need help? Check the console logs in Xcode for detailed output!
