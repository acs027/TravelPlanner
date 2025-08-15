//
//  PlannerCoordinator.swift
//  TravelPlanner
//

import UIKit
import AIPlanner

@MainActor
public protocol PlannerCoordinatorDelegate: AnyObject {
    func plannerCoordinatorDidRequestLogout(_ coordinator: PlannerCoordinator)
    func plannerCoordinatorDidFinish(_ coordinator: PlannerCoordinator)
    func plannerCoordinatorDidRequestUserProfile(_ coordinator: PlannerCoordinator)
}

@MainActor
public class PlannerCoordinator: BaseCoordinator, PlannerCoordinatorProtocol {
    public var childCoordinators: [BaseCoordinator] = []
    public var navigationController: UINavigationController
    weak var delegate: PlannerCoordinatorDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let plannerViewController = PlannerRouter.assembleModule(coordinator: self)
        navigationController.setViewControllers([plannerViewController], animated: true)
    }
    
    public func didRequestLogout() {
        delegate?.plannerCoordinatorDidRequestLogout(self)
    }
    
    public func didFinish() {
        delegate?.plannerCoordinatorDidFinish(self)
    }
    
    public func showSettings() {
        // TODO: Implement settings navigation
        let alert = UIAlertController(title: "Settings", message: "Settings screen would be shown here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    public func showUserProfile() {
        delegate?.plannerCoordinatorDidRequestUserProfile(self)
    }
}
