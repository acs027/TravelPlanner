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
    func showLocationDetail(location: TravelLocation)
    func presentError(view: PlannerViewProtocol?, title: String, message: String)
    func updateState(_ state: PlannerViewState)
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
        updateState(.loading)
        interactor.fetchTravelLocations(prompt: prompt)
    }
    
    func didSelectLocation(_ location: TravelLocation) {
        view?.focusMapOn(location)
        showLocationDetail(location: location)
    }
    
    func handleNetworkChange(isConnected: Bool) {
        if !isConnected {
            presentError(view: view, title: "Network Error", message: "Check your internet connection and please try again.")
        }
    }
    
    func showLocationDetail(location: TravelLocation) {
        guard let view = view else { return }
        router.presentLocationDetail(from: view, location: location, delegate: self)
    }
    
    func presentError(view: PlannerViewProtocol?, title: String, message: String) {
        guard let view = view else { return }
        router.presentError(view: view, title: title, message: message)
    }
    
    func updateState(_ state: PlannerViewState) {
        switch state {
        case .idle:
            view?.setGenerateButtonEnabled(isEnabled: true)
        case .loading:
            view?.setGenerateButtonEnabled(isEnabled: false)
        case .success(let locations):
            view?.setGenerateButtonEnabled(isEnabled: true)
            view?.showLocations(locations)
            view?.showLocationOverlay(with: locations)
            view?.collapseTextFieldAnimated()
        case .failure(let error):
            view?.setGenerateButtonEnabled(isEnabled: true)
            presentError(view: view, title: "Error", message: error.localizedDescription)
        }
        
    }
}

extension PlannerPresenter: PlannerInteractorOutputProtocol {
    func locationsFetched(_ locations: [TravelLocation]) {
        updateState(.success(locations))
    }
    
    func fetchingFailed(error: Error) {
        updateState(.failure(error))
    }
}

extension PlannerPresenter: LocationDetailViewDelegate {
    func showFolders(for location: TravelLocation) {
        guard let view = view else { return }
        router.presentFolders(view: view, location: location)
    }
}




