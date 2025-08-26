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
    func createFolder(name: String)
    func fetchFolders() -> [Folder]
    func add(location: TravelLocation, to folder: Folder)
    func delete(folder: Folder)
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
        view?.showLocationDetail(location)
    }
    
    func handleNetworkChange(isConnected: Bool) {
        if !isConnected {
            view?.networkError()
        }
    }
    
    func createFolder(name: String) {
        interactor.createFolder(name: name)
    }
    
    func fetchFolders() -> [Folder] {
        interactor.fetchFolders()
    }
    
    func add(location: TravelLocation, to folder: Folder) {
        interactor.add(location: location, to: folder)
    }
    
    func delete(folder: Folder) {
        interactor.delete(folder: folder)
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



