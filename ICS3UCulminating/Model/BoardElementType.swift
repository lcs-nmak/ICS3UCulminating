//
//  BoardElementType.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation

/// This 'enum' (enumeration) defines the two possible types for board features.
/// Enums are great when you have a fixed set of options, as they prevent typos 
/// and make the code much easier to read.
enum BoardElementType {
    case snake    // Represents a slide down the board
    case ladder   // Represents a climb up the board
}
