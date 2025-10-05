//
//  SharedDataManager.swift
//  AdMetrics
//
//  Created on 04/10/2025.
//

import Foundation

/// Manages data sharing between main app and widget extension
/// Using in-memory cache that's populated by both app and widget independently
class SharedDataManager {
    static let shared = SharedDataManager()
    
    // In-memory cache
    private var cachedWidgetData: WidgetData?
    private var cachedSettings: [String: Any] = [:]
    
    private init() {}
    
    // MARK: - Widget Data
    
    func saveWidgetData(_ data: WidgetData) {
        self.cachedWidgetData = data
        print("✅ Widget data cached in memory")
    }
    
    func loadWidgetData() -> WidgetData? {
        return cachedWidgetData
    }
    
    // MARK: - Last Update Time
    
    func saveLastUpdateTime(_ date: Date) {
        cachedSettings["lastUpdateTime"] = date
    }
    
    func loadLastUpdateTime() -> Date? {
        return cachedSettings["lastUpdateTime"] as? Date
    }
    
    // MARK: - Settings
    
    func saveRefreshInterval(_ interval: String) {
        cachedSettings["refreshInterval"] = interval
    }
    
    func loadRefreshInterval() -> String? {
        return cachedSettings["refreshInterval"] as? String
    }
    
    func saveWidgetTheme(_ theme: String) {
        cachedSettings["widgetTheme"] = theme
    }
    
    func loadWidgetTheme() -> String? {
        return cachedSettings["widgetTheme"] as? String
    }
    
    // MARK: - Cache Management
    
    func clearCache() {
        cachedWidgetData = nil
        cachedSettings.removeAll()
        print("🗑️ Cache cleared")
    }
}

