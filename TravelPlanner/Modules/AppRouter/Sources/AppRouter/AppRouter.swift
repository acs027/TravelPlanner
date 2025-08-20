//
//  AppRouter.swift
//  TravelPlanner
//
//

import UIKit
import TravelPlannerAuth
import AIPlanner
import UserProfile
import FirebaseAuth
import TabBar

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
            tabBar()
        } else {
            showAuth()
        }
    }
    
    private func isUserAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // MARK: - Navigation Methods
    public func tabBar() {
        let tabBarController = TabBarController(routerDelegate: self)
//        tabBarController.routerDelegate = self
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
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
        print("🔴 AppRouter: logout() called")
        do {
            try Auth.auth().signOut()
            print("🔴 AppRouter: Firebase signOut successful, navigating to auth")
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
        tabBar()
    }
}

// MARK: - PlannerRouterDelegate
extension AppRouter: PlannerRouterDelegate {
    public func plannerRouterDidRequestLogout() {
        print("🔴 AppRouter: plannerRouterDidRequestLogout called")
        logout()
    }
    
    public func plannerRouterDidRequestSettings() {
        print("⚙️ AppRouter: plannerRouterDidRequestSettings called")
        showSettings()
    }
    
    public func plannerRouterDidRequestUserProfile() {
        print("👤 AppRouter: plannerRouterDidRequestUserProfile called")
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
        tabBar()
    }
}

// MARK: - TabBarControllerDelegate
extension AppRouter: TabBarControllerDelegate {
    // This extension automatically conforms to both PlannerRouterDelegate and UserProfileRouterDelegate
    // since TabBarControllerDelegate inherits from both
}
