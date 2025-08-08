//
//  AuthProtocols.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.

@MainActor
public protocol AuthViewProtocol: AnyObject {
    func showError(_ message: String)
        func showSuccess()
        func updateUIForMode(isSignup: Bool)
}

@MainActor
public protocol AuthPresenterProtocol: AnyObject {
    func toggleAuthMode()
    func loginTapped(email: String, password: String)
    func signupTapped(email: String, password: String, passwordConfirmation: String)
}

@MainActor
public protocol AuthInteractorProtocol: AnyObject {
    func login(with credentials: AuthCredentials)
    func signup(with credentials: AuthCredentials)
}

@MainActor
public protocol AuthInteractorOutputProtocol: AnyObject {
    func authSucceeded()
    func authFailed(with error: String)
}

@MainActor
public protocol AuthRouterProtocol: AnyObject {
    func navigateToHome()
}
