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
        
        /// MainViewController
        let plannerVC = PlannerRouter.assembleModule(delegate: routerDelegate)
        let plannerNavigationController = getStyledNavigationController(with: plannerVC, title: "1", image: UIImage(systemName: "house")!)
        
        /// SpecialViewController
        let userProfileVC = UserProfileRouter.assembleModule(delegate: routerDelegate)
        let userProfileNavigationController = getStyledNavigationController(with: userProfileVC, title:"2", image: UIImage(systemName: "house")!)
        
//        /// Favorites
//        let favoritesVC = FavoritesRouter.createModule()
//        let favoritesNavigationController = getStyledNavigationController(with: favoritesVC, title: "3", image: UIImage(systemName: "house")!)
        
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

extension UIImage {
    
    public class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
