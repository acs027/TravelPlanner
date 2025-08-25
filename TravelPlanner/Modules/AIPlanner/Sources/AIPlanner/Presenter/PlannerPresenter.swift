//
//  PlannerPresenter.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import AppResources
import TravelPlannerNetwork
import Combine

@MainActor
protocol PlannerPresenterProtocol {
    func didTapSend(prompt: String)
    func didSelectLocation(_ location: TravelLocation)
    func handleNetworkChange(isConnected: Bool)
}

@MainActor
final class PlannerPresenter {
    weak var view: PlannerViewProtocol?
    var interactor: PlannerInteractorProtocol
    var router: PlannerRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(view: PlannerViewProtocol, interactor: PlannerInteractorProtocol, router: PlannerRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        observeReachability()
    }
    
    
    private func observeReachability() {
        ReachabilityManager.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.handleNetworkChange(isConnected: isConnected)
                print(isConnected)
            }
            .store(in: &cancellables)
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
    
    func handleNetworkChange(isConnected: Bool) {
        if !isConnected {
            view?.networkError()
        }
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



