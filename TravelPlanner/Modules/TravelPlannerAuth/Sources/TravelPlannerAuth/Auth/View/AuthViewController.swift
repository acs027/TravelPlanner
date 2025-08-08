//
//  AuthViewController.swift
//  TravelPlanner
//
//  Created by ali cihan on 4.08.2025.
//



import UIKit

final class AuthViewController: UIViewController, AuthViewProtocol {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextFeild: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var switchToLoginButton: UIButton!
    @IBOutlet weak var switchToSignupButton: UIButton!
    
    var presenter: AuthPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        switchToLoginButton.addTarget(self, action: #selector(switchToLoginTapped), for: .touchUpInside)
        switchToSignupButton.addTarget(self, action: #selector(switchToSignupTapped), for: .touchUpInside)
    }
    
    @objc private func loginTapped() {
        presenter.loginTapped(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        
    }
    
    @objc private func signupTapped() {
        presenter.signupTapped(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? "",
            passwordConfirmation: rePasswordTextFeild.text ?? ""
        )
    }
    
    @objc private func switchToLoginTapped() {
        presenter.toggleAuthMode()
    }
    
    @objc private func switchToSignupTapped() {
        presenter.toggleAuthMode()
    }

    
    func updateUIForMode(isSignup: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.rePasswordTextFeild.isHidden = !isSignup
            self.signupButton.isHidden = !isSignup
            self.switchToLoginButton.isHidden = !isSignup
            self.loginButton.isHidden = isSignup
            self.switchToSignupButton.isHidden = isSignup
        }
    }
    
    func showError(_ message: String) {
        
        //        let alert = UIAlertController(title: "Auth Error", message: message, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .default))
        //        present(alert, animated: true)
    }
    
    func showSuccess() {
        // Optional: Add UI feedback
    }
}

