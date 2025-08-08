//
//  GeminiServiceProtocol.swift
//  Network
//
//  Created by ali cihan on 7.08.2025.
//


public protocol GeminiServiceProtocol {
    func generateContent(location: String) async throws -> String
}