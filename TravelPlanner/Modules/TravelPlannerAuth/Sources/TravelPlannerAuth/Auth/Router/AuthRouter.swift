//
//  AuthRouter.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.
//

import UIKit

@MainActor
public protocol AuthCoordinatorProtocol: AnyObject {
    func didAuthenticate()
}

public final class AuthRouter: AuthRouterProtocol {
    public weak var viewController: UIViewController?
    private weak var coordinator: AuthCoordinatorProtocol?

    @MainActor
    public static func createModule() -> UIViewController {
        return createModule(coordinator: nil)
    }
    
    @MainActor
    public static func createModule(coordinator: AuthCoordinatorProtocol?) -> UIViewController {
        let bundle = Bundle.module
        let view = AuthViewController(nibName: "AuthViewController", bundle: bundle)
        let interactor = AuthInteractor()
        let router = AuthRouter()
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        router.coordinator = coordinator

        return view
    }

    public func navigateToHome() {
        coordinator?.didAuthenticate()
    }
    
    public func navigateToPlanner() {
        coordinator?.didAuthenticate()
    }
}
