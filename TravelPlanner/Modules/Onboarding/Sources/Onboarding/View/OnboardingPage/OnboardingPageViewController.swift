//
//  OnboardingPageViewController.swift
//  Onboarding
//
//  Created by ali cihan on 22.08.2025.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    var pageIndex: Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    public init() {
        let bundle = Bundle.module
        print("Loading XIB from bundle: \(bundle)")
        super.init(nibName: "OnboardingPageViewController", bundle: bundle)
    }
    
    func setupUI(data: OnboardingPageInfo) {
        loadViewIfNeeded()
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        imageView.image = UIImage(named: data.imageName)
    }
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

