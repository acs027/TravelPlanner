//
//  PlannerViewState.swift
//  AIPlanner
//
//  Created by ali cihan on 25.08.2025.
//

import AppResources

enum PlannerViewState {
    case idle
    case loading
    case success([TravelLocation])
    case failure(Error)
}
