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
}

public final class CoreDataFolderRepository {
    private let coreDataManager: CoreDataManager
    
    public init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
}

extension CoreDataFolderRepository: FolderRepository {
    public func add(location: AppResources.TravelLocation, to folder: AppResources.Folder) {
        coreDataManager.addLocation(location, to: folder)
    }
    
    public func delete(folder: Folder) {
        coreDataManager.delete(folder: folder)
    }
    
    public func fetchFolders() -> [Folder] {
        let folders: [Folder] = coreDataManager.fetchFolders().compactMap {
            Folder(id: $0.id!.uuidString, name: $0.name!)
        }
        return folders
    }
    
    public func createFolder(name: String) {
        coreDataManager.createFolder(name: name)
    }
}
