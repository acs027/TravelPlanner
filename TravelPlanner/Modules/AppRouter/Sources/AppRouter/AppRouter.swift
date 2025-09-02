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
import Splash
import Onboarding
import Folder

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
        showSplash()
    }
    
    private func isUserAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // MARK: - Navigation Methods
    public func tabBar() {
        let tabBarController = TabBarController(routerDelegate: self)
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
    
    public func showSplash() {
        let splashViewController = SplashRouter.assembleModule(delegate: self)
        navigationController.setViewControllers([splashViewController], animated: true)
    }
    
    public func showOnboarding() {
        let onboardingViewController = OnboardingRouter.assembleModule(delegate: self)
        navigationController.setViewControllers([onboardingViewController], animated: true)
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
    
    private func navigationFlow() {
        if isUserAuthenticated() {
            tabBar()
        } else {
            showAuth()
        }
    }
}

// MARK: - AuthRouterDelegate
extension AppRouter: AuthRouterDelegate {
    public func authRouterDidAuthenticate() {
        tabBar()
    }
}

extension AppRouter: OnboardingRouterDelegate {
    public func didFinishOnboarding() {
        navigationFlow()
    }
}

//MARK: - SplashRouterDelegates
extension AppRouter: SplashRouterDelegate {
    public func didFinishSplash() {
        if let isOnboardingShowed = UserDefaults.standard.object(forKey: "isOnboardingShowed") as? Bool,
           isOnboardingShowed {
            debugPrint("nav flow")
            navigationFlow()
            
        } else {
            debugPrint("show onboarding")
            showOnboarding()
            
        }
    }
}

// MARK: - PlannerRouterDelegate
extension AppRouter: PlannerRouterDelegate {
    
}

// MARK: - UserProfileRouterDelegate
extension AppRouter: UserProfileRouterDelegate {
    public func userProfileRouterDidRequestLogout() {
        logout()
    }
    
    public func userProfileRouterDidRequestSettings() {
        showSettings()
    }
}


// MARK: - TabBarControllerDelegate
extension AppRouter: TabBarControllerDelegate {
    
    // This extension automatically conforms to both PlannerRouterDelegate and UserProfileRouterDelegate
    // since TabBarControllerDelegate inherits from both
}
