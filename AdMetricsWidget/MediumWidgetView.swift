//
//  MediumWidgetView.swift
//  AdMetricsWidget
//
//  Created on 03/10/2025.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        ZStack {
            if let data = entry.data {
                contentView(data: data)
            } else if let error = entry.error {
                errorView(error: error)
            } else {
                placeholderView()
            }
        }
        .widgetURL(URL(string: "admetrics://open"))
    }
    
        @ViewBuilder
    private func contentView(data: WidgetData) -> some View {
        HStack(spacing: 18) {
                // Left: Balance Section - Premium Design
                VStack(alignment: .leading, spacing: 14) {
                    // Elegant Header
                    HStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("AdMetrics")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        if data.isStale {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 7, height: 7)
                                .shadow(color: .orange.opacity(0.5), radius: 3)
                        }
                    }
                    
                    Spacer()
                    
                    // Balance with Shadow
                    VStack(alignment: .leading, spacing: 10) {
                        Text("BALANCE")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .tracking(2.5)
                        
                        Text(data.formattedBalance)
                            .font(.system(size: 46, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        // Beautiful Sparkline
                        if !data.last7DaysRevenue.isEmpty {
                            SparklineView(data: data.last7DaysRevenue)
                                .stroke(Color.white.opacity(0.8), lineWidth: 2.5)
                                .frame(height: 28)
                                .overlay(
                                    SparklineView(data: data.last7DaysRevenue)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.25), Color.clear],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                )
                                .shadow(color: .white.opacity(0.2), radius: 4)
                        }
                    }
                    
                    // Today's revenue
                    HStack(spacing: 8) {
                        Circle()
                            .fill(data.todayRevenue > 0 ? Color.green : Color.gray.opacity(0.5))
                            .frame(width: 6, height: 6)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TODAY")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .tracking(1)
                            
                            Text(data.formattedTodayRevenue)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(18)
                
                // Right: Stats Grid
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        miniStatCard(
                            icon: "eye.fill",
                            label: "VIEWS",
                            value: formatCompact(data.impressions),
                            color: Color.purple
                        )
                        
                        miniStatCard(
                            icon: "hand.tap.fill",
                            label: "CLICKS",
                            value: data.formattedClicks,
                            color: Color.orange
                        )
                    }
                    
                    HStack(spacing: 12) {
                        miniStatCard(
                            icon: "percent",
                            label: "CTR",
                            value: data.formattedCTR,
                            color: Color.cyan
                        )
                        
                        miniStatCard(
                            icon: "dollarsign.circle.fill",
                            label: "CPM",
                            value: data.formattedCPM,
                            color: Color.green
                        )
                    }
                }
                .padding(.trailing, 20)
                .padding(.vertical, 20)
            }
    }
    
    private func miniStatCard(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.3), radius: 4)
            
            Text(value)
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            
            Text(label)
                .font(.system(size: 7, weight: .bold))
                .foregroundStyle(.white.opacity(0.6))
                .tracking(1.2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    // Helper to format large numbers compactly
    
    // Helper to format large numbers compactly
    private func formatCompact(_ number: Int) -> String {
        let thousand = 1000
        let million = 1000000
        
        if number >= million {
            return String(format: "%.1fM", Double(number) / Double(million))
        } else if number >= thousand {
            return String(format: "%.1fK", Double(number) / Double(thousand))
        } else {
            return "\(number)"
        }
    }
    
    private func errorView(error: Error) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.9, green: 0.3, blue: 0.3),
                    Color(red: 0.85, green: 0.25, blue: 0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 14) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.primary)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Text("No Data Available")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Open AdMetrics app to fetch your latest stats")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
    
    private func placeholderView() -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.5, blue: 0.95).opacity(0.3),
                    Color(red: 0.25, green: 0.65, blue: 1.0).opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 12) {
                Image(systemName: "chart.line.uptrend.xyaxis.circle")
                    .font(.system(size: 40))
                    .foregroundColor(.secondary.opacity(0.6))
                
                Text("AdMetrics")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                
                Text("Loading your statistics...")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary.opacity(0.8))
            }
        }
    }
}

// MARK: - Mini Sparkline
struct MiniSparkline: View {
    let data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let range = maxValue - minValue
            let width = geometry.size.width
            let height = geometry.size.height
            
            Path { path in
                guard !data.isEmpty else { return }
                
                let stepX = width / CGFloat(data.count - 1)
                
                for (index, value) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let normalizedValue = range > 0 ? (value - minValue) / range : 0.5
                    let y = height - (CGFloat(normalizedValue) * height)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 1.5)
        }
    }
}

// Modern Sparkline View
struct SparklineView: Shape {
    let data: [Double]
    
    func path(in rect: CGRect) -> Path {
        guard data.count > 1 else {
            return Path()
        }
        
        let maxValue = data.max() ?? 1
        let minValue = data.min() ?? 0
        let range = maxValue - minValue
        
        var path = Path()
        let stepX = rect.width / CGFloat(data.count - 1)
        
        for (index, value) in data.enumerated() {
            let x = CGFloat(index) * stepX
            let normalizedValue = range > 0 ? (value - minValue) / range : 0.5
            let y = rect.height - (CGFloat(normalizedValue) * rect.height)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

#Preview(as: .systemMedium) {
    MediumAdMetricsWidget()
} timeline: {
    WidgetEntry(
        date: Date(),
        data: WidgetData(
            balance: 1234.56,
            currency: "USD",
            todayRevenue: 45.67,
            impressions: 125000,
            clicks: 850,
            ctr: 0.68,
            cpm: 2.45,
            last7DaysRevenue: [30.0, 35.0, 28.0, 42.0, 38.0, 45.0, 45.67],
            topPlacements: [],
            lastUpdated: Date()
        ),
        error: nil
    )
}

