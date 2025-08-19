//
//  File.swift
//  UserProfile
//
//  Created by ali cihan on 13.08.2025.
//

import Foundation
import FirebaseAuth

@MainActor
protocol UserProfilePresenterProtocol {
    func didRequestLogout()
    func didRequestFetchUsser()
}


final class UserProfilePresenter {
    weak var view: UserProfileViewProtocol?
    var interactor: UserProfileInteractorProtocol
    var router: UserProfileRouterProtocol
    
    init(view: UserProfileViewProtocol, interactor: UserProfileInteractorProtocol, router: UserProfileRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension UserProfilePresenter: UserProfilePresenterProtocol {
    func didRequestLogout() {
        interactor.logout()
    }
    
    func didRequestFetchUsser() {
        interactor.fetchUser()
    }
}

extension UserProfilePresenter: UserProfileInteractorOutputProtocol {
    func didLogout() {
        router.navigateToAuth()
    }
    
    func didFetchUser(_ user: User?) {
        view?.updateUserProfile(user: user)
    }
}
