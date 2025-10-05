# Adsterra API Troubleshooting Guide

## Issue: "Endpoint not found" Error (404)

You're getting a 404 error after entering your API key, which means the API endpoint URL is incorrect or has changed.

## Solutions to Try

### 1. **Verify the Correct API Endpoint** ✅ MOST LIKELY FIX

The Adsterra API may have different base URLs depending on your account type or API version. Check your Adsterra dashboard for the correct API endpoint.

**Current endpoint in code:**
```
https://api3.adsterratools.com/publisher/profile.json
https://api3.adsterratools.com/publisher/stats.json
https://api3.adsterratools.com/publisher/placements.json
```

**Possible Alternative Endpoints to Try:**

Open `AdMetrics/Services/AdsterraAPIService.swift` and try changing line 14 from:
```swift
private let baseURL = "https://api3.adsterratools.com/publisher"
```

To one of these alternatives:

**Option A:**
```swift
private let baseURL = "https://publishers.adsterra.com/api/v2/publisher"
```

**Option B:**
```swift
private let baseURL = "https://api.adsterratools.com/publisher/v1"
```

**Option C:**
```swift
private let baseURL = "https://api3.adsterratools.com/v3/publisher"
```

**Option D (Without trailing path):**
```swift
private let baseURL = "https://api3.adsterratools.com"
```
And update the endpoint methods to:
```swift
let endpoint = "\(baseURL)/publisher/profile.json"
let endpoint = "\(baseURL)/publisher/stats.json?start=\(start)&finish=\(end)"
let endpoint = "\(baseURL)/publisher/placements.json"
```

### 2. **Check API Documentation**

1. Log into your Adsterra Publisher account
2. Go to: **Settings** → **API** → **Documentation** or **API Tokens**
3. Look for:
   - API Base URL
   - API Version
   - Example curl commands
4. Compare with the endpoints in `AdsterraAPIService.swift`

### 3. **Test API Manually with curl**

Open Terminal and test the API directly (replace `YOUR_API_KEY` with your actual key):

```bash
# Test profile endpoint
curl -X GET "https://api3.adsterratools.com/publisher/profile.json" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Accept: application/json" \
  -v

# If that fails, try alternative URLs:
curl -X GET "https://publishers.adsterra.com/api/v2/publisher/profile" \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Accept: application/json" \
  -v
```

Look for:
- **200 OK** = Success! This is the correct endpoint
- **404 Not Found** = Wrong endpoint URL
- **401 Unauthorized** = Wrong API key or header format
- **403 Forbidden** = API key might be expired

### 4. **Check API Authentication Header**

Some APIs use different header names. Try changing in `AdsterraAPIService.swift` line 103:

From:
```swift
request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
```

To one of these:
```swift
request.setValue(apiKey, forHTTPHeaderField: "Authorization")
// OR
request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
// OR
request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
```

### 5. **Enable Debug Logging**

I've already added detailed logging. To see the logs:

1. Build and run the app in Xcode
2. Open the **Debug Console** (View → Debug Area → Activate Console)
3. Enter your API key
4. Watch for log output that starts with:
   - 🌐 API Request: (shows the exact URL being called)
   - 📥 API Response: (shows the response)
   - ❌ 404 Error (shows detailed error info)

This will show you exactly what URL is being called and what the server is returning.

### 6. **Check API Version Support**

The Adsterra API might have multiple versions. Contact Adsterra support or check their documentation for:
- Current API version
- Whether the v3 API endpoints are still active
- If you need to migrate to a newer version

### 7. **Verify Account Permissions**

- Ensure your Adsterra account has API access enabled
- Check if your API token has the necessary permissions (read stats, read profile, etc.)
- Try regenerating your API token in the dashboard

## How to Apply Logs and Test

1. **Run the app in Xcode**
2. **Open the Debug Console**: `⌘ + ⇧ + Y` (or View → Debug Area → Show Debug Area)
3. **Enter your API key** in the app
4. **Check the console output** for the actual URLs being called
5. **Share the console output** (without your API key) to get more specific help

## Expected Console Output

```
🌐 API Request:
   URL: https://api3.adsterratools.com/publisher/profile.json
   Headers: ["X-API-Key": "***", "Accept": "application/json"]

📥 API Response:
   Status: 404
   Body: {"error": "Endpoint not found"}
```

This will tell us exactly what's wrong!

## Quick Fix Code Changes

If you find the correct endpoint from the Adsterra documentation, here's what to update:

**File: `AdMetrics/Services/AdsterraAPIService.swift`**

Line 14 - Update base URL:
```swift
private let baseURL = "YOUR_CORRECT_BASE_URL"
```

Lines 52, 68, 82, 92 - Update endpoint paths if needed:
```swift
let endpoint = "\(baseURL)/YOUR_CORRECT_PATH"
```

## Additional Resources

- Adsterra API Documentation: https://docs.adsterratools.com
- Adsterra Support: Contact through your dashboard
- API Token Page: https://beta.publishers.adsterra.com/api-token

## Still Having Issues?

If you've tried all of the above:

1. Copy the **console logs** from Xcode (with API key redacted)
2. Screenshot any error messages from Adsterra dashboard
3. Note which account type you have (Publisher, Advertiser, etc.)
4. Check if there's an API version selector in your Adsterra dashboard

The most common fix is updating the `baseURL` to match what Adsterra's current API documentation specifies!
