//
//  AuthInteractor.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.
//
import FirebaseAuth

public final class AuthInteractor: AuthInteractorProtocol {
    public weak var output: AuthInteractorOutputProtocol?

    public init() {}

    public func login(with credentials: AuthCredentials) {
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { result, error in
            if let error = error {
                self.output?.authFailed(with: error.localizedDescription)
            } else {
                self.output?.authSucceeded()
            }
        }
    }

    public func signup(with credentials: AuthCredentials) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
            if let error = error {
                self.output?.authFailed(with: error.localizedDescription)
            } else {
                self.output?.authSucceeded()
            }
        }
    }
}
