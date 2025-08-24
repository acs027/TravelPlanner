//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by ali cihan on 23.08.2025.
//

import UIKit

@MainActor
protocol OnboardingViewControllerProtocol: AnyObject {
    func skipOnboarding()
}

public final class OnboardingViewController: UIViewController {
    var presenter: OnboardingPresenterProtocol!
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareOnboardingPage()
    }
    
    
    private func setupUI() {
        
        view.addSubview(skipButton)
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            skipButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func prepareOnboardingPage() {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.secondaryLabel
        pageControl.currentPageIndicatorTintColor = UIColor.label
        pageControl.backgroundColor = UIColor.systemBackground
        
        let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageViewController.setViewControllers([presenter.getPage(index: 1)], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        pageViewController.view.backgroundColor = UIColor.systemBackground
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.bounds
        pageViewController.didMove(toParent: self)
        
        
        view.bringSubviewToFront(skipButton)
    }
    
    
    
    @objc private func skipTapped() {
        skipOnboarding()
    }
    
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc: OnboardingPageViewController = viewController as? OnboardingPageViewController else {
            return nil
        }
        if vc.pageIndex > 1 {
            let pageIndex = vc.pageIndex - 1
            return presenter.getPage(index: pageIndex)
        } else {
            return nil
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc: OnboardingPageViewController = viewController as? OnboardingPageViewController else {
            return nil
        }
        
        if vc.pageIndex < 4 {
            let pageIndex = vc.pageIndex + 1
            return presenter.getPage(index: pageIndex)
        } else {
            print("finished")
            return UIViewController()
        }
        
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        3
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}


extension OnboardingViewController: OnboardingViewControllerProtocol {
    func skipOnboarding() {
        presenter.skipOnboarding()
    }
}
