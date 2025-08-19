//
//  UserProfileRouter.swift
//  UserProfile
//
//  Created by ali cihan on 12.08.2025.
//

import Foundation
import UIKit

@MainActor
public protocol UserProfileRouterDelegate: AnyObject {
    func userProfileRouterDidRequestLogout()
    func userProfileRouterDidRequestSettings()
    func userProfileRouterDidRequestPlanner()
}

@MainActor
public protocol UserProfileRouterProtocol {
    func navigateToAuth()
    func navigateToSettings()
    func navigateToPlanner()
}

public class UserProfileRouter: UserProfileRouterProtocol {
    public weak var delegate: UserProfileRouterDelegate?
    
    public static func assembleModule() -> UIViewController {
        return assembleModule(delegate: nil)
    }
    
    public static func assembleModule(delegate: UserProfileRouterDelegate?) -> UIViewController {
        let vc = UserProfileViewController()
        let interactor = UserProfileInteractor()
        let router = UserProfileRouter()
        let presenter = UserProfilePresenter(view: vc, interactor: interactor, router: router)
        
        vc.presenter = presenter
        interactor.output = presenter
        router.delegate = delegate
        return vc
    }
    
    public func navigateToAuth() {
        delegate?.userProfileRouterDidRequestLogout()
    }
    
    public func navigateToSettings() {
        delegate?.userProfileRouterDidRequestSettings()
    }
    
    public func navigateToPlanner() {
        delegate?.userProfileRouterDidRequestPlanner()
    }
}
