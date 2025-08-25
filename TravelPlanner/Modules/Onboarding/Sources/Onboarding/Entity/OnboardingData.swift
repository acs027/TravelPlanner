//
//  File.swift
//  Onboarding
//
//  Created by ali cihan on 24.08.2025.
//

import Foundation

struct OnboardingPagesData {
    let pagesData : [OnboardingPageInfo] = [
        OnboardingPageInfo(
                title: "Discover with AI",
                description: "Just tell us your dream destination and get a list of must-see touristic spots instantly.",
                imageName: "onboardingFirstImage",
                buttonText: "Skip"
            ),
            OnboardingPageInfo(
                title: "Personalized Itineraries",
                description: "Our AI creates tailored travel plans that fit your style, interests, and time.",
                imageName: "onboardingFirstImage",
                buttonText: "Skip"
            ),
            OnboardingPageInfo(
                title: "Explore Smarter",
                description: "Save places, view maps, and make the most out of your journey with our smart guide.",
                imageName: "onboardingFirstImage",
                buttonText: "Get Started"
            )
    ]
}

struct OnboardingPageInfo {
    let title: String
    let description: String
    let imageName: String
    let buttonText: String?
}
