//
//  PlannerInteractor.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import TravelPlannerNetwork
import AppResources

@MainActor
protocol PlannerInteractorProtocol {
    func fetchTravelLocations(prompt: String)
    func focusMapOnLocation(_ location: TravelLocation)
}

@MainActor
protocol PlannerInteractorOutputProtocol: AnyObject {
    func locationsFetched(_ locations: [TravelLocation])
    func fetchingFailed(error: Error)
    func focusMapOn(_ location: TravelLocation)
}

final class PlannerInteractor {
    weak var output: PlannerInteractorOutputProtocol?
    private var service = TravelLocationService()
}

extension PlannerInteractor: PlannerInteractorProtocol {
#if DEBUG
    func fetchTravelLocations(prompt: String) {
        let fetchedLocations = service.fetchLocalTravelLocations(prompt: prompt)
        output?.locationsFetched(fetchedLocations)
    }
#else
    func fetchTravelLocations(prompt: String) {
        Task { [weak self] in
            do {
                let fetchedLocations = await TravelLocationService().fetchTravelLocations(prompt: prompt)
                
                await MainActor.run { [weak output = self?.output] in
                    output?.locationsFetched(fetchedLocations)
                }
                
                // Update locations on background thread
                self?.locations = fetchedLocations
            } catch {
                await MainActor.run { [weak output = self?.output] in
                    output?.fetchingFailed(error: error)
                }
            }
        }
    }
#endif
    
    func focusMapOnLocation(_ location: TravelLocation) {
        
        output?.focusMapOn(location)
        
    }
}

