//
//  File.swift
//  CoreDataManager
//
//  Created by ali cihan on 26.08.2025.
//

import Foundation
import AppResources

extension LocationEntity {
    func toDomain() -> TravelLocation {
        return TravelLocation(
            id: self.id,
            name: self.name ?? "unknown",
            description: self.locationDescription ?? "",
            latitude: self.latitude,
            longitude: self.longitude,
            symbol: self.symbol ?? "questionMark",
            type: self.type ?? "unknown"
        )
    }

    func update(from location: TravelLocation) {
        self.id = UUID(uuidString: location.id) ?? UUID()
        self.name = location.name
        self.locationDescription = location.description
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.symbol = location.symbol
        self.type = location.type
    }
}


extension FolderEntity {
    func toDomain() -> Folder {
        return Folder(id: self.id.uuidString, name: self.name!)
    }

    func update(from folder: Folder) {
        self.id = UUID(uuidString: folder.id) ?? UUID()
        self.name = folder.name
    }
}
