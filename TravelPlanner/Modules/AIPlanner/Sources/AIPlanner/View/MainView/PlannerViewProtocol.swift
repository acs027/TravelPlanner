//
//  PlannerViewProtocol.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import AppResources

protocol PlannerViewProtocol: AnyObject {
    @MainActor func showLocations(_ locations: [TravelLocation])
    @MainActor func showError(_ message: String)
    @MainActor func updateState(_ state: PlannerViewState)
    @MainActor func focusMapOn(_ location: TravelLocation)
}
