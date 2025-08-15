//
//  AppCoordinator.swift
//  TravelPlanner
//

import UIKit
import TravelPlannerAuth
import AIPlanner
import UserProfile
import FirebaseAuth

@MainActor
public class AppCoordinator: BaseCoordinator {
    public var childCoordinators: [BaseCoordinator] = []
    public var navigationController: UINavigationController
    private let window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
    }
    
    public func start() {
        // Check if user is already authenticated
        if isUserAuthenticated() {
            showPlanner()
        } else {
            showAuth()
        }
    }
    
    private func isUserAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func showAuth() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
    }
    
    private func showPlanner() {
        let plannerCoordinator = PlannerCoordinator(navigationController: navigationController)
        plannerCoordinator.delegate = self
        addChildCoordinator(plannerCoordinator)
        plannerCoordinator.start()
    }
    
    private func showUserProfile() {
        let userProfileCoordinator = UserProfileCoordinator(navigationController: navigationController)
        userProfileCoordinator.delegate = self
        addChildCoordinator(userProfileCoordinator)
        userProfileCoordinator.start()
    }
}

// MARK: - AuthCoordinatorDelegate
extension AppCoordinator: AuthCoordinatorDelegate {
    public func authCoordinatorDidAuthenticate(_ coordinator: AuthCoordinator) {
        removeChildCoordinator(coordinator)
        showPlanner()
    }
    
    public func authCoordinatorDidCancel(_ coordinator: AuthCoordinator) {
        removeChildCoordinator(coordinator)
        // Handle cancellation if needed
    }
}

// MARK: - PlannerCoordinatorDelegate
extension AppCoordinator: PlannerCoordinatorDelegate {
    public func plannerCoordinatorDidRequestLogout(_ coordinator: PlannerCoordinator) {
        removeChildCoordinator(coordinator)
        showAuth()
    }
    
    public func plannerCoordinatorDidFinish(_ coordinator: PlannerCoordinator) {
        removeChildCoordinator(coordinator)
        // Handle finish if needed
    }
    
    public func plannerCoordinatorDidRequestUserProfile(_ coordinator: PlannerCoordinator) {
        removeChildCoordinator(coordinator)
        showUserProfile()
    }
}

// MARK: - UserProfileCoordinatorDelegate
extension AppCoordinator: UserProfileCoordinatorDelegate {
    public func userProfileCoordinatorDidRequestPlanner(_ coordinator: UserProfileCoordinator) {
        removeChildCoordinator(coordinator)
        showPlanner()
    }
    
    public func userProfileCoordinatorDidFinish(_ coordinator: UserProfileCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
    public func userProfileCoordinatorDidRequestLogout(_ coordinator: UserProfileCoordinator) {
        removeChildCoordinator(coordinator)
        showAuth()
    }
}
