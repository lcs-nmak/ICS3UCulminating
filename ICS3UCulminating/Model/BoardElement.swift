//
//  BoardElement.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation

/// A BoardElement represents a special feature on the board: either a Snake or a Ladder.
/// This structure acts as a "Data Container".
struct BoardElement: Identifiable {
    
    // MARK: - Stored properties (INPUTS for construction)
    
    let id = UUID()
    
    // WHY ARE THESE USED? 
    // These properties define the configuration of a snake or ladder.
    // They are "Inputs" because they are provided when we create each element in GameMatch.
    
    let type: BoardElementType  // The "What": Snake or Ladder?
    let startSquare: Int        // The "Where": Which square triggers the effect?
    let endSquare: Int          // The "Destination": Where does the player end up?
    
    // MARK: - Computed properties
    
    // OUTPUT: This is a "Derived Output" used to explain the element's purpose to a user.
    var description: String {
        if type == .snake {
            return "Snake from \(startSquare) down to \(endSquare)"
        } else {
            return "Ladder from \(startSquare) up to \(endSquare)"
        }
    }
}
