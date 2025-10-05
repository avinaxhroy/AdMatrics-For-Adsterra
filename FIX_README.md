# 🔧 Fix for "Endpoint not found" Error

## Quick Start - Find the Correct API Endpoint ⚡

The fastest way to fix this is to run the quick test script:

```bash
cd /Users/avinash/Documents/AdMetrics
./quick_test.sh YOUR_API_KEY
```

**Replace `YOUR_API_KEY` with your actual Adsterra API token.**

The script will:
- ✅ Test the 3 most common Adsterra API endpoints
- ✅ Tell you which one works
- ✅ Show you exactly what to change in the code

## What's the Problem?

You're getting a **404 "Endpoint not found"** error because the API base URL in the code doesn't match Adsterra's current API endpoints. This could be because:

- Adsterra updated their API URL
- Your account uses a different API version
- The API documentation used was outdated

## Solution

### Step 1: Find the Correct Endpoint

Choose one method:

**Method A - Quick Test Script** (Fastest! ⚡)
```bash
./quick_test.sh YOUR_API_KEY
```

**Method B - Comprehensive Test** (Tests more options)
```bash
./test_api.sh YOUR_API_KEY
```

**Method C - Manual curl Test**
```bash
curl -v -X GET "https://api3.adsterratools.com/publisher/profile.json" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Accept: application/json"
```

### Step 2: Update the Code

Once you find the working endpoint, update this file:

**File:** `AdMetrics/Services/AdsterraAPIService.swift`  
**Line:** 14

Change from:
```swift
private let baseURL = "https://api3.adsterratools.com/publisher"
```

To the working base URL, for example:
```swift
private let baseURL = "https://publishers.adsterra.com/api/v2/publisher"
```

### Step 3: Rebuild

1. Open the project in Xcode
2. Clean build folder: `Product` → `Clean Build Folder` (⌘ + Shift + K)
3. Build and run: `Product` → `Run` (⌘ + R)

## Common Working Endpoints

Try these if the scripts don't work:

| Base URL | Notes |
|----------|-------|
| `https://publishers.adsterra.com/api/v2/publisher` | V2 API (common) |
| `https://api3.adsterratools.com/v3/publisher` | V3 with version path |
| `https://api.adsterratools.com/publisher/v1` | V1 API |
| `https://api3.adsterratools.com/publisher` | Current (may be outdated) |

## Still Not Working?

### Check Xcode Debug Logs

I've added detailed logging. To see it:

1. Run app in Xcode
2. Open Console: `View` → `Debug Area` → `Activate Console` (⌘ + Shift + Y)
3. Enter your API key
4. Look for logs like:
```
🌐 API Request:
   URL: https://api3.adsterratools.com/publisher/profile.json

📥 API Response:
   Status: 404
```

### Check Adsterra Documentation

1. Log into: https://beta.publishers.adsterra.com
2. Navigate to: `Settings` → `API` or `API Tokens`
3. Look for API Documentation or Base URL
4. Compare with the code

### Contact Adsterra Support

If nothing works:
1. Screenshot the error
2. Copy the debug logs from Xcode (redact your API key!)
3. Contact Adsterra support
4. Ask for: "Current API base URL for publisher statistics"

## Files in This Project

- **quick_test.sh** - Fast endpoint tester (3 common URLs)
- **test_api.sh** - Comprehensive endpoint tester (6+ URLs)
- **API_TROUBLESHOOTING.md** - Detailed troubleshooting guide
- **CHANGES_MADE.md** - What was modified and why

## Example: Full Working Flow

```bash
# 1. Test to find correct endpoint
$ ./quick_test.sh YOUR_API_KEY

🔍 Testing Adsterra API Endpoints...

1. Testing current endpoint...
   ❌ Failed with status: 404

2. Testing alternative v2 endpoint...
   ✅ This endpoint works!

   📝 Update line 14 in AdsterraAPIService.swift to:
   private let baseURL = "https://publishers.adsterra.com/api/v2/publisher"

# 2. Open in Xcode
$ open AdMetrics.xcodeproj

# 3. Update AdsterraAPIService.swift line 14
# 4. Clean + Build + Run
# 5. Test with your API key ✅
```

## Need Help?

The debug logs will show exactly what's happening. Share them (with API key redacted) if you need more help!

---

**Quick Command Reference:**
```bash
# Navigate to project
cd /Users/avinash/Documents/AdMetrics

# Run quick test
./quick_test.sh YOUR_API_KEY

# Run comprehensive test  
./test_api.sh YOUR_API_KEY

# Open in Xcode
open AdMetrics.xcodeproj
```
