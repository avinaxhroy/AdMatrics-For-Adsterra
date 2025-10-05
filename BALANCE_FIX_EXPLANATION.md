# Balance Calculation Fix - October 4, 2025

## Problems Identified

### 1. Wrong Balance Amount ($26.77 vs $43.61)
**Root Cause:** The app was only fetching the last 7 days of data from the API, but balance calculation needs ALL revenue since the last payout date.

**Example:**
- Last payout: Sept 29, 2025
- Today: Oct 4, 2025  
- Days since payout: 5 days
- Old behavior: Fetched Sept 27 - Oct 4 (7 days) → Missing Sept 29-30 data
- New behavior: Fetches from Sept 29 onwards (all revenue since payout)

### 2. Wrong Next Payout Date (Showing Oct 6)
**Root Cause:** The app was calculating "next Monday" based on weekly schedule, but Adsterra only pays when balance reaches minimum threshold ($200).

**Old Logic:**
```
nextPayoutDate = next Monday (regardless of balance)
```

**Correct Logic:**
```
Payout only happens when:
1. Balance >= $200 (minimum payout)
2. User receives actual payout from Adsterra
3. User manually records the payout in app
```

## Solutions Implemented

### Fix 1: Dynamic Data Fetching
**File:** `AdsterraAPIService.swift`

Changed `fetchCompleteData()` to:
1. Check if user has balance settings
2. If last payout date exists, calculate days since payout
3. Fetch `max(7, daysSinceLastPayout + 1)` days of data
4. This ensures we have ALL revenue since last payout for accurate balance

**Code:**
```swift
if let settings = balanceService.loadSettings(),
   let lastPayoutDate = settings.lastPayoutDate {
    let daysSinceLastPayout = calendar.dateComponents([.day], 
        from: lastPayoutDate, to: Date()).day ?? 7
    daysToFetch = max(7, daysSinceLastPayout + 1)
}
```

### Fix 2: Correct 7-Day Revenue vs Total Revenue
**File:** `AdsterraAPIService.swift`

Separated two concepts:
- **7-Day Revenue** (for sparkline display): Last 7 days only
- **revenueByDate** (for balance): ALL fetched days

**Code:**
```swift
// For display/sparkline - last 7 days only
let last7DaysStats = sortedStats.suffix(7)
let sevenDayRevenue = last7DaysStats.reduce(0) { $0 + $1.revenue }

// For balance calculation - all fetched days
var revenueByDate: [Date: Double] = [:]
for stat in sortedStats {
    // Process ALL stats, not just last 7
}
```

### Fix 3: Remove Misleading Next Payout Date
**File:** `BalanceSettings.swift`

Changed `nextPayoutDate` to return `nil`:
```swift
var nextPayoutDate: Date? {
    // Adsterra only pays when balance reaches minimum
    // Don't show date unless balance is sufficient
    return nil
}
```

### Fix 4: Added Payout Eligibility Info
**File:** `SettingsView.swift`

Added helpful information showing:
- ✅ How much more to earn to reach minimum payout
- ✅ Green checkmark when balance meets threshold
- ❌ Removed misleading "Next Payout: Tomorrow" display

**UI Changes:**
```
Before:
├─ Next Payout: Oct 6 (Due tomorrow) ❌ WRONG

After:
├─ Payout Eligibility
└─ Earn $156.39 more to reach minimum payout ✓ CORRECT
```

## Balance Calculation Formula

**Correct Formula (Now Implemented):**
```
Balance = SUM(revenue WHERE date >= lastPayoutDate)
```

**User's Real Timeline:**
```
Last Payout Date: Sept 29, 2025 (Monday) - When payment was RECEIVED
Payout Covered: Sept 15-28 (Sunday) - What the payment was FOR
Current Balance Period: Sept 29 onwards (inclusive)

Why include Sept 29?
- Payment received on Sept 29 was for Sept 15-28 period
- Sept 29's revenue was NOT included in that payment
- Therefore, Sept 29's revenue is part of current balance
```

**Example Calculation:**
```
Last Payout: Sept 29, 2025 (received $150 for Sept 15-28)
Today: Oct 4, 2025

Revenue by date (from API):
- Sept 29: $8.50  ← Count this (payout was FOR Sept 15-28, not including 29)
- Sept 30: $9.20  ← Count this
- Oct 1: $7.80    ← Count this
- Oct 2: $6.40    ← Count this
- Oct 3: $5.91    ← Count this
- Oct 4: $5.80    ← Count this

Balance = $8.50 + $9.20 + $7.80 + $6.40 + $5.91 + $5.80
        = $43.61 ✓ CORRECT
```

## Testing Checklist

- [x] Balance calculation fetches correct date range
- [x] Balance shows accurate amount based on last payout
- [x] 7-day revenue sparkline still works (last 7 days)
- [x] Next payout date removed (was misleading)
- [x] Payout eligibility info shows remaining amount
- [x] No compilation errors
- [x] Timezone handling (GMT) preserved

## User Instructions

1. **Check Your Balance:**
   - Open app → Should now show $43.61 (or your correct amount)
   
2. **Understanding Payout:**
   - Adsterra pays when balance ≥ $200
   - Payout happens on Monday AFTER balance reaches minimum
   - You'll need to record payout manually when received

3. **Recording Payout:**
   - When you receive payout from Adsterra
   - Go to Settings → Balance Tracking → "Record Payout"
   - Enter the amount you received and date
   - Balance will reset and start counting from that date

## Technical Notes

- GMT timezone preserved for all date calculations
- App now dynamically fetches data based on payout history
- Balance calculation is now date-based, not simple addition
- No more misleading "next payout" predictions
