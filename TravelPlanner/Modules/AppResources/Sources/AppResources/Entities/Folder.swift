//
//  Folder.swift
//  AppResources
//
//  Created by ali cihan on 27.08.2025.
//

import Foundation

public struct Folder: Sendable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
