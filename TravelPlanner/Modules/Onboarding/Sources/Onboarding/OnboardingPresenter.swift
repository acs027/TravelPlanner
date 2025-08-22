//
//  File.swift
//  Onboarding
//
//  Created by ali cihan on 22.08.2025.
//

import Foundation

@MainActor
protocol OnboardingPresenterProtocol {
    func skipOnboarding()
}

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
}

extension OnboardingPresenter: OnboardingInteractorOutputProtocol {
    func didFinishOnboarding() {
        router.didFinishOnboarding()
    }
}
