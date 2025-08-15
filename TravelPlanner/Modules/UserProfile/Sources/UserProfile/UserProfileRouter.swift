//
//  File.swift
//  UserProfile
//
//  Created by ali cihan on 12.08.2025.
//

import Foundation
import UIKit

@MainActor
public protocol UserProfileCoordinatorProtocol: AnyObject {
    func didRequestLogout()
    func showPlanner()
}

@MainActor
public protocol UserProfileRouterProtocol {
    func navigateToAuth()
    func navigateToSettings()
    func navigateToPlanner()
}


public class UserProfileRouter: UserProfileRouterProtocol {
    
    private weak var coordinator: UserProfileCoordinatorProtocol?
    
    @MainActor public static func assembleModule(coordinator: UserProfileCoordinatorProtocol?) -> UIViewController {
        let vc = UserProfileViewController()
        let interactor = UserProfileInteractor()
        let router = UserProfileRouter()
        let presenter = UserProfilePresenter(view: vc, interactor: interactor, router: router)
        
        vc.presenter = presenter
        interactor.output = presenter
        router.coordinator = coordinator
        return vc
    }
    
    public func navigateToAuth() {
        coordinator?.didRequestLogout()
    }
    
    public func navigateToSettings() {}
    
    public func navigateToPlanner() {
        coordinator?.showPlanner()
    }
}
