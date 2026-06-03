//
//  BoardElement.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation

// Defines whether the element is a snake (goes down) or a ladder (goes up)
enum BoardElementType {
    case snake
    case ladder
}

struct BoardElement: Identifiable {
    
    // MARK: - Stored properties
    
    // Unique identifier for SwiftUI lists and loops
    let id = UUID()
    
    // Whether this is a snake or a ladder
    let type: BoardElementType
    
    // The square number where the player lands to trigger the effect
    let startSquare: Int
    
    // The square number where the player is moved to
    let endSquare: Int
    
    // MARK: - Computed properties
    
    // A human-readable description of what this element does
    var description: String {
        if type == .snake {
            return "Snake from \(startSquare) down to \(endSquare)"
        } else {
            return "Ladder from \(startSquare) up to \(endSquare)"
        }
    }
}
