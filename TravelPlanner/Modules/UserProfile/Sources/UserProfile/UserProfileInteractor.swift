//
//  File.swift
//  UserProfile
//
//  Created by ali cihan on 13.08.2025.
//

import Foundation

@MainActor
protocol UserProfileInteractorProtocol {
    func logout()
}

protocol UserProfileInteractorOutputProtocol: AnyObject {
    @MainActor func didLogout()
}

@MainActor
class UserProfileInteractor: UserProfileInteractorProtocol {
    weak var output: UserProfileInteractorOutputProtocol?
    
    
    func logout() {
        output?.didLogout()
    }
}
