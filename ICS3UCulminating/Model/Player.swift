//
//  Player.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation
import Observation

@Observable
class Player: Identifiable {
    
    // MARK: - Stored properties
    let id = UUID()
    let name: String
    let isAI: Bool
    var currentSquare: Int = 1
    
    // MARK: - Initializer
    init(name: String, isAI: Bool = false) {
        self.name = name
        self.isAI = isAI
    }
}
