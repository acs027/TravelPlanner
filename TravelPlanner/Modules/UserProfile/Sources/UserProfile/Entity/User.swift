//
//  User.swift
//  UserProfile
//
//  Created by ali cihan on 19.08.2025.
//

import Foundation

struct User {
    let id: String
    let email: String
    let displayName: String
    let photoURL: URL?
    
    init(id: String, email: String?, displayName: String?, photoURL: URL?) {
        self.id = id
        self.email = email ?? ""
        self.displayName = displayName ?? ""
        self.photoURL = photoURL
    }
}
