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
    public let type: String
    
    public init(name: String, description: String, latitude: Double, longitude: Double, symbol: String, type: String) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.symbol = symbol
        self.type = type
    }
    
    public init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.id = UUID().uuidString
         self.name = try container.decode(String.self, forKey: .name)
         self.description = try container.decode(String.self, forKey: .description)
         self.latitude = try container.decode(Double.self, forKey: .latitude)
         self.longitude = try container.decode(Double.self, forKey: .longitude)
         self.type = try container.decode(String.self, forKey: .type)
         self.symbol = try container.decode(String.self, forKey: .symbol)
     }
}



