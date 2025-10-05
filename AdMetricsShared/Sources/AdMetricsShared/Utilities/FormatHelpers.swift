//
//  FormatHelpers.swift
//  AdMetrics
//
//  Created on 03/10/2025.
//

import Foundation

public struct FormatHelpers {
    public static func formatCurrency(_ value: Double, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(currency) \(value)"
    }
    
    // Overload for default USD currency
    public static func formatCurrency(_ value: Double) -> String {
        formatCurrency(value, currency: "USD")
    }
    
    public static func formatCompactNumber(_ value: Int) -> String {
        let thousand = 1_000
        let million = 1_000_000
        
        if value >= million {
            return String(format: "%.1fM", Double(value) / Double(million))
        } else if value >= thousand {
            return String(format: "%.1fK", Double(value) / Double(thousand))
        } else {
            return "\(value)"
        }
    }
    
    public static func formatPercentage(_ value: Double) -> String {
        String(format: "%.2f%%", value)
    }
    
    public static func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
    
    public static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    public static func daysUntil(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: date)
        
        if let days = components.day {
            if days < 0 {
                return "Overdue by \(abs(days)) day\(abs(days) == 1 ? "" : "s")"
            } else if days == 0 {
                return "Due today"
            } else if days == 1 {
                return "Due tomorrow"
            } else {
                return "Due in \(days) days"
            }
        }
        
        return ""
    }
}

