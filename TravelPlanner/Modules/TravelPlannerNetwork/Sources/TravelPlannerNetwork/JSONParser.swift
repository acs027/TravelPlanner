//
//  JSONParser.swift
//  TravelPlanner
//
//  Created by ali cihan on 29.07.2025.
//

import Foundation
import AppResources

/// Service for parsing JSON data into TravelLocation objects
final class JSONParser: @unchecked Sendable {
    
    // MARK: - Singleton
    
    static let shared = JSONParser()
    
    // MARK: - Error Types
    
    enum JSONParserError: LocalizedError {
        case invalidData
        case decodingFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Invalid JSON data"
            case .decodingFailed(let error):
                return "Failed to decode JSON: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Parses JSON string into an array of TravelLocation objects
    /// - Parameter jsonString: JSON string to parse
    /// - Returns: Array of TravelLocation objects, empty array if parsing fails
    func parseLocations(from jsonString: String) -> [TravelLocation] {
        do {
            let parseLocations = try parseLocationsThrowing(from: jsonString)
            return parseLocations
        } catch {
            print("⚠️ JSON parsing error: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Parses JSON string into an array of TravelLocation objects with error throwing
    /// - Parameter jsonString: JSON string to parse
    /// - Returns: Array of TravelLocation objects
    /// - Throws: JSONParserError if parsing fails
    func parseLocationsThrowing(from jsonString: String) throws -> [TravelLocation] {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw JSONParserError.invalidData
        }
        
        do {
            let decoder = JSONDecoder()
            let parseLocations = try decoder.decode([TravelLocation].self, from: jsonData)
            return parseLocations
        } catch {
            throw JSONParserError.decodingFailed(error)
        }
    }
    
    /// Parses JSON data into an array of TravelLocation objects
    /// - Parameter data: JSON data to parse
    /// - Returns: Array of TravelLocation objects, empty array if parsing fails
    func parseLocations(from data: Data) -> [TravelLocation] {
        do {
            let decoder = JSONDecoder()
            let parseLocations = try decoder.decode([TravelLocation].self, from: data)
            return parseLocations
        } catch {
            print("⚠️ JSON parsing error: \(error.localizedDescription)")
            return []
        }
    }
}
