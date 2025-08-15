//
//  TravelLocationService.swift
//  TravelPlanner
//
//  Created by ali cihan on 29.07.2025.
//

import Foundation
import AppResources
import MockData


public protocol TravelLocationServiceProtocol {
    func fetchTravelLocations(prompt: String) async -> [TravelLocation]
    func fetchTravelLocations() -> [TravelLocation]
}

import Foundation

public final class TravelLocationService {
    private let geminiService: GeminiService
    
    public init(geminiService: GeminiService = .shared) {
        self.geminiService = geminiService
    }
    
    // MARK: - Async/Await
    
    public func fetchTravelLocations(prompt: String) async -> [TravelLocation] {
        do {
            let json = try await geminiService.generateContent(location: prompt)
            return try decodeLocations(from: json)
        } catch {
            print("Failed to fetch locations: \(error)")
            return []
        }
    }
    
    
    // MARK: - Completion-Based from Local JSON
    
    public func fetchLocalTravelLocations(prompt: String) -> [TravelLocation] {
        do {
//            guard let url = Bundle.main.url(forResource: "TravelLocations", withExtension: "json") else {
            guard let url = Bundle.mockData.url(forResource: "TravelLocations", withExtension: "json") else {
                throw NSError(domain: "Local JSON not found", code: 404)
            }
            let data = try Data(contentsOf: url)
            let locations = JSONParser.shared.parseLocations(from: data)
            return locations
            
        } catch {
            return []
        }
        
    }
    
    // MARK: - Private Helpers
    
    private func decodeLocations(from json: String) throws -> [TravelLocation] {
        let data = Data(json.utf8)
        return try JSONDecoder().decode([TravelLocation].self, from: data)
    }
}
