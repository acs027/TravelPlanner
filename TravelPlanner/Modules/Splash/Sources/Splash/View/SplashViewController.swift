//
//  SplashViewController.swift
//  Splash
//
//  Created by ali cihan on 20.08.2025.
//

import UIKit
import DotLottie

@MainActor
protocol SplashViewControllerProtocol: AnyObject {
    func showAlert(title: String, message: String)
}

final class SplashViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    var presenter: SplashPresenterProtocol!
    let lottieAnimation = DotLottieAnimation(fileName: "splashLottie", bundle: .module, config: AnimationConfig(autoplay: true, loop: true))

    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dotLottieView: UIView = lottieAnimation.view()
        dotLottieView.frame = containerView.bounds
        dotLottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(dotLottieView)
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
