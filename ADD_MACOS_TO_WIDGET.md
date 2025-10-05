# 🔧 FIX: Add macOS Support to Widget Extension Target

## The Problem

AdMetricsWidgetExtension target only supports iOS, not macOS!

That's why when you click on it in Target Membership, there's no macOS checkbox.

---

## ✅ THE FIX

### Step 1: Select Widget Extension Target

1. **Click on "AdMetrics.xcodeproj"** (blue icon at top of Project Navigator)

2. **In the left panel of main editor**, you'll see list of targets:
   ```
   PROJECT
     AdMetrics
   
   TARGETS
     AdMetrics                    ← Main app
     AdMetricsWidgetExtension     ← Click this one!
   ```

3. **Click on "AdMetricsWidgetExtension"**

---

### Step 2: Go to General Tab

At the top of the main editor, click **"General"** tab

---

### Step 3: Find "Supported Destinations"

Look for a section called:
- **"Supported Destinations"** OR
- **"Deployment Info"**

You'll probably see:
```
Supported Destinations:
  iPhone
  iPad
```

---

### Step 4: Add macOS

**Click the "+" button** next to Supported Destinations

**Select "Mac"** or "macOS" from the dropdown

Now it should show:
```
Supported Destinations:
  iPhone
  iPad  
  Mac          ← Added!
```

---

### Alternative Method: Build Settings

If you don't see "Supported Destinations":

1. **Click "Build Settings" tab** (next to General)

2. **Search for**: "Supported Platforms"

3. **You'll see**:
   ```
   Supported Platforms: iphoneos iphonesimulator
   ```

4. **Change to**:
   ```
   Supported Platforms: iphoneos iphonesimulator macosx
   ```

---

### Step 5: Do the Same for Main App Target

While you're here, also check **AdMetrics** (main app) target:

1. Click on "AdMetrics" target
2. General tab
3. Make sure "Supported Destinations" includes Mac

---

### Step 6: Now Try Again

After adding macOS support:

1. **Select any shared file** (like SharedDataManager.swift)
2. **Open File Inspector** (⌘ + Option + 1)
3. **Click on "AdMetricsWidgetExtension" in Target Membership**
4. **NOW you should see macOS checkbox!** ✅

---

## 🎯 Complete Steps Summary

```
1. Project file → AdMetricsWidgetExtension target
2. General tab
3. Supported Destinations → Add "Mac"
4. Save
5. Now shared files can have macOS checked for widget
6. Build widget: ⌘ + B
7. Run app: ⌘ + R
8. Add widget: Right-click → Edit Widgets
```

---

## 📱 What This Does

By adding macOS to "Supported Destinations":
- Widget extension can now run on macOS
- When you add files to widget target, macOS platform option appears
- Widgets will show up in macOS widget gallery

---

**Try Step 4 (adding Mac to Supported Destinations) and let me know if you now see macOS option!** 🚀
