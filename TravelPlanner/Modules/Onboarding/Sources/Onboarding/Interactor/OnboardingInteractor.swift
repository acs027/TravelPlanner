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
    func getOnboardingPageContentData(index: Int) -> OnboardingPageInfo?
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
    
    func getOnboardingPageContentData(index: Int) -> OnboardingPageInfo? {
        let pages = OnboardingPagesData().pagesData
        guard index - 1 >= 0, index - 1 < pages.count else {
            return nil
        }
        let data = pages[index - 1]
        return data
    }
}
