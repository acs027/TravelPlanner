//
//  AuthPresenter.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.
//


//MARK: - AuthPresenterProtocol
@MainActor
public protocol AuthPresenterProtocol: AnyObject {
    func toggleAuthMode()
    func loginTapped(email: String, password: String)
    func signupTapped(email: String, password: String, passwordConfirmation: String)
}

public final class AuthPresenter {
    public weak var view: AuthViewProtocol?
    public var interactor: AuthInteractorProtocol
    public var router: AuthRouterProtocol
    
    private var isSignupMode = false

    public init(view: AuthViewProtocol, interactor: AuthInteractorProtocol, router: AuthRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

//MARK: - AuthPresenter-PresenterProtocol
extension AuthPresenter: AuthPresenterProtocol {
    public func toggleAuthMode() {
        isSignupMode.toggle()
        view?.updateUIForMode(isSignup: isSignupMode)
    }
    
    public func loginTapped(email: String, password: String) {
        view?.showProgress()
        guard !email.isEmpty, !password.isEmpty else {
            authFailed(with: "Email and password must not be empty.")
            return
        }
        
        let credentials = AuthCredentials(email: email, password: password)
        interactor.login(with: credentials)
    }
    
    public func signupTapped(email: String, password: String, passwordConfirmation: String) {
        guard !email.isEmpty, !password.isEmpty else {
            authFailed(with: "Email and password must not be empty.")
            return
        }
        
        if passwordConfirmation != password {
            authFailed(with: "Passwords do not match.")
            return
        }
        let credentials = AuthCredentials(email: email, password: password)
        interactor.signup(with: credentials)
    }
}

//MARK: - AuthPresenter-OutputProtocol
extension AuthPresenter: AuthInteractorOutputProtocol {
    public func authSucceeded() {
        view?.hideProgress()
        view?.showSuccess()
        router.navigateToHome()
    }

    public func authFailed(with error: String) {
        view?.hideProgress()
        view?.showError(error)
    }
}
