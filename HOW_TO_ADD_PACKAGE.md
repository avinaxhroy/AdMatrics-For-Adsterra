# Adding AdMetricsShared Package to Xcode Project

## Steps to Link the Framework

### 1. Open Project in Xcode
```bash
open /Users/avinash/Documents/AdMetrics/AdMetrics.xcodeproj
```

### 2. Add Local Package
1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Click the **Add Local...** button (bottom left)
3. Navigate to and select the `AdMetricsShared` folder
4. Click **Add Package**

### 3. Link to Main App Target
1. Select the **AdMetrics** project in the navigator
2. Select the **AdMetrics** target
3. Go to the **General** tab
4. Scroll to **Frameworks, Libraries, and Embedded Content**
5. Click the **+** button
6. Select **AdMetricsShared** from the list
7. Set to **Embed & Sign**

### 4. Link to Widget Extension Target
1. Still in project settings, select the **AdMetricsWidgetExtension** target
2. Go to the **General** tab
3. Scroll to **Frameworks, Libraries, and Embedded Content**
4. Click the **+** button
5. Select **AdMetricsShared** from the list
6. Set to **Embed & Sign**

### 5. Update Imports in Code
Replace relative imports with package imports:

**In Main App Files:**
```swift
// OLD
// (relative path imports)

// NEW
import AdMetricsShared
```

**In Widget Files:**
```swift
// OLD  
// (relative path imports)

// NEW
import AdMetricsShared
```

### 6. Build and Test
```bash
# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData/AdMetrics-*

# Build from command line
cd /Users/avinash/Documents/AdMetrics
xcodebuild -project AdMetrics.xcodeproj -scheme AdMetrics -configuration Debug clean build

# Or build in Xcode
# Product → Clean Build Folder (Cmd+Shift+K)
# Product → Build (Cmd+B)
```

## Expected Result

✅ Project builds successfully  
✅ Both app and widget can `import AdMetricsShared`  
✅ Widget displays data (fetched independently via API)  

## Troubleshooting

### "No such module 'AdMetricsShared'"
- Make sure the package is added to **both** targets
- Clean build folder and rebuild
- Check that the package is in the project navigator

### Build Errors
- Verify all public properties have `public` keyword
- Check that Package.swift is correctly configured
- Make sure swift-tools-version matches your Xcode version

### Widget Still Shows "No Data"
- This is expected until we copy AdsterraAPIService to the widget target
- Next step: Update widget to make independent API calls
