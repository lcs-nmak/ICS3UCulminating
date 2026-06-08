//
//  Player.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation
import Observation

/// The Player class represents a single participant in the game.
/// We mark it with @Observable so that when a player's 'currentSquare' 
/// changes, the UI knows exactly which circle to move on the board.
@Observable
class Player: Identifiable {
    
    // MARK: - Stored properties
    
    // A unique identifier for the player. Identifiable is required for ForEach loops in SwiftUI.
    let id = UUID()
    
    // The name chosen by the user or "Computer".
    let name: String
    
    // A flag to distinguish between the user and the automated AI player.
    let isAI: Bool
    
    // Tracks where the player is currently sitting (from 1 to 100).
    var currentSquare: Int = 1
    
    // MARK: - Initializer
    
    /// Creates a new player.
    /// - Parameters:
    ///   - name: The display name.
    ///   - isAI: Set to true if this is the computer.
    init(name: String, isAI: Bool = false) {
        self.name = name
        self.isAI = isAI
    }
}
