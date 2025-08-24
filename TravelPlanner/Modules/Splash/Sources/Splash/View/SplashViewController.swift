//
//  SplashViewController.swift
//  Splash
//
//  Created by ali cihan on 20.08.2025.
//

import UIKit

@MainActor
protocol SplashViewControllerProtocol: AnyObject {
    func showAlert(title: String, message: String)
}

final class SplashViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var presenter: SplashPresenterProtocol!
    
    public init() {
        let bundle = Bundle.module
        print("Loading XIB from bundle: \(bundle)")
        super.init(nibName: "SplashViewController", bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = .checkmark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.checkConnection()
    }

}

extension SplashViewController: SplashViewControllerProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
