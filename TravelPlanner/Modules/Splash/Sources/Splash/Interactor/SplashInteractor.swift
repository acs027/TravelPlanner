//
//  File.swift
//  Splash
//
//  Created by ali cihan on 20.08.2025.
//

import Foundation

@MainActor
protocol SplashInteractorProtocol {
    func isConnected()
}

@MainActor
protocol SplashInteractorOutputProtocol: AnyObject {
    func isConnectedOutput(_ status: Bool)
}

final class SplashInteractor {
    weak var output: SplashInteractorOutputProtocol?
    
}

extension SplashInteractor: SplashInteractorProtocol {
    func isConnected() {
        let status = true
        output?.isConnectedOutput(status)
    }
}
