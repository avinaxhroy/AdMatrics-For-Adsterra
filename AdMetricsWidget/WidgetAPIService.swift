//
//  WidgetAPIService.swift
//  AdMetricsWidget
//
//  Created on 04/10/2025.
//  Simplified API service for widget extension
//

import Foundation
import AdMetricsShared

/// Simplified API service for widget extension
/// Fetches data directly from Adsterra API for widget display
final class WidgetAPIService {
    private let baseURL = "https://api3.adsterratools.com/publisher"
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Public API
    
    /// Fetch widget data for display
    func fetchWidgetData(apiKey: String) async throws -> WidgetData {
        // Fetch last 7 days of stats
        async let statsTask = fetchStats(apiKey: apiKey, days: 7)
        async let placementsTask = fetchPlacements(apiKey: apiKey)
        
        let (statsData, placementsData) = try await (statsTask, placementsTask)
        
        return processWidgetData(stats: statsData, placements: placementsData)
    }
    
    // MARK: - Private Methods
    
    private func fetchStats(apiKey: String, days: Int = 7) async throws -> [StatsData] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        let calendar = Calendar(identifier: .gregorian)
        var gmtCalendar = calendar
        gmtCalendar.timeZone = TimeZone(identifier: "GMT")!
        
        let endDate = Date()
        guard let startDate = gmtCalendar.date(byAdding: .day, value: -days, to: endDate) else {
            throw WidgetAPIError.invalidURL
        }
        
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        
        print("📅 [Widget] Fetching stats: \(start) to \(end)")
        
        let endpoint = "\(baseURL)/stats.json?start_date=\(start)&finish_date=\(end)&group_by[]=date"
        let response: AdsterraStatsResponse = try await request(endpoint: endpoint, apiKey: apiKey)
        
        return response.items ?? []
    }
    
    private func fetchPlacements(apiKey: String) async throws -> [PlacementData] {
        let endpoint = "\(baseURL)/placements.json"
        let response: AdsterraPlacementsResponse = try await request(endpoint: endpoint, apiKey: apiKey)
        
        return response.items ?? []
    }
    
    private func request<T: Decodable>(endpoint: String, apiKey: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw WidgetAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("🌐 [Widget] API Request: \(endpoint)")
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            print("❌ [Widget] Network error: \(error.localizedDescription)")
            throw WidgetAPIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WidgetAPIError.unknown
        }
        
        print("📥 [Widget] Response status: \(httpResponse.statusCode)")
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401, 403:
            throw WidgetAPIError.unauthorized
        case 404, 405:
            throw WidgetAPIError.notFound
        case 429:
            throw WidgetAPIError.rateLimited
        case 500...599:
            throw WidgetAPIError.serverError
        default:
            throw WidgetAPIError.unknown
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ [Widget] Decoding error: \(error)")
            throw WidgetAPIError.decodingError(error)
        }
    }
    
    private func processWidgetData(stats: [StatsData], placements: [PlacementData]) -> WidgetData {
        let sortedStats = stats.sorted { ($0.date ?? "") < ($1.date ?? "") }
        
        // Build revenue by date dictionary for balance calculation
        let revByDate = revenueByDate(from: sortedStats)
        
        // Today's revenue
        let todayRevenue = sortedStats.last?.revenue ?? 0
        
        // Last 7 days for sparkline
        let last7DaysRevenue = sortedStats.suffix(7).map { $0.revenue }
        
        // Calculate 7-day total for balance (simplified - no payout tracking in widget)
        let sevenDayRevenue = last7DaysRevenue.reduce(0, +)
        
        // Try to load balance settings for accurate balance calculation
        let balance = calculateBalance(revenueByDate: revByDate, sevenDayRevenue: sevenDayRevenue)
        
        // Totals
        let totalImpressions = sortedStats.reduce(0) { $0 + $1.impression }
        let totalClicks = sortedStats.reduce(0) { $0 + $1.clicks }
        
        // Averages
        let avgCTR = totalImpressions > 0 ? (Double(totalClicks) / Double(totalImpressions)) * 100 : 0
        let avgCPM = sortedStats.isEmpty ? 0 : sortedStats.map { $0.cpm }.reduce(0, +) / Double(sortedStats.count)
        
        // Top placements
        let placementRevenue = Dictionary(grouping: stats) { $0.placement }
            .compactMapValues { data -> (Int, String, Double, Int)? in
                guard let placementId = data.first?.placement,
                      let placement = placements.first(where: { $0.id == placementId }) else {
                    return nil
                }
                let revenue = data.reduce(0) { $0 + $1.revenue }
                let impressions = data.reduce(0) { $0 + $1.impression }
                return (placementId, placement.title, revenue, impressions)
            }
            .values
            .sorted { $0.2 > $1.2 }
            .prefix(3)
            .map { TopPlacement(id: $0.0, name: $0.1, revenue: $0.2, impressions: $0.3) }
        
        print("💰 [Widget] Balance: $\(balance), Today: $\(todayRevenue)")
        
        return WidgetData(
            balance: balance,
            currency: "USD",
            todayRevenue: todayRevenue,
            impressions: totalImpressions,
            clicks: totalClicks,
            ctr: avgCTR,
            cpm: avgCPM,
            last7DaysRevenue: last7DaysRevenue,
            topPlacements: Array(placementRevenue),
            lastUpdated: Date()
        )
    }
    
    // MARK: - Balance Calculation with Settings Support
    
    private func calculateBalance(revenueByDate: [Date: Double], sevenDayRevenue: Double) -> Double {
        // Load balance settings from shared storage
        guard let settingsJSON = SharedFileStorage.shared.loadBalanceSettingsJSON(),
              let jsonData = settingsJSON.data(using: .utf8) else {
            print("💰 [Widget] No balance settings - using 7-day revenue: $\(sevenDayRevenue)")
            return sevenDayRevenue
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let settings = try decoder.decode(WidgetBalanceSettings.self, from: jsonData)
            
            // Calculate balance from last payout date onwards
            guard let lastPayoutDate = settings.lastPayoutDate else {
                print("💰 [Widget] No payout yet - Balance = 7-day Revenue: $\(sevenDayRevenue)")
                return sevenDayRevenue
            }
            
            let calendar = Calendar.current
            var balance: Double = 0
            
            for (date, revenue) in revenueByDate {
                let comparison = calendar.compare(date, to: lastPayoutDate, toGranularity: .day)
                if comparison == .orderedDescending || comparison == .orderedSame {
                    balance += revenue
                }
            }
            
            print("💰 [Widget] Balance Calculation:")
            print("   Last payout: \(lastPayoutDate)")
            print("   Revenue after payout: $\(balance)")
            
            return max(0, balance)
        } catch {
            print("⚠️ [Widget] Failed to decode balance settings: \(error)")
            return sevenDayRevenue
        }
    }
    
    private func revenueByDate(from stats: [StatsData]) -> [Date: Double] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        var result: [Date: Double] = [:]
        
        for stat in stats {
            guard let dateString = stat.date,
                  let date = dateFormatter.date(from: dateString) else {
                continue
            }
            result[date, default: 0] += stat.revenue
        }
        
        return result
    }
}

// MARK: - Simplified Balance Settings for Widget

struct WidgetBalanceSettings: Codable {
    let minimumPayoutAmount: Double
    let lastPayoutDate: Date?
    let lastPayoutAmount: Double?
    let initialBalance: Double
    let initialBalanceDate: Date
}

// MARK: - Widget-specific Errors

enum WidgetAPIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case unauthorized
    case notFound
    case rateLimited
    case serverError
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "API key invalid or expired"
        case .notFound:
            return "API endpoint not found"
        case .rateLimited:
            return "Rate limit exceeded"
        case .serverError:
            return "Server error"
        case .decodingError(let error):
            return "Data format error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error"
        }
    }
}

// MARK: - API Response Models (simplified for widget)

struct AdsterraStatsResponse: Codable {
    let items: [StatsData]?
}

struct StatsData: Codable {
    let date: String?
    let impression: Int
    let clicks: Int
    let ctr: Double
    let cpm: Double
    let revenue: Double
    let placement: Int?
}

struct AdsterraPlacementsResponse: Codable {
    let items: [PlacementData]?
}

struct PlacementData: Codable {
    let id: Int
    let title: String
}
