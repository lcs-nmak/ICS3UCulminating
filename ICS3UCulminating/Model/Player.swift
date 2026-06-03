//
//  Player.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation
import Observation

// We use @Observable so SwiftUI views automatically update when player properties change
@Observable
class Player: Identifiable {
    
    // MARK: - Stored properties
    
    // Unique identifier for the player
    let id = UUID()
    
    // The player's display name
    let name: String
    
    // True if this player is controlled by the computer
    let isAI: Bool
    
    // The current square position on the board (1 to 100)
    var currentSquare: Int = 1
    
    // MARK: - Initializer
    
    // Creates a new player with a name and AI status
    init(name: String, isAI: Bool = false) {
        self.name = name
        self.isAI = isAI
    }
}
