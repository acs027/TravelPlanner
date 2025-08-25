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

extension PlannerInteractor {
    private func isPromptValid(_ prompt: String) -> Bool {
        return !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension PlannerInteractor: PlannerInteractorProtocol {
#if DEBUG
    func fetchTravelLocations(prompt: String) {
        let fetchedLocations = service.fetchLocalTravelLocations(prompt: prompt)
        output?.locationsFetched(fetchedLocations)
    }
#else
    func fetchTravelLocations(prompt: String) {
        
        if !isPromptValid(prompt) {
            output?.fetchingFailed(error: PromptError.notValidPrompt)
            return
        }
        Task { [weak self] in
            do {
                let fetchedLocations = try await TravelLocationService().fetchTravelLocations(prompt: prompt)
                
                await MainActor.run { [weak output = self?.output] in
                    output?.locationsFetched(fetchedLocations)
                }
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


enum PromptError: Error, LocalizedError {
    case notValidPrompt
    
    var errorDescription: String? {
        switch self {
        case .notValidPrompt:
            return NSLocalizedString("Not valid prompt",
                                     comment: "Please check your prompt.")
        }
    }
}

