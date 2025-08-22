//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by ali cihan on 22.08.2025.
//

import UIKit

@MainActor
protocol OnboardingViewControllerProtocol: AnyObject {
    func skipOnboarding()
}

final class OnboardingViewController: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    var presenter: OnboardingPresenterProtocol!
    
    public init() {
        let bundle = Bundle.module
        print("Loading XIB from bundle: \(bundle)")
        super.init(nibName: "OnboardingViewController", bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    @objc private func skipTapped() {
        skipOnboarding()
    }
}

extension OnboardingViewController: OnboardingViewControllerProtocol {
    func skipOnboarding() {
        presenter.skipOnboarding()
    }
}
