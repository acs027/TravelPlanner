//
//  PlannerRouter.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import UIKit
import AppResources
import Folder

@MainActor
public protocol PlannerRouterDelegate: AnyObject {
}

@MainActor
protocol PlannerRouterProtocol {
    func presentFolders(view: PlannerViewProtocol, location: TravelLocation)
    func presentLocationDetail(from view: PlannerViewProtocol, location: TravelLocation, delegate: LocationDetailViewDelegate?)
    func presentError(view: PlannerViewProtocol, title: String, message: String)
}

@MainActor
public class PlannerRouter {
    public weak var delegate: PlannerRouterDelegate?
    
    public static func assembleModule() -> UIViewController {
        return assembleModule(delegate: nil)
    }
    
    public static func assembleModule(delegate: PlannerRouterDelegate?) -> UIViewController {
        let vc = PlannerViewController()
        let interactor = PlannerInteractor()
        let router = PlannerRouter()
        let presenter = PlannerPresenter(view: vc, interactor: interactor, router: router)
        
        vc.presenter = presenter
        interactor.output = presenter
        router.delegate = delegate
        return vc
    }
}

extension PlannerRouter: PlannerRouterProtocol {
    func presentFolders(view: PlannerViewProtocol, location: AppResources.TravelLocation) {
        let foldersVC = FoldersRouter.assembleModule(location: location)
        if let vc = view as? UIViewController {
            if vc.presentedViewController != nil {
                vc.dismiss(animated: true)
            }
               vc.present(foldersVC, animated: true)
           }
    }

    func presentLocationDetail(from view: any PlannerViewProtocol, location: AppResources.TravelLocation, delegate: LocationDetailViewDelegate?) {
        let detailVC = LocationDetailViewController(location: location)
        detailVC.delegate = delegate
        if let vc = view as? UIViewController {
            vc.present(detailVC, animated: true)
        }
    }
    
    func presentError(view: PlannerViewProtocol, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        if let vc = view as? UIViewController {
            vc.present(alert, animated: true)
           }
    }
}

