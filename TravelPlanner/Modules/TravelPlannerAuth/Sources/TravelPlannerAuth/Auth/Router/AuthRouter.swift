//
//  AuthRouter.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.
//

import UIKit

public final class AuthRouter: AuthRouterProtocol {
    public weak var viewController: UIViewController?

    @MainActor
    public static func createModule() -> UIViewController {
        let bundle = Bundle.module
        let view = AuthViewController(nibName: "AuthViewController", bundle: bundle)
        let interactor = AuthInteractor()
        let router = AuthRouter()
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view

        return view
    }

    public func navigateToHome() {
        let alert = UIAlertController(title: "Welcome", message: "Login successful", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
}
