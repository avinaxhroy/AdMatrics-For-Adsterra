//
//  SharedFileStorage.swift
//  AdMetrics
//
//  Created on 04/10/2025.
//  Simple file-based storage for sharing data between app and widget (FREE account compatible)
//

import Foundation
import AdMetricsShared

/// File-based storage that works without App Groups
/// Uses ~/Library/Application Support/AdMetrics/ which is accessible to both app and widget
final class SharedFileStorage {
    static let shared = SharedFileStorage()
    
    private let fileManager = FileManager.default
    private let sharedDirectory: URL
    
    private init() {
        // SMART SOLUTION for FREE account:
        // Main app (unsandboxed) writes to WIDGET's sandbox container
        // Widget (sandboxed) reads from its own Application Support directory
        
        // Detect if we're running in a widget extension
        let isWidget = Bundle.main.bundleIdentifier?.contains("AdMetricsWidget") ?? false
        
        if isWidget {
            // Widget: Use standard Application Support (inside its sandbox)
            let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            sharedDirectory = appSupport.appendingPathComponent("AdMetrics", isDirectory: true)
        } else {
            // Main app: Write to widget's container (since app is unsandboxed)
            let homeDir = fileManager.homeDirectoryForCurrentUser
            let widgetContainer = homeDir
                .appendingPathComponent("Library/Containers/me.avinas.AdMetrics.AdMetricsWidget/Data/Library/Application Support", isDirectory: true)
                .appendingPathComponent("AdMetrics", isDirectory: true)
            sharedDirectory = widgetContainer
        }
        
        // Create directory if needed
        try? fileManager.createDirectory(at: sharedDirectory, withIntermediateDirectories: true)
        
        // Set world-readable permissions
        try? fileManager.setAttributes([.posixPermissions: 0o755], ofItemAtPath: sharedDirectory.path)
        
        print("📁 Shared storage [\(isWidget ? "Widget" : "App")]: \(sharedDirectory.path)")
    }
    
    // MARK: - API Key Storage
    
    func saveAPIKey(_ key: String) {
        let fileURL = sharedDirectory.appendingPathComponent("api_key.txt")
        
        do {
            try key.write(to: fileURL, atomically: true, encoding: .utf8)
            
            // Set file permissions to be readable
            try fileManager.setAttributes([.posixPermissions: 0o644], ofItemAtPath: fileURL.path)
            
            print("✅ API key saved to: \(fileURL.path)")
        } catch {
            print("❌ Failed to save API key: \(error)")
        }
    }
    
    func loadAPIKey() -> String? {
        let fileURL = sharedDirectory.appendingPathComponent("api_key.txt")
        
        do {
            let key = try String(contentsOf: fileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
            print("✅ API key loaded from: \(fileURL.path)")
            return key
        } catch {
            print("⚠️ Could not load API key: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteAPIKey() {
        let fileURL = sharedDirectory.appendingPathComponent("api_key.txt")
        try? fileManager.removeItem(at: fileURL)
        print("🗑️ API key deleted")
    }
    
    // MARK: - Widget Data Cache
    
    func saveWidgetData(_ data: WidgetData) {
        let fileURL = sharedDirectory.appendingPathComponent("widget_data.json")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: fileURL)
            
            print("💾 Widget data cached to: \(fileURL.path)")
        } catch {
            print("❌ Failed to cache widget data: \(error)")
        }
    }
    
    func loadWidgetData() -> WidgetData? {
        let fileURL = sharedDirectory.appendingPathComponent("widget_data.json")
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let data = try decoder.decode(WidgetData.self, from: jsonData)
            print("📦 Widget data loaded from cache")
            return data
        } catch {
            print("⚠️ Could not load cached widget data: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Balance Settings Storage (for widget balance calculation)
    
    func saveBalanceSettings(_ settingsJSON: String) {
        let fileURL = sharedDirectory.appendingPathComponent("balance_settings.json")
        
        do {
            try settingsJSON.write(to: fileURL, atomically: true, encoding: .utf8)
            try fileManager.setAttributes([.posixPermissions: 0o644], ofItemAtPath: fileURL.path)
            print("✅ Balance settings saved to: \(fileURL.path)")
        } catch {
            print("❌ Failed to save balance settings: \(error)")
        }
    }
    
    func loadBalanceSettingsJSON() -> String? {
        let fileURL = sharedDirectory.appendingPathComponent("balance_settings.json")
        
        do {
            let json = try String(contentsOf: fileURL, encoding: .utf8)
            print("✅ Balance settings loaded from: \(fileURL.path)")
            return json
        } catch {
            print("⚠️ Could not load balance settings: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteBalanceSettings() {
        let fileURL = sharedDirectory.appendingPathComponent("balance_settings.json")
        try? fileManager.removeItem(at: fileURL)
        print("🗑️ Balance settings deleted")
    }
}
