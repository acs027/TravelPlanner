//
//  File.swift
//  AIPlanner
//
//  Created by ali cihan on 27.08.2025.
//

import Foundation
import AppResources
import CoreDataManager

@MainActor
protocol FoldersInteractorProtocol {
    func createFolder(name: String)
    func add(location: TravelLocation, to folder: Folder)
    func delete(folder: Folder)
    func fetchFolders()
}

@MainActor
protocol FoldersInteractorOutputProtocol: AnyObject {
    func update(folders: [Folder])
}

@MainActor
final class FoldersInteractor {
    weak var output: FoldersInteractorOutputProtocol?
    private let folderRepository = CoreDataFolderRepository(coreDataManager: CoreDataManager.shared)
}

extension FoldersInteractor: FoldersInteractorProtocol {
    func add(location: TravelLocation, to folder: Folder) {
        folderRepository.add(location: location, to: folder)
        fetchFolders()
    }
    
    func delete(folder: Folder) {
        folderRepository.delete(folder: folder)
        fetchFolders()
    }
    
    func fetchFolders() {
        let folders = folderRepository.fetchFolders()
        output?.update(folders: folders)
    }
    
    
    func createFolder(name: String) {
        folderRepository.createFolder(name: name)
        fetchFolders()
    }
    
}


