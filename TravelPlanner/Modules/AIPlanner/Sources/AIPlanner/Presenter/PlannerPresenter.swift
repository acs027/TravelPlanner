//
//  PlannerPresenter.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import AppResources

protocol PlannerPresenterProtocol {
    @MainActor func didTapSend(prompt: String)
    @MainActor func didSelectLocation(_ location: TravelLocation)
}

@MainActor
class PlannerPresenter: PlannerPresenterProtocol {
    weak var view: PlannerViewProtocol?
    var interactor: PlannerInteractorProtocol
    var router: PlannerRouterProtocol
    
    init(view: PlannerViewProtocol, interactor: PlannerInteractorProtocol, router: PlannerRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func didTapSend(prompt: String) {
        view?.updateState(.loading)
        interactor.fetchTravelLocations(prompt: prompt)
    }
    
    func didSelectLocation(_ location: TravelLocation) {
        interactor.focusMapOnLocation(location)
    }
    
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



