//
//  File.swift
//  AIPlanner
//
//  Created by ali cihan on 27.08.2025.
//

import Foundation
import AppResources

@MainActor
protocol FoldersPresenterProtocol {
    func didRequestCreateFolder(name: String)
    func didRequestAdd(location: TravelLocation, to folder: Folder)
    func didRequestDelete(folder: Folder)
    func didRequestFetchFolders()
}

final class FoldersPresenter {
    weak var view: FoldersViewProtocol?
    var interactor: FoldersInteractorProtocol
    var router: FoldersRouterProtocol
    var location: TravelLocation?
    
    init(view: FoldersViewProtocol? = nil, interactor: FoldersInteractorProtocol, router: FoldersRouterProtocol, location: TravelLocation) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.location = location
    }
}

extension FoldersPresenter: FoldersPresenterProtocol {
    func didRequestFetchFolders() {
        interactor.fetchFolders()
    }
    
    func didRequestCreateFolder(name: String) {
        interactor.createFolder(name: name)
    }
    
    func didRequestAdd(location: AppResources.TravelLocation, to folder: AppResources.Folder) {
        interactor.add(location: location, to: folder)
    }
    
    func didRequestDelete(folder: AppResources.Folder) {
        interactor.delete(folder: folder)
    }
}

extension FoldersPresenter: FoldersInteractorOutputProtocol {
    func update(folders: [AppResources.Folder]) {
        view?.update(folders: folders)
    }
}
