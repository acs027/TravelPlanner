//
//  File.swift
//  AIPlanner
//
//  Created by ali cihan on 27.08.2025.
//

import Foundation
import AppResources
import UIKit


protocol FoldersRouterProtocol {
    
}

@MainActor
public final class FoldersRouter {
    public static func assembleModule(
           location: TravelLocation,
       ) -> UIViewController {
           let vc = FoldersViewController()
           let interactor = FoldersInteractor()
           let router = FoldersRouter()
           let presenter = FoldersPresenter(
               view: vc,
               interactor: interactor,
               router: router,
               location: location,
           )
           
           vc.presenter = presenter
           interactor.output = presenter
           return vc
       }
}

extension FoldersRouter: FoldersRouterProtocol {
    
}
