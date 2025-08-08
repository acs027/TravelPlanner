//
//  PlannerViewState.swift
//  TravelPlanner
//
//  Created by ali cihan on 30.07.2025.
//

import AppResources

enum PlannerViewState {
    case idle
    case loading
    case success([TravelLocation])
    case failure(Error)
}
