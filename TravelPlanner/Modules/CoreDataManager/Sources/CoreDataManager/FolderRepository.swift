//
//  FolderRepository.swift
//  TravelPlanner
//
//  Created by ali cihan on 27.08.2025.
//

import Foundation
import AppResources

@MainActor
protocol FolderRepository {
    func add(location: TravelLocation, to folder: Folder)
    func delete(folder: Folder)
    func fetchFolders() -> [Folder]
    func createFolder(name: String)
    func deleteLocation(location: TravelLocation)
    func fetchLocations(in folder: Folder) -> [TravelLocation]
}

public final class CoreDataFolderRepository {
    private let coreDataManager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
}

extension CoreDataFolderRepository: FolderRepository {
    public func add(location: AppResources.TravelLocation, to folder: AppResources.Folder) {
        guard let folderEntity = coreDataManager.fetchSpecificFolder(id: folder.id) else { return }
        let locationEntity = LocationEntity(context: coreDataManager.context)
        locationEntity.update(from: location)
        locationEntity.folder = folderEntity
        coreDataManager.addLocation(locationEntity, to: folderEntity)
    }
    
    public func delete(folder: Folder) {
        guard let folderEntity = coreDataManager.fetchSpecificFolder(id: folder.id) else { return }
        coreDataManager.delete(folder: folderEntity)
    }
    
    public func fetchFolders() -> [Folder] {
        let folders: [Folder] = coreDataManager.fetchFolders().compactMap {
            Folder(id: $0.id.uuidString, name: $0.name!)
        }
        return folders
    }
    
    public func deleteLocation(location: TravelLocation) {
        guard let locationEntity = coreDataManager.fetchLocation(by: location.id) else { return }
        coreDataManager.deleteLocation(location: locationEntity)
    }
    
    public func createFolder(name: String) {
        coreDataManager.createFolder(name: name)
    }
    
    public func fetchLocations(in folder: Folder) -> [TravelLocation] {
        guard let folderEntity = coreDataManager.fetchSpecificFolder(id: folder.id) else { return [] }
        let locations = coreDataManager.fetchLocations(in: folderEntity).compactMap {
            $0.toDomain()
        }
        return locations
    }
}
