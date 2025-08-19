//
//  AuthRouter.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.
//

import UIKit

@MainActor
public protocol AuthRouterDelegate: AnyObject {
    func authRouterDidAuthenticate()
}

public final class AuthRouter: AuthRouterProtocol {
    public weak var viewController: UIViewController?
    public weak var delegate: AuthRouterDelegate?

    public static func createModule() -> UIViewController {
        return createModule(delegate: nil)
    }
    
    public static func createModule(delegate: AuthRouterDelegate?) -> UIViewController {
        let bundle = Bundle.module
        let view = AuthViewController(nibName: "AuthViewController", bundle: bundle)
        let interactor = AuthInteractor()
        let router = AuthRouter()
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        router.delegate = delegate

        return view
    }

    public func navigateToHome() {
        delegate?.authRouterDidAuthenticate()
    }
    
    public func navigateToPlanner() {
        delegate?.authRouterDidAuthenticate()
    }
}
