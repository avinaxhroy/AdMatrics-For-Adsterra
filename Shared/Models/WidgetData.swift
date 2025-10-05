//
//  WidgetData.swift
//  Shared
//
//  Created on 03/10/2025.
//

import Foundation

struct WidgetData: Codable, Equatable {
    let balance: Double
    let currency: String
    let todayRevenue: Double
    let impressions: Int
    let clicks: Int
    let ctr: Double
    let cpm: Double
    let last7DaysRevenue: [Double]
    let topPlacements: [TopPlacement]
    let lastUpdated: Date
    
    var formattedBalance: String {
        FormatHelpers.formatCurrency(balance, currency: currency)
    }
    
    var formattedTodayRevenue: String {
        FormatHelpers.formatCurrency(todayRevenue, currency: currency)
    }
    
    var formattedImpressions: String {
        FormatHelpers.formatCompactNumber(impressions)
    }
    
    var formattedClicks: String {
        FormatHelpers.formatCompactNumber(clicks)
    }
    
    var formattedCTR: String {
        FormatHelpers.formatPercentage(ctr)
    }
    
    var formattedCPM: String {
        FormatHelpers.formatCurrency(cpm, currency: currency)
    }
    
    var isStale: Bool {
        Date().timeIntervalSince(lastUpdated) > 1800 // 30 minutes
    }
    
    var timeAgo: String {
        FormatHelpers.timeAgo(from: lastUpdated)
    }
    
    var lastUpdatedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastUpdated, relativeTo: Date())
    }
}

struct TopPlacement: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let revenue: Double
    let impressions: Int
    
    func formattedRevenue(currency: String) -> String {
        FormatHelpers.formatCurrency(revenue, currency: currency)
    }
    
    var formattedImpressions: String {
        FormatHelpers.formatCompactNumber(impressions)
    }
}

enum RefreshInterval: String, CaseIterable, Identifiable {
    case fiveMinutes = "5 minutes"
    case fifteenMinutes = "15 minutes"
    case thirtyMinutes = "30 minutes"
    case oneHour = "1 hour"
    case twoHours = "2 hours"
    
    var id: String { rawValue }
    
    var timeInterval: TimeInterval {
        switch self {
        case .fiveMinutes: return 300
        case .fifteenMinutes: return 900
        case .thirtyMinutes: return 1800
        case .oneHour: return 3600
        case .twoHours: return 7200
        }
    }
}
