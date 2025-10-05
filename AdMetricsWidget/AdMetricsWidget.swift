//
//  AdMetricsWidget.swift
//  AdMetricsWidget
//
//  Created on 03/10/2025.
//

import Foundation
import WidgetKit
import SwiftUI
import AdMetricsShared

// MARK: - Widget Entry
struct WidgetEntry: TimelineEntry {
    let date: Date
    let data: WidgetData?
    let error: Error?
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(
            date: Date(),
            data: placeholderData(),
            error: nil
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry: WidgetEntry
        
        if context.isPreview {
            entry = WidgetEntry(date: Date(), data: placeholderData(), error: nil)
        } else {
            // For snapshots, try to load cached data first for instant display
            entry = loadCachedEntry()
        }
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        // Fetch fresh data from API
        Task {
            let entry = await fetchEntry()
            
            // Determine next refresh time (default: 30 minutes)
            let refreshInterval: TimeInterval = 1800 // 30 minutes
            let nextUpdate = Date().addingTimeInterval(refreshInterval)
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    // Fetch fresh data from Adsterra API
    private func fetchEntry() async -> WidgetEntry {
        // Get API key from shared file storage
        guard let apiKey = SharedFileStorage.shared.loadAPIKey(),
              !apiKey.isEmpty else {
            print("⚠️ [Widget] No API key found in shared storage")
            return WidgetEntry(
                date: Date(),
                data: nil,
                error: NSError(domain: "AdMetricsWidget", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "API key not configured. Please open the app first."
                ])
            )
        }
        
        print("🔄 [Widget] Fetching data from API...")
        
        let apiService = WidgetAPIService()
        
        do {
            let data = try await apiService.fetchWidgetData(apiKey: apiKey)
            print("✅ [Widget] Data fetched successfully")
            
            // Cache the data for quick access
            SharedFileStorage.shared.saveWidgetData(data)
            
            return WidgetEntry(date: Date(), data: data, error: nil)
        } catch {
            print("❌ [Widget] Fetch failed: \(error.localizedDescription)")
            
            // Try to load cached data as fallback
            if let cachedData = SharedFileStorage.shared.loadWidgetData() {
                print("📦 [Widget] Using cached data as fallback")
                return WidgetEntry(date: Date(), data: cachedData, error: error)
            }
            
            return WidgetEntry(date: Date(), data: nil, error: error)
        }
    }
    
    // Load cached data (for quick display in snapshots)
    private func loadCachedEntry() -> WidgetEntry {
        if let data = SharedFileStorage.shared.loadWidgetData() {
            return WidgetEntry(date: Date(), data: data, error: nil)
        } else {
            return WidgetEntry(date: Date(), data: nil, error: nil)
        }
    }
    
    private func placeholderData() -> WidgetData {
        WidgetData(
            balance: 1234.56,
            currency: "USD",
            todayRevenue: 45.67,
            impressions: 125000,
            clicks: 850,
            ctr: 0.68,
            cpm: 2.45,
            last7DaysRevenue: [30.0, 35.0, 28.0, 42.0, 38.0, 45.0, 45.67],
            topPlacements: [
                TopPlacement(id: 1, name: "Homepage Banner", revenue: 25.30, impressions: 45000),
                TopPlacement(id: 2, name: "Sidebar Ad", revenue: 15.20, impressions: 32000),
                TopPlacement(id: 3, name: "Footer Link", revenue: 5.17, impressions: 18000)
            ],
            lastUpdated: Date()
        )
    }
}

// MARK: - Small Widget
struct SmallAdMetricsWidget: Widget {
    let kind: String = "SmallAdMetricsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SmallWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.3, blue: 0.6),
                            Color(red: 0.08, green: 0.2, blue: 0.45)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Balance")
        .description("View your account balance and today's earnings")
#if os(macOS)
        .supportedFamilies([.systemSmall, .systemMedium])
#else
        .supportedFamilies([.systemSmall])
#endif
    }
}

// MARK: - Medium Widget
struct MediumAdMetricsWidget: Widget {
    let kind: String = "MediumAdMetricsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MediumWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.3, blue: 0.6),
                            Color(red: 0.08, green: 0.2, blue: 0.45)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Quick Stats")
        .description("Balance, revenue, and key metrics")
#if os(macOS)
        .supportedFamilies([.systemMedium, .systemLarge])
#else
        .supportedFamilies([.systemMedium])
#endif
    }
}

// MARK: - Large Widget
struct LargeAdMetricsWidget: Widget {
    let kind: String = "LargeAdMetricsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LargeWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.3, blue: 0.6),
                            Color(red: 0.08, green: 0.2, blue: 0.45)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Dashboard")
        .description("Complete stats with trends and top placements")
#if os(macOS)
        .supportedFamilies([.systemLarge, .systemExtraLarge])
#else
        .supportedFamilies([.systemLarge])
#endif
    }
}

// MARK: - Widget Bundle
@main
struct AdMetricsWidgetBundle: WidgetBundle {
    var body: some Widget {
        SmallAdMetricsWidget()
        MediumAdMetricsWidget()
        LargeAdMetricsWidget()
    }
}
