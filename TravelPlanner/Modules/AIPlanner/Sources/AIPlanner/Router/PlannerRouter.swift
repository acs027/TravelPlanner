//
//  PlannerRouter.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import UIKit

public protocol PlannerRouterProtocol {}

@MainActor
public class PlannerRouter: PlannerRouterProtocol {
    public static func assembleModule() -> UIViewController {
        let vc = PlannerViewController()
        let interactor = PlannerInteractor()
        let router = PlannerRouter()
        let presenter = PlannerPresenter(view: vc, interactor: interactor, router: router)
        
        vc.presenter = presenter
        interactor.output = presenter
        return vc
    }
}
