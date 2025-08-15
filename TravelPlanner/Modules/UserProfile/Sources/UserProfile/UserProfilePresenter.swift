//
//  File.swift
//  UserProfile
//
//  Created by ali cihan on 13.08.2025.
//

import Foundation

@MainActor
protocol UserProfilePresenterProtocol {
    func didRequestLogout()
}


class UserProfilePresenter: UserProfilePresenterProtocol {
    
    
    weak var view: UserProfileViewProtocol?
    var interactor: UserProfileInteractorProtocol
    var router: UserProfileRouterProtocol
    
    init(view: UserProfileViewProtocol, interactor: UserProfileInteractorProtocol, router: UserProfileRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func didRequestLogout() {
        interactor.logout()
    }
}

extension UserProfilePresenter: UserProfileInteractorOutputProtocol {
    func didLogout() {
        router.navigateToAuth()
    }
}
