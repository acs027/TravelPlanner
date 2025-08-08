//
//  TravelLocation.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation

// Models/TravelLocation.swift
public struct TravelLocation: Codable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let latitude: Double
    public let longitude: Double
    public let symbol: String
    
    public init(id: String, name: String, description: String, latitude: Double, longitude: Double, symbol: String) {
        self.id = id
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.symbol = symbol
    }
}
