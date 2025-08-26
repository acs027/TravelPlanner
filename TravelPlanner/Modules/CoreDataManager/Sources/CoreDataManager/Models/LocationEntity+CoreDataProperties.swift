//
//  LocationEntity+CoreDataProperties.swift
//  TravelPlanner
//
//  Created by ali cihan on 26.08.2025.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var locationDescription: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var symbol: String?
    @NSManaged public var type: String?
    @NSManaged public var folder: FolderEntity?

}

extension LocationEntity : Identifiable {

}
