//
//  File.swift
//  Onboarding
//
//  Created by ali cihan on 22.08.2025.
//

import Foundation

@MainActor
protocol OnboardingInteractorProtocol {
    func toggleIsOnboardingShowed()
}

@MainActor
protocol OnboardingInteractorOutputProtocol: AnyObject {
    func didFinishOnboarding()
}


final class OnboardingInteractor {
    weak var output: OnboardingInteractorOutputProtocol?
    
}

extension OnboardingInteractor: OnboardingInteractorProtocol {
    func toggleIsOnboardingShowed() {
        UserDefaults.standard.set(true, forKey: "isOnboardingShowed")
        output?.didFinishOnboarding()
    }
}
