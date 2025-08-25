//
//  ReachabilityManager.swift
//  TravelPlannerNetwork
//
//  Created by ali cihan on 25.08.2025.
//

// MARK: ReachabilityManager
import Network
import Combine
import Foundation

@MainActor
public final class ReachabilityManager {

    public static let shared = ReachabilityManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")

    /// Published network status
    @Published public private(set) var isConnected: Bool = false

    private init() {}

    /// Start monitoring
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    /// Stop monitoring
    public func stopMonitoring() {
        monitor.cancel()
    }
}

