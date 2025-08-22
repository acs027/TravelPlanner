//
//  PlannerPresenter.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import AppResources

@MainActor
protocol PlannerPresenterProtocol {
    func didTapSend(prompt: String)
    func didSelectLocation(_ location: TravelLocation)
//    func didRequestLogout()
//    func didRequestSettings()
//    func didRequestUserProfile()
}


final class PlannerPresenter {
    weak var view: PlannerViewProtocol?
    var interactor: PlannerInteractorProtocol
    var router: PlannerRouterProtocol
    
    init(view: PlannerViewProtocol, interactor: PlannerInteractorProtocol, router: PlannerRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension PlannerPresenter: PlannerPresenterProtocol {
    func didTapSend(prompt: String) {
        view?.updateState(.loading)
        interactor.fetchTravelLocations(prompt: prompt)
    }
    
    func didSelectLocation(_ location: TravelLocation) {
        interactor.focusMapOnLocation(location)
    }
//    
//    func didRequestLogout() {
//        print("🔴 PlannerPresenter: didRequestLogout called")
//        router.navigateToAuth()
//    }
    
//    func didRequestSettings() {
//        print("⚙️ PlannerPresenter: didRequestSettings called")
//        router.navigateToSettings()
//    }
//    
//    func didRequestUserProfile() {
//        print("👤 PlannerPresenter: didRequestUserProfile called")
//        router.navigateToUserProfile()
//    }
}

extension PlannerPresenter: PlannerInteractorOutputProtocol {
    func focusMapOn(_ location: TravelLocation) {
        view?.focusMapOn(location)
    }
    
    func locationsFetched(_ locations: [TravelLocation]) {
        view?.updateState(.success(locations))
    }
    
    func fetchingFailed(error: Error) {
        view?.updateState(.failure(error))
    }
}



