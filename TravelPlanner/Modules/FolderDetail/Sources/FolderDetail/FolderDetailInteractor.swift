//
//  File.swift
//  Folder
//
//  Created by ali cihan on 29.08.2025.
//

import Foundation
import AppResources
import CoreDataManager

@MainActor
protocol FolderDetailInteractorProtocol: AnyObject {
    func fetchItems(for folder: Folder) -> [TravelLocation]
    func delete(_ item: TravelLocation)
}

protocol FolderDetailInteractorOutputProtocol: AnyObject {
    
}

@MainActor
final class FolderDetailInteractor {
    weak var output: FolderDetailInteractorOutputProtocol?
    private let folderRepository =  CoreDataFolderRepository(coreDataManager: CoreDataManager.shared)
}

extension FolderDetailInteractor: FolderDetailInteractorProtocol {
    func delete(_ item: AppResources.TravelLocation) {
        folderRepository.deleteLocation(location: item)
    }
    
    func fetchItems(for folder: Folder) -> [TravelLocation] {
        folderRepository.fetchLocations(in: folder)
    }
}
