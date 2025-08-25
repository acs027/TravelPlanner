//
//  AppCheckProviderFactory.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//

import Foundation
import FirebaseAppCheck
import FirebaseCore

public final class AircraftIdentifierAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  public func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    #if targetEnvironment(simulator)
      return AppCheckDebugProvider(app: app)
    #else
      return AppAttestProvider(app: app)
  #endif
  }
}
