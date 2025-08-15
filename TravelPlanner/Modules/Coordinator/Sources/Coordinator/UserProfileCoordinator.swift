//
//  File.swift
//  Coordinator
//
//  Created by ali cihan on 13.08.2025.
//


import UIKit
import UserProfile

@MainActor
public protocol UserProfileCoordinatorDelegate: AnyObject {
    func userProfileCoordinatorDidRequestLogout(_ coordinator: UserProfileCoordinator)
    func userProfileCoordinatorDidFinish(_ coordinator: UserProfileCoordinator)
    func userProfileCoordinatorDidRequestPlanner(_ coordinator: UserProfileCoordinator)
}


public class UserProfileCoordinator: BaseCoordinator, UserProfileCoordinatorProtocol {
    public var childCoordinators: [BaseCoordinator] = []
    public var navigationController: UINavigationController
    weak var delegate: UserProfileCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let userProfileViewController = UserProfileRouter.assembleModule(coordinator: self)
        navigationController.setViewControllers([userProfileViewController], animated: true)
    }
    
    public func didRequestLogout() {
        delegate?.userProfileCoordinatorDidRequestLogout(self)
    }
    
    public func didFinish() {
        delegate?.userProfileCoordinatorDidFinish(self)
    }
    
    public func showSettings() {
        // TODO: Implement settings navigation
        let alert = UIAlertController(title: "Settings", message: "Settings screen would be shown here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    public func showPlanner() {
        delegate?.userProfileCoordinatorDidRequestPlanner(self)
    }
}
