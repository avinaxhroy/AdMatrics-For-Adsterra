//
//  CacheService.swift
//  Shared
//
//  Created on 03/10/2025.
//

import Foundation

/// Service for caching data for widget consumption
/// Works with FREE Apple Developer accounts (no App Groups required)
final class CacheService {
    static let shared = CacheService()
    
    private let sharedData = SharedDataManager.shared
    
    private init() {}
    
    // MARK: - Widget Data Caching
    
    /// Save widget data
    func saveWidgetData(_ data: WidgetData) throws {
        sharedData.saveWidgetData(data)
        sharedData.saveLastUpdateTime(Date())
    }
    
    /// Load widget data
    func loadWidgetData() throws -> WidgetData {
        guard let data = sharedData.loadWidgetData() else {
            throw CacheError.noDataFound
        }
        return data
    }
    
    /// Get last fetch date
    func getLastFetchDate() -> Date? {
        return sharedData.loadLastUpdateTime()
    }
    
    /// Check if cached data exists
    func hasCachedData() -> Bool {
        return sharedData.loadWidgetData() != nil
    }
    
    /// Clear all cached data
    func clearCache() {
        sharedData.clearCache()
    }
    
    /// Check if cache is stale (older than specified interval)
    func isCacheStale(maxAge: TimeInterval = 1800) -> Bool {
        guard let lastFetch = getLastFetchDate() else { return true }
        return Date().timeIntervalSince(lastFetch) > maxAge
    }
    
    // MARK: - Error Handling
    
    enum CacheError: LocalizedError {
        case noDataFound
        case encodingFailed
        case decodingFailed
        
        var errorDescription: String? {
            switch self {
            case .noDataFound:
                return "No cached data available"
            case .encodingFailed:
                return "Failed to encode data"
            case .decodingFailed:
                return "Failed to decode cached data"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .noDataFound:
                return "Open the main app to fetch fresh data."
            default:
                return "Try clearing the cache and fetching new data."
            }
        }
    }
}
