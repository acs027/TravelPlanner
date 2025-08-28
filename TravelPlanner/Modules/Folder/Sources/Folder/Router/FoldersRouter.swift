//
//  File.swift
//  AIPlanner
//
//  Created by ali cihan on 27.08.2025.
//

import Foundation
import AppResources
import UIKit

@MainActor
protocol FoldersRouterProtocol {
    func presentDeleteConfirmation(view: FoldersViewProtocol, for folder: Folder, completion: @escaping (Bool) -> Void)
    func presentCreateFolderAlert(view: FoldersViewProtocol, completion: @escaping (String) -> Void)
    func dismissFolders(view: FoldersViewProtocol)
}

@MainActor
public final class FoldersRouter {
    public static func assembleModule(
           location: TravelLocation,
       ) -> UIViewController {
           let vc = FoldersViewController()
           let interactor = FoldersInteractor()
           let router = FoldersRouter()
           let presenter = FoldersPresenter(
               view: vc,
               interactor: interactor,
               router: router,
               location: location,
           )
           
           vc.presenter = presenter
           interactor.output = presenter
           return vc
       }
}

extension FoldersRouter: FoldersRouterProtocol {
    func presentDeleteConfirmation(view: FoldersViewProtocol, for folder: Folder, completion: @escaping (Bool) -> Void) {
            let alert = UIAlertController(
                title: "Delete Folder",
                message: "Are you sure you want to delete '\(folder.name)'?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion(false) })
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in completion(true) })
        if let vc = view as? UIViewController {
            vc.present(alert, animated: true)
           }
        }
    
    func presentCreateFolderAlert(view: FoldersViewProtocol, completion: @escaping (String) -> Void) {
         let alert = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
         alert.addTextField { $0.placeholder = "Folder name" }
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
         alert.addAction(UIAlertAction(title: "Create", style: .default) { _ in
             if let name = alert.textFields?.first?.text, !name.isEmpty {
                 completion(name)
             }
         })
        if let vc = view as? UIViewController {
            vc.present(alert, animated: true)
           }
     }
    
    func dismissFolders(view: FoldersViewProtocol) {
        if let vc = view as? UIViewController {
            vc.dismiss(animated: true)
           }
       }
}
