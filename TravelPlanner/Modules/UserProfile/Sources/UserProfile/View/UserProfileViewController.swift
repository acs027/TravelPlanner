//
//  UserProfileViewController.swift
//  UserProfile
//
//  Created by ali cihan on 12.08.2025.
//

import UIKit

@MainActor
protocol UserProfileViewProtocol: AnyObject {
    func updateUserProfile(user: User?)
}

final class UserProfileViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    var presenter: UserProfilePresenterProtocol!
    
    public init() {
        let bundle = Bundle.module
        print("Loading XIB from bundle: \(bundle)")
        super.init(nibName: "UserProfileViewController", bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailContainerView.layer.cornerRadius = emailContainerView.frame.height / 2
        emailContainerView.layer.masksToBounds = true
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        presenter.didRequestFetchUsser()

        // Do any additional setup after loading the view.
    }
    
    @objc private func logoutTapped() {
        presenter.didRequestLogout()
    }
}

extension UserProfileViewController: UserProfileViewProtocol {
    public func updateUserProfile(user: User?) {
        if let user = user {
            self.emailLabel.text = user.email
            self.displayName.text = user.displayName
            if let photoURL = user.photoURL {
                self.userImage.load(url: photoURL)
            }
        }
    }
}


