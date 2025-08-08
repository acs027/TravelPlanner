//
//  PlannerInteractor.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import TravelPlannerNetwork
import AppResources


protocol PlannerInteractorProtocol {
    @MainActor func fetchTravelLocations(prompt: String)
    @MainActor func focusMapOnLocation(_ location: TravelLocation)
}


protocol PlannerInteractorOutputProtocol: AnyObject {
    @MainActor func locationsFetched(_ locations: [TravelLocation])
    @MainActor func fetchingFailed(error: Error)
    @MainActor func focusMapOn(_ location: TravelLocation)
}

@MainActor
class PlannerInteractor: PlannerInteractorProtocol {
    
    weak var output: PlannerInteractorOutputProtocol?
    
    private var locations: [TravelLocation] = []

    #if DEBUG
    func fetchTravelLocations(prompt: String)  {
        locations = TravelLocationService().fetchLocalTravelLocations(prompt: prompt)
        output?.locationsFetched(locations)
    }
    #else
    func fetchTravelLocations(prompt: String) {
        Task {
            let fetchedLocations = await TravelLocationService().fetchTravelLocations(prompt: prompt)
            await MainActor.run { [weak self] in
                self?.locations = fetchedLocations
                self?.output?.locationsFetched(fetchedLocations)
            }
        }
    }
    #endif
   
    
    func focusMapOnLocation(_ location: TravelLocation) {
        output?.focusMapOn(location)
    }
    
}
