//
//  PlannerRouter.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import UIKit

@MainActor
public protocol PlannerCoordinatorProtocol: AnyObject {
    func didRequestLogout()
    func showSettings()
    func showUserProfile()
}

@MainActor
public protocol PlannerRouterProtocol {
    func navigateToAuth()
    func navigateToSettings()
    func navigateToUserProfile()
}

@MainActor
public class PlannerRouter: PlannerRouterProtocol {
    private weak var coordinator: PlannerCoordinatorProtocol?
    
    public static func assembleModule() -> UIViewController {
        return assembleModule(coordinator: nil)
    }
    
    public static func assembleModule(coordinator: PlannerCoordinatorProtocol?) -> UIViewController {
        let vc = PlannerViewController()
        let interactor = PlannerInteractor()
        let router = PlannerRouter()
        let presenter = PlannerPresenter(view: vc, interactor: interactor, router: router)
        
        vc.presenter = presenter
        interactor.output = presenter
        router.coordinator = coordinator
        return vc
    }
    
    public func navigateToAuth() {
        coordinator?.didRequestLogout()
    }
    
    public func navigateToSettings() {
        coordinator?.showSettings()
    }
    
    public func navigateToUserProfile() {
        coordinator?.showUserProfile()
    }
}
