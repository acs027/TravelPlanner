//
//  File.swift
//  Folder
//
//  Created by ali cihan on 29.08.2025.
//

import Foundation
import AppResources
import UIKit

@MainActor
protocol FolderDetailRouterProtocol: AnyObject {
    func presentLocationDetail(from view: FolderDetailViewProtocol, location: TravelLocation)
}

@MainActor
public final class FolderDetailRouter {
    weak var viewController: UIViewController?
    
       public static func build(with folder: Folder) -> UIViewController {
            let view = FolderDetailViewController()
            let presenter = FolderDetailPresenter(folder: folder)
            let interactor = FolderDetailInteractor()
            let router = FolderDetailRouter()

            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            router.viewController = view

            view.title = folder.name
            return view
        }
}

extension FolderDetailRouter: FolderDetailRouterProtocol {
    func presentLocationDetail(from view: FolderDetailViewProtocol, location: AppResources.TravelLocation) {
        let alert = UIAlertController(title: location.name, message: location.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        if let vc = view as? UIViewController {
            vc.present(alert, animated: true)
           }
    }
}
