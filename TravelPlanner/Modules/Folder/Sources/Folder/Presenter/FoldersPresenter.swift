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
    func didRequestCreateFolder()
    func didRequestAdd(to folder: Folder)
    func didRequestDelete(at index: Int)
    func didRequestFetchFolders()
    var foldersCount: Int { get }
    func folder(at index: Int) -> Folder
    func didRequestDismiss()
}

final class FoldersPresenter {
    weak var view: FoldersViewProtocol?
    var interactor: FoldersInteractorProtocol
    var router: FoldersRouterProtocol
    var location: TravelLocation?
    var folders: [Folder] = []
    
    init(view: FoldersViewProtocol? = nil, interactor: FoldersInteractorProtocol, router: FoldersRouterProtocol, location: TravelLocation) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.location = location
    }
}

extension FoldersPresenter: FoldersPresenterProtocol {
    func didRequestDismiss() {
        guard let view = view else { return }
        router.dismissFolders(view: view)
    }
    
    func folder(at index: Int) -> Folder {
        folders[index]
    }
    
    var foldersCount: Int { folders.count }
    
    func didRequestFetchFolders() {
        interactor.fetchFolders()
    }
    
    func didRequestCreateFolder() {
        guard let view = view else { return }
        router.presentCreateFolderAlert(view: view) { [weak self] folderName in
                  guard let self = self else { return }
                  self.interactor.createFolder(name: folderName)
              }
    }
    
    func didRequestAdd(to folder: AppResources.Folder) {
        guard let location = location else { return }
        interactor.add(location: location, to: folder)
    }
    
    func didRequestDelete(at index: Int) {
        guard let view = view else { return }
        let folder = folders.remove(at: index)
        router.presentDeleteConfirmation(view: view, for: folder) { [weak self] confirmed in
            guard let self = self, confirmed else { return }
            self.interactor.delete(folder: folder)
        }
    }
}

extension FoldersPresenter: FoldersInteractorOutputProtocol {
    func update(folders: [AppResources.Folder]) {
        self.folders = folders
        view?.update()
    }
}
