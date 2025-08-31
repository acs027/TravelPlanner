//
//  File.swift
//  Folder
//
//  Created by ali cihan on 29.08.2025.
//

import Foundation
import AppResources

@MainActor
protocol FolderDetailPresenterProtocol: AnyObject {
    var itemsCount: Int { get }
    func item(at index: Int) -> TravelLocation
    func viewDidLoad()
    func didRequestDeleteItem(at index: Int)
    func didRequestLocationDetail(at index: Int)
}

final class FolderDetailPresenter: FolderDetailPresenterProtocol {
    weak var view: FolderDetailViewProtocol?
    var interactor: FolderDetailInteractorProtocol!
    var router: FolderDetailRouterProtocol!

    private var items: [TravelLocation] = []
    private let folder: Folder

    init(folder: Folder) {
        self.folder = folder
    }

    var itemsCount: Int { items.count }

    func item(at index: Int) -> TravelLocation {
        items[index]
    }

    func viewDidLoad() {
        items = interactor.fetchItems(for: folder)
        view?.showItems()
    }
    
    func didRequestDeleteItem(at index: Int) {
        let location = item(at: index)
        interactor.delete(location)
        items.remove(at: index)
        view?.showItems()
    }
    
    func didRequestLocationDetail(at index: Int) {
        guard let view = view else { return }
        let location = item(at: index)
        router.presentLocationDetail(from: view, location: location)
    }
}

