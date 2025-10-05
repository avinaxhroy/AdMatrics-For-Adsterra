//
//  WidgetData.swift
//  Shared
//
//  Created on 03/10/2025.
//

import Foundation

public struct WidgetData: Codable, Equatable {
    public let balance: Double
    public let currency: String
    public let todayRevenue: Double
    public let impressions: Int
    public let clicks: Int
    public let ctr: Double
    public let cpm: Double
    public let last7DaysRevenue: [Double]
    public let topPlacements: [TopPlacement]
    public let lastUpdated: Date
    
    public var formattedBalance: String {
        FormatHelpers.formatCurrency(balance, currency: currency)
    }
    
    public var formattedTodayRevenue: String {
        FormatHelpers.formatCurrency(todayRevenue, currency: currency)
    }
    
    public var formattedImpressions: String {
        FormatHelpers.formatCompactNumber(impressions)
    }
    
    public var formattedClicks: String {
        FormatHelpers.formatCompactNumber(clicks)
    }
    
    public var formattedCTR: String {
        FormatHelpers.formatPercentage(ctr)
    }
    
    public var formattedCPM: String {
        FormatHelpers.formatCurrency(cpm, currency: currency)
    }
    
    public var isStale: Bool {
        Date().timeIntervalSince(lastUpdated) > 1800 // 30 minutes
    }
    
    public var timeAgo: String {
        FormatHelpers.timeAgo(from: lastUpdated)
    }
    
    public var lastUpdatedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastUpdated, relativeTo: Date())
    }
    
    public init(balance: Double, currency: String, todayRevenue: Double, impressions: Int, clicks: Int, ctr: Double, cpm: Double, last7DaysRevenue: [Double], topPlacements: [TopPlacement], lastUpdated: Date) {
        self.balance = balance
        self.currency = currency
        self.todayRevenue = todayRevenue
        self.impressions = impressions
        self.clicks = clicks
        self.ctr = ctr
        self.cpm = cpm
        self.last7DaysRevenue = last7DaysRevenue
        self.topPlacements = topPlacements
        self.lastUpdated = lastUpdated
    }
}

public struct TopPlacement: Codable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let revenue: Double
    public let impressions: Int
    
    public func formattedRevenue(currency: String) -> String {
        FormatHelpers.formatCurrency(revenue, currency: currency)
    }
    
    public var formattedImpressions: String {
        FormatHelpers.formatCompactNumber(impressions)
    }
    
    public init(id: Int, name: String, revenue: Double, impressions: Int) {
        self.id = id
        self.name = name
        self.revenue = revenue
        self.impressions = impressions
    }
}

public enum RefreshInterval: String, CaseIterable, Identifiable {
    case fiveMinutes = "5 minutes"
    case fifteenMinutes = "15 minutes"
    case thirtyMinutes = "30 minutes"
    case oneHour = "1 hour"
    case twoHours = "2 hours"
    
    public var id: String { rawValue }
    
    public var timeInterval: TimeInterval {
        switch self {
        case .fiveMinutes: return 300
        case .fifteenMinutes: return 900
        case .thirtyMinutes: return 1800
        case .oneHour: return 3600
        case .twoHours: return 7200
        }
    }
}
