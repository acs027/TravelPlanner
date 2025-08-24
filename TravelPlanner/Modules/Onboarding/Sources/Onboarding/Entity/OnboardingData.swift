//
//  File.swift
//  Onboarding
//
//  Created by ali cihan on 24.08.2025.
//

import Foundation

struct OnboardingPagesData {
    let pagesData : [OnboardingPageInfo] = [
        OnboardingPageInfo(title: "1", description: "descp", imageName: "image", buttonText: "text"),
        OnboardingPageInfo(title: "2", description: "descp", imageName: "image", buttonText: "text"),
        OnboardingPageInfo(title: "3", description: "descp", imageName: "image", buttonText: "text"),
    ]
}

struct OnboardingPageInfo {
    let title: String
    let description: String
    let imageName: String
    let buttonText: String?
}
