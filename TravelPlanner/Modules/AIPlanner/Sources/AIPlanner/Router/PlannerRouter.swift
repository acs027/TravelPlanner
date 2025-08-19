//
//  PlannerRouter.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import UIKit

@MainActor
public protocol PlannerRouterDelegate: AnyObject {
    func plannerRouterDidRequestLogout()
    func plannerRouterDidRequestSettings()
    func plannerRouterDidRequestUserProfile()
}

@MainActor
public protocol PlannerRouterProtocol {
    func navigateToAuth()
    func navigateToSettings()
    func navigateToUserProfile()
}

public class PlannerRouter: PlannerRouterProtocol {
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
    
    public func navigateToAuth() {
        delegate?.plannerRouterDidRequestLogout()
    }
    
    public func navigateToSettings() {
        delegate?.plannerRouterDidRequestSettings()
    }
    
    public func navigateToUserProfile() {
        delegate?.plannerRouterDidRequestUserProfile()
    }
}

