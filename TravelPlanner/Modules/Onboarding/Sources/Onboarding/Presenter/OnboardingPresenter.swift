//
//  File.swift
//  Onboarding
//
//  Created by ali cihan on 22.08.2025.
//

import Foundation
import UIKit

@MainActor
protocol OnboardingPresenterProtocol {
    func skipOnboarding()
    func getPage(index: Int) -> OnboardingPageViewController
}

@MainActor
final class OnboardingPresenter {
    weak var view: OnboardingViewControllerProtocol?
    var interactor: OnboardingInteractorProtocol
    var router: OnboardingRouterProtocol
    
    
    init(view: OnboardingViewControllerProtocol? = nil, interactor: OnboardingInteractorProtocol, router: OnboardingRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension OnboardingPresenter: OnboardingPresenterProtocol {
    func skipOnboarding() {
        interactor.toggleIsOnboardingShowed()
    }
    
    func getPage(index: Int) -> OnboardingPageViewController {
        guard let data = interactor.getOnboardingPageContentData(index: index) else {
            return OnboardingPageViewController()
        }
        let onboardingPageViewController = OnboardingPageViewController()
        onboardingPageViewController.pageIndex = index
        onboardingPageViewController.setupUI(data: data)
        return onboardingPageViewController
    }
}

extension OnboardingPresenter: OnboardingInteractorOutputProtocol {
    func didFinishOnboarding() {
        router.didFinishOnboarding()
    }
}
