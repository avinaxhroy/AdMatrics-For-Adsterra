//
//  LargeWidgetView.swift
//  AdMetricsWidget
//

import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
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
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("BALANCE")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(.white.opacity(0.7))
                            .tracking(2.5)
                        
                        Text(data.formattedBalance)
                            .font(.system(size: min(geometry.size.width * 0.12, 52), weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.bottom, 10)
                    
                    let columns = geometry.size.width > 300 ? 3 : 2
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columns),
                        spacing: 12
                    ) {
                        compactStatCard(
                            icon: "dollarsign.circle.fill",
                            label: "TODAY",
                            value: "$\(String(format: "%.2f", data.todayRevenue))",
                            color: .green
                        )
                        
                        compactStatCard(
                            icon: "eye.fill",
                            label: "IMPRESSIONS",
                            value: formatCompact(Double(data.impressions)),
                            color: .cyan
                        )
                        
                        compactStatCard(
                            icon: "hand.tap.fill",
                            label: "CLICKS",
                            value: formatCompact(Double(data.clicks)),
                            color: .orange
                        )
                        
                        compactStatCard(
                            icon: "chart.line.uptrend.xyaxis",
                            label: "CTR",
                            value: String(format: "%.2f%%", data.ctr),
                            color: .purple
                        )
                        
                        compactStatCard(
                            icon: "chart.bar.fill",
                            label: "CPM",
                            value: "$\(String(format: "%.2f", data.cpm))",
                            color: .cyan
                        )
                        
                        if let weekTotal = data.last7DaysRevenue.reduce(0, +) as Double? {
                            compactStatCard(
                                icon: "calendar",
                                label: "7-DAY",
                                value: "$\(String(format: "%.2f", weekTotal))",
                                color: .indigo
                            )
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                        
                        Text("Updated \(data.lastUpdatedText)")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                }
                .padding(16)
            }
        }
    }
    
    private func compactStatCard(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.4), radius: 4)
            
            Text(value)
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Text(label)
                .font(.system(size: 7, weight: .bold))
                .foregroundStyle(.white.opacity(0.6))
                .tracking(1.2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
        )
    }
    
    private func formatCompact(_ value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "%.1fM", value / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "%.1fK", value / 1_000)
        } else {
            return String(format: "%.0f", value)
        }
    }
    
    private func errorView(error: Error) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.12, blue: 0.18).opacity(0.85),
                            Color(red: 0.10, green: 0.10, blue: 0.15).opacity(0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 14) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text("No Data Available")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Open AdMetrics app to fetch your latest stats")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
    
    private func placeholderView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.12, blue: 0.18).opacity(0.85),
                            Color(red: 0.10, green: 0.10, blue: 0.15).opacity(0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                Text("Loading...")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
        }
    }
}

#Preview(as: .systemLarge) {
    LargeAdMetricsWidget()
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
            topPlacements: [
                TopPlacement(id: 1, name: "Homepage Banner", revenue: 25.30, impressions: 45000),
                TopPlacement(id: 2, name: "Sidebar Ad", revenue: 15.20, impressions: 32000),
                TopPlacement(id: 3, name: "Footer Link", revenue: 5.17, impressions: 18000)
            ],
            lastUpdated: Date()
        ),
        error: nil
    )
}
