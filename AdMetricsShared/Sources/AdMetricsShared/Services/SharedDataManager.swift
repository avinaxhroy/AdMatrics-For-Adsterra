//
//  SharedDataManager.swift
//  AdMetrics
//
//  Created on 04/10/2025.
//

import Foundation

/// Manages data sharing between main app and widget extension
/// Uses iCloud Key-Value Storage which works with FREE Apple Developer accounts!
/// Based on LockInNote approach: https://github.com/FlipByBlink/LockInNote
class SharedDataManager {
    static let shared = SharedDataManager()
    
    // iCloud KV Store - works with free account and shares between app and widget
    private let store = NSUbiquitousKeyValueStore.default
    
    private init() {
        // Synchronize with iCloud
        store.synchronize()
    }
    
    // MARK: - Widget Data
    
    func saveWidgetData(_ data: WidgetData) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(data)
            store.set(jsonData, forKey: "com.admetrics.widgetData")
            store.synchronize()
            print("✅ Widget data saved to iCloud KV Store")
        } catch {
            print("❌ Failed to save widget data: \(error.localizedDescription)")
        }
    }
    
    func loadWidgetData() -> WidgetData? {
        guard let jsonData = store.data(forKey: "com.admetrics.widgetData") else {
            print("⚠️ No widget data found in iCloud KV Store")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode(WidgetData.self, from: jsonData)
            print("✅ Widget data loaded from iCloud KV Store")
            return decoded
        } catch {
            print("❌ Failed to load widget data: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Last Update Time
    
    func saveLastUpdateTime(_ date: Date) {
        store.set(date, forKey: "com.admetrics.lastUpdateTime")
        store.synchronize()
    }
    
    func loadLastUpdateTime() -> Date? {
        return store.object(forKey: "com.admetrics.lastUpdateTime") as? Date
    }
    
    // MARK: - Settings
    
    func saveRefreshInterval(_ interval: String) {
        store.set(interval, forKey: "com.admetrics.refreshInterval")
        store.synchronize()
    }
    
    func loadRefreshInterval() -> String? {
        return store.string(forKey: "com.admetrics.refreshInterval")
    }
    
    func saveWidgetTheme(_ theme: String) {
        store.set(theme, forKey: "com.admetrics.widgetTheme")
        store.synchronize()
    }
    
    func loadWidgetTheme() -> String? {
        return store.string(forKey: "com.admetrics.widgetTheme")
    }
    
    // MARK: - Cache Management
    
    func clearCache() {
        store.removeObject(forKey: "com.admetrics.widgetData")
        store.removeObject(forKey: "com.admetrics.lastUpdateTime")
        store.removeObject(forKey: "com.admetrics.refreshInterval")
        store.removeObject(forKey: "com.admetrics.widgetTheme")
        store.synchronize()
        print("🗑️ Cache cleared")
    }
}

