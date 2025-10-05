//
//  SmallWidgetView.swift
//  AdMetricsWidget
//
//  Created on 03/10/2025.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: WidgetEntry
    @Environment(\.widgetFamily) var family
    
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
        VStack(spacing: 0) {
                // Elegant header with icon
                HStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("AdMetrics")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    if data.isStale {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
                
                Spacer()
                
                // Main Balance - Premium Look
                VStack(spacing: 12) {
                    Text("BALANCE")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .tracking(2.5)
                    
                    Text(data.formattedBalance)
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    // Today indicator with glow effect
                    HStack(spacing: 7) {
                        Circle()
                            .fill(data.todayRevenue > 0 ? Color.green : Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                            .shadow(color: data.todayRevenue > 0 ? .green.opacity(0.6) : .clear, radius: 4)
                        
                        Text(data.formattedTodayRevenue)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("today")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                
                Spacer()
                
                // Beautiful footer stats with glass card effect
                HStack(spacing: 0) {
                    VStack(spacing: 5) {
                        Text(formatCompact(data.impressions))
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                        Text("IMPRESSIONS")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundStyle(.white.opacity(0.6))
                            .tracking(1)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1, height: 32)
                    
                    VStack(spacing: 5) {
                        Text(data.formattedCPM)
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                        Text("CPM")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundStyle(.white.opacity(0.6))
                            .tracking(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
            }
    }
    
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
            
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("No Data")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Open app")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
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
            
            VStack(spacing: 10) {
                Image(systemName: "chart.xyaxis.line")
                    .font(.system(size: 28))
                    .foregroundColor(.secondary.opacity(0.6))
                
                Text("AdMetrics")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("$--")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Loading...")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

#Preview(as: .systemSmall) {
    SmallAdMetricsWidget()
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
