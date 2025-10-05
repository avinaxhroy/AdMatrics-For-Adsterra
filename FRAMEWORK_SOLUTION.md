# Shared Framework Solution for FREE Apple Developer Account

## The Problem
- **Widget Not Showing Data**: Main app and widget cannot share data via traditional methods
- **FREE Account Limitations**: 
  - ❌ No App Groups (requires paid account)
  - ❌ No iCloud Key-Value Store (requires paid account)
  - ❌ File sharing blocked by sandbox isolation
  - ❌ UserDefaults don't share between app and extension

## The Solution: Shared Swift Package
Based on open-source apps like **CalendarX**, we're using a **local Swift Package** that both the main app and widget can link to.

### How It Works
```
AdMetricsShared (Swift Package)
    ├── Models (WidgetData, TopPlacement, etc.)
    ├── Services (SharedDataManager - in-memory cache)
    └── Utilities (FormatHelpers)
    
Main App ─────► Links AdMetricsShared ◄───── Widget Extension
```

### Key Strategy
1. **Shared Code**: Both targets use the SAME compiled code from the package
2. **Independent Data**: Each process (app and widget) fetches data independently
3. **API Service**: Widget calls API directly (with cached API key)
4. **No Data Sharing Needed**: Each process maintains its own data

## Implementation

### 1. Swift Package Structure
```
AdMetricsShared/
  ├── Package.swift
  └── Sources/
      └── AdMetricsShared/
          ├── Models/
          │   └── WidgetData.swift (PUBLIC)
          ├── Services/
          │   ├── SharedDataManager.swift
          │   └── CacheService.swift
          └── Utilities/
              └── FormatHelpers.swift (PUBLIC)
```

### 2. Main App Integration
- **Imports**: `import AdMetricsShared` instead of relative imports
- **Data Flow**: App saves widget data to in-memory cache (for app's own use)
- **Widget Trigger**: User adds widget → Widget makes API call independently

### 3. Widget Integration
- **Imports**: `import AdMetricsShared` for models and utilities
- **Data Source**: Widget calls `AdsterraAPIService` directly (copied to widget target)
- **API Key**: Widget retrieves API key from UserDefaults (stored by main app)
- **Timeline**: WidgetKit timeline provider refreshes at specified intervals

## Next Steps

### Step 1: Add Package to Xcode Project
```bash
# In Xcode:
File → Add Package Dependencies → Add Local... → Select AdMetricsShared folder
```

### Step 2: Link Package to Targets
- **Main App Target**: Add AdMetricsShared to "Frameworks, Libraries, and Embedded Content"
- **Widget Extension Target**: Add AdMetricsShared to "Frameworks, Libraries, and Embedded Content"

### Step 3: Update Imports
Replace all:
```swift
// OLD
import "../Shared/Models/WidgetData.swift"

// NEW
import AdMetricsShared
```

### Step 4: Widget API Service
Copy `AdsterraAPIService.swift` to widget target so it can make API calls independently:
```swift
// Widget will fetch data on its own timeline
func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let apiKey = UserDefaults.standard.string(forKey: "adsterra_api_key")
    // Make API call
    // Create timeline entries
}
```

## Why This Works with FREE Account

✅ **No App Groups Needed**: Package is linked at compile time, not runtime data sharing  
✅ **No iCloud Needed**: Each process has independent data  
✅ **Sandbox Compatible**: Widget makes its own API calls (network.client permission)  
✅ **No Provisioning Issues**: Standard linking, no advanced capabilities required  

## Benefits

1. **Shared Code**: Models, utilities, formatters all in one place
2. **Type Safety**: Both app and widget use the same data structures
3. **Independent Operation**: Widget doesn't depend on app running
4. **Fresh Data**: Widget fetches latest data on its own schedule
5. **FREE Account Compatible**: No paid features required

## Testing

1. **Build Project**: Should compile without errors
2. **Add Widget**: Widget should appear in Widget Gallery
3. **Configure Widget**: Widget makes API call and displays data
4. **App Changes**: API key changes in app automatically used by widget (via UserDefaults)

## Reference Projects

- **CalendarX**: https://github.com/richardtop/CalendarX (uses CalendarXLib)
- **LockInNote**: https://github.com/FlipByBlink/LockInNote (iCloud KV - needs paid account)
- **HNWidgets**: https://github.com/yarokhovich/HNWidgets (shared framework pattern)
