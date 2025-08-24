//
//  File.swift
//  Splash
//
//  Created by ali cihan on 20.08.2025.
//

import Foundation

@MainActor
protocol SplashPresenterProtocol {
    func checkConnection()
}

final class SplashPresenter {
    weak var view: SplashViewControllerProtocol?
    var interactor: SplashInteractorProtocol
    var router: SplashRouterProtocol
    
    init(view: SplashViewControllerProtocol? = nil, interactor: SplashInteractorProtocol, router: SplashRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension SplashPresenter: SplashPresenterProtocol {
    func checkConnection() {
        interactor.isConnected()
    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    func isConnectedOutput(_ status: Bool) {
        switch status {
        case true:
            router.didFinishSplash()
            
            
        case false:
            view?.showAlert(title: "Connection Error", message: "Check your connection!")
        }
    }
}
