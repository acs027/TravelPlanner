//
//  File.swift
//  UserProfile
//
//  Created by ali cihan on 13.08.2025.
//

import Foundation
import FirebaseAuth

@MainActor
protocol UserProfileInteractorProtocol {
    func logout()
    func fetchUser()
}

@MainActor
protocol UserProfileInteractorOutputProtocol: AnyObject {
    func didLogout()
    func didFetchUser(_ user: User?)
}


final class UserProfileInteractor {
    weak var output: UserProfileInteractorOutputProtocol?
}

extension UserProfileInteractor: UserProfileInteractorProtocol {
    func logout() {
        do {
            try Auth.auth().signOut()
            output?.didLogout()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            // Still call didLogout to handle the UI state
            output?.didLogout()
        }
    }
    
    func fetchUser()  {
        if let currentUser = Auth.auth().currentUser {
            let user = User(id: currentUser.uid, email: currentUser.email, displayName: currentUser.displayName, photoURL: currentUser.photoURL)
            output?.didFetchUser(user)
        }
    }
}


