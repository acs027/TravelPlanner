//
//  PlannerViewProtocol.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import AppResources

@MainActor
protocol PlannerViewProtocol: AnyObject {
    func showLocations(_ locations: [TravelLocation])
    func showError(_ message: String)
    func updateState(_ state: PlannerViewState)
    func focusMapOn(_ location: TravelLocation)
}
