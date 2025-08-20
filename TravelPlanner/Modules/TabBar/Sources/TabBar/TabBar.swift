//
//  TabBar.swift
//  TravelPlanner
import UIKit
import AIPlanner
import UserProfile

@MainActor
public protocol TabBarControllerDelegate: PlannerRouterDelegate, UserProfileRouterDelegate {
    func plannerRouterDidRequestUserProfile()
}

public class TabBarController: UITabBarController {
    public weak var routerDelegate: TabBarControllerDelegate?
    
    public init(routerDelegate: TabBarControllerDelegate) {
          self.routerDelegate = routerDelegate
          super.init(nibName: nil, bundle: nil)
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
}

// MARK: - Functions
private extension TabBarController {
    final func setupTabbar() {
        print("📱 TabBarController: setupTabbar called, routerDelegate: \(String(describing: routerDelegate))")
        
        /// AIPlannerViewController
        let plannerVC = PlannerRouter.assembleModule(delegate: routerDelegate)
        let plannerNavigationController = getStyledNavigationController(with: plannerVC, title: "AI Planner", image: UIImage(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.filled.scurvepath")!)
        
        /// UserProfileViewController
        let userProfileVC = UserProfileRouter.assembleModule(delegate: routerDelegate)
        let userProfileNavigationController = getStyledNavigationController(with: userProfileVC, title:"Profile", image: UIImage(systemName: "person.circle.fill")!)
        
        
        viewControllers = [plannerNavigationController, userProfileNavigationController]
        customizeTabBarAppearance()
    }
    
    final func getStyledNavigationController(with viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        viewController.title = title
        let navigationController = UINavigationController(rootViewController: viewController)
        let resizedImage = UIImage.resizeImage(image: image, targetSize:  CGSize(width: 35, height: 35))?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem = UITabBarItem(title: title, image: resizedImage, tag: 0)
        
        return navigationController
    }
    
    final func customizeTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.backgroundColor = UIColor.systemGray6
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}


