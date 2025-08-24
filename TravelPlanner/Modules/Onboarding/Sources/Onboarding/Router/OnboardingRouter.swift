//
//  File.swift
//  Onboarding
//
//  Created by ali cihan on 22.08.2025.
//

import Foundation
import UIKit

@MainActor
public protocol OnboardingRouterDelegate: AnyObject {
    func didFinishOnboarding()
}

@MainActor
protocol OnboardingRouterProtocol {
    func didFinishOnboarding()
}

@MainActor
public final class OnboardingRouter {
    public weak var delegate: OnboardingRouterDelegate?
    
    public static func assembleModule() -> UIViewController {
        return assembleModule(delegate: nil)
    }
    
    public static func assembleModule(delegate: OnboardingRouterDelegate?) -> UIViewController {
        let vc = OnboardingViewController()
        let interactor = OnboardingInteractor()
        let router = OnboardingRouter()
        let presenter = OnboardingPresenter(view: vc, interactor: interactor, router: router)
        
        vc.presenter = presenter
        interactor.output = presenter
        router.delegate = delegate
        return vc
    }
}

extension OnboardingRouter: OnboardingRouterProtocol {
    func didFinishOnboarding() {
        delegate?.didFinishOnboarding()
    }
}
