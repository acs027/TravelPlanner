//
//  PlannerInteractor.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import TravelPlannerNetwork
import AppResources
import CoreDataManager

@MainActor
protocol PlannerInteractorProtocol {
    func fetchTravelLocations(prompt: String)
    func focusMapOnLocation(_ location: TravelLocation)
    func createFolder(name: String)
    func fetchFolders() -> [Folder]
    func add(location: TravelLocation, to folder: Folder)
    func delete(folder: Folder)
}

@MainActor
protocol PlannerInteractorOutputProtocol: AnyObject {
    func locationsFetched(_ locations: [TravelLocation])
    func fetchingFailed(error: Error)
    func focusMapOn(_ location: TravelLocation)
}

@MainActor
final class PlannerInteractor {
    weak var output: PlannerInteractorOutputProtocol?
    private var service = TravelLocationService()
    private let coreDataManager: CoreDataManager = CoreDataManager.shared
}

extension PlannerInteractor {
    private func isPromptValid(_ prompt: String) -> Bool {
        return !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension PlannerInteractor: PlannerInteractorProtocol {
    func add(location: TravelLocation, to folder: Folder) {
        if let folder = coreDataManager.fetchSpecificFolder(id: folder.id) {
            coreDataManager.addLocation(location, to: folder)
            print("added to the \(folder) \(location)")
        }
        
    }
    
    func delete(folder: Folder) {
        if let folder = coreDataManager.fetchSpecificFolder(id: folder.id) {
            coreDataManager.delete(folder: folder)
        }
    }
    
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
    
    func createFolder(name: String) {
        coreDataManager.createFolder(name: name)
    }
    
    func fetchFolders() -> [Folder] {
        let folders: [Folder] = coreDataManager.fetchFolders().compactMap {
            Folder(id: $0.id!.uuidString, name: $0.name!)
        }
        return folders
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

