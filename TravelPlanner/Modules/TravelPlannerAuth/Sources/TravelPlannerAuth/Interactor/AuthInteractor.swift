//
//  AuthInteractor.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.
//
import FirebaseAuth

// MARK: - AuthInteractorProtocol
@MainActor
public protocol AuthInteractorProtocol: AnyObject {
    func login(with credentials: AuthCredentials)
    func signup(with credentials: AuthCredentials)
}

// MARK: - AuthInteractorOutputProtocol
@MainActor
public protocol AuthInteractorOutputProtocol: AnyObject {
    func authSucceeded()
    func authFailed(with error: String)
}

public final class AuthInteractor {
    public weak var output: AuthInteractorOutputProtocol?

    public init() {}
}

// MARK: - AuthInteractor-Protocol
extension AuthInteractor: AuthInteractorProtocol {
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
