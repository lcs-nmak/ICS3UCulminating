//
//  BoardElement.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation

enum BoardElementType {
    case snake
    case ladder
}

struct BoardElement: Identifiable {
    
    // MARK: - Stored properties
    let id = UUID()
    let type: BoardElementType
    let startSquare: Int
    let endSquare: Int
    
    // MARK: - Computed properties
    var description: String {
        if type == .snake {
            return "Snake from \(startSquare) down to \(endSquare)"
        } else {
            return "Ladder from \(startSquare) up to \(endSquare)"
        }
    }
}
