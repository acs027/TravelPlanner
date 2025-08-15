//
//  AuthCoordinator.swift
//  TravelPlanner
//

import UIKit
import TravelPlannerAuth

@MainActor
public protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator)
    func authCoordinatorDidCancel(_ coordinator: AuthCoordinator)
}

@MainActor
public class AuthCoordinator: BaseCoordinator, AuthCoordinatorProtocol {
    public var childCoordinators: [BaseCoordinator] = []
    public var navigationController: UINavigationController
    weak var delegate: AuthCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let authViewController = AuthRouter.createModule(coordinator: self)
        navigationController.setViewControllers([authViewController], animated: true)
    }
    
    public func didAuthenticate() {
        delegate?.authCoordinatorDidAuthenticate(self)
    }
    
    public func didCancel() {
        delegate?.authCoordinatorDidCancel(self)
    }
}
