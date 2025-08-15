//
//  Coordinator.swift
//  TravelPlanner
//

import UIKit

@MainActor
public protocol BaseCoordinator: AnyObject {
    var childCoordinators: [BaseCoordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

public extension BaseCoordinator {
    func addChildCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
