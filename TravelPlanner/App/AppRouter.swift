//
//  AppRouter.swift
//  TravelPlanner
//
//  Created by Kiro on 19.08.2025.
//

import UIKit
import TravelPlannerAuth
import AIPlanner
import UserProfile
import FirebaseAuth

@MainActor
public class AppRouter {
    private let window: UIWindow
    private var navigationController: UINavigationController
    
    public init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
    }
    
    public func start() {
        if isUserAuthenticated() {
            showPlanner()
        } else {
            showAuth()
        }
    }
    
    private func isUserAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // MARK: - Navigation Methods
    
    public func showAuth() {
        let authViewController = AuthRouter.createModule(delegate: self)
        navigationController.setViewControllers([authViewController], animated: true)
    }
    
    public func showPlanner() {
        let plannerViewController = PlannerRouter.assembleModule(delegate: self)
        navigationController.setViewControllers([plannerViewController], animated: true)
    }
    
    public func showUserProfile() {
        let userProfileViewController = UserProfileRouter.assembleModule(delegate: self)
        navigationController.setViewControllers([userProfileViewController], animated: true)
    }
    
    public func logout() {
        do {
            try Auth.auth().signOut()
            showAuth()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    public func showSettings() {
        let alert = UIAlertController(title: "Settings", message: "Settings screen would be shown here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}

// MARK: - AuthRouterDelegate
extension AppRouter: AuthRouterDelegate {
    public func authRouterDidAuthenticate() {
        showPlanner()
    }
}

// MARK: - PlannerRouterDelegate
extension AppRouter: PlannerRouterDelegate {
    public func plannerRouterDidRequestLogout() {
        logout()
    }
    
    public func plannerRouterDidRequestSettings() {
        showSettings()
    }
    
    public func plannerRouterDidRequestUserProfile() {
        showUserProfile()
    }
}

// MARK: - UserProfileRouterDelegate
extension AppRouter: UserProfileRouterDelegate {
    public func userProfileRouterDidRequestLogout() {
        logout()
    }
    
    public func userProfileRouterDidRequestSettings() {
        showSettings()
    }
    
    public func userProfileRouterDidRequestPlanner() {
        showPlanner()
    }
}