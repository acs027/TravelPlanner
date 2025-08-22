//
//  File.swift
//  Splash
//
//  Created by ali cihan on 20.08.2025.
//

import Foundation
import UIKit
import TabBar

@MainActor
public protocol SplashRouterDelegate: AnyObject {
    func didFinishSplash()
}

@MainActor
protocol SplashRouterProtocol {
    func navigate(_ route: SplashRoutes)
    func didFinishSplash()
}

enum SplashRoutes {
    case onboarding
    case tabBar
}

@MainActor
public final class SplashRouter {
    public weak var delegate: SplashRouterDelegate?
    weak var viewController: SplashViewController?
    
    public static func assembleModule() -> UIViewController {
        return assembleModule(delegate: nil)
    }
    
    public static func assembleModule(delegate: SplashRouterDelegate?) -> UIViewController {
        let vc = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        let presenter = SplashPresenter(view: vc, interactor: interactor, router: router)
        
        vc.presenter = presenter
        interactor.output = presenter
        router.delegate = delegate
        router.viewController = vc
        return vc
    }
}

extension SplashRouter: SplashRouterProtocol {
    func navigate(_ route: SplashRoutes) {
        return
    }
    
    func didFinishSplash() {
        delegate?.didFinishSplash()
    }
}
