//
//  GameMatch.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation
import Observation

// GameMatch acts as the ViewModel, managing the game state and logic
@Observable
class GameMatch {
    
    // MARK: - Stored properties
    
    // List of players in the game (Human and AI)
    var players: [Player] = []
    
    // List of snakes and ladders on the board
    var boardElements: [BoardElement] = []
    
    // Index of the player whose turn it currently is
    var currentPlayerIndex: Int = 0
    
    // The result of the most recent dice roll (1-6)
    var diceRoll: Int = 0
    
    // Set when a player reaches square 100
    var winningPlayer: Player? = nil
    
    // A history of recent game events to display to the user
    var gameLog: [String] = []
    
    // MARK: - Computed properties
    
    // Convenience property to get the player who is currently moving
    var currentPlayer: Player {
        return players[currentPlayerIndex]
    }
    
    // MARK: - Initializer
    
    // Automatically sets up the board when the game is created
    init() {
        setupBoard()
    }
    
    // MARK: - Functions
    
    // Defines the positions of all snakes and ladders on the 100-square board
    func setupBoard() {
        boardElements = [
            // Ladders: Move players UP the board
            BoardElement(type: .ladder, startSquare: 2, endSquare: 38),
            BoardElement(type: .ladder, startSquare: 7, endSquare: 14),
            BoardElement(type: .ladder, startSquare: 8, endSquare: 31),
            BoardElement(type: .ladder, startSquare: 15, endSquare: 26),
            BoardElement(type: .ladder, startSquare: 21, endSquare: 42),
            BoardElement(type: .ladder, startSquare: 28, endSquare: 84),
            BoardElement(type: .ladder, startSquare: 36, endSquare: 44),
            BoardElement(type: .ladder, startSquare: 51, endSquare: 67),
            BoardElement(type: .ladder, startSquare: 71, endSquare: 91),
            BoardElement(type: .ladder, startSquare: 78, endSquare: 98),
            BoardElement(type: .ladder, startSquare: 87, endSquare: 94),
            
            // Snakes: Move players DOWN the board
            BoardElement(type: .snake, startSquare: 16, endSquare: 6),
            BoardElement(type: .snake, startSquare: 46, endSquare: 25),
            BoardElement(type: .snake, startSquare: 49, endSquare: 11),
            BoardElement(type: .snake, startSquare: 62, endSquare: 19),
            BoardElement(type: .snake, startSquare: 64, endSquare: 60),
            BoardElement(type: .snake, startSquare: 74, endSquare: 53),
            BoardElement(type: .snake, startSquare: 89, endSquare: 68),
            BoardElement(type: .snake, startSquare: 92, endSquare: 88),
            BoardElement(type: .snake, startSquare: 95, endSquare: 75),
            BoardElement(type: .snake, startSquare: 99, endSquare: 80)
        ]
    }
    
    // Starts a new game with one human player and one AI opponent
    func startGame(playerName: String) {
        let human = Player(name: playerName, isAI: false)
        let ai = Player(name: "Computer", isAI: true)
        players = [human, ai]
        currentPlayerIndex = 0
        winningPlayer = nil
        gameLog = ["Game started! \(playerName) vs Computer"]
    }
    
    // Main game action: Rolls a die and moves the current player
    func rollDice() {
        // Prevent action if game is already over
        guard winningPlayer == nil else { return }
        
        // Generate a random number between 1 and 6
        diceRoll = Int.random(in: 1...6)
        let player = currentPlayer
        addToLog("\(player.name) rolled a \(diceRoll)")
        
        // Move the player based on the roll
        movePlayer(player, by: diceRoll)
        
        // Check for victory
        if player.currentSquare == 100 {
            winningPlayer = player
            addToLog("\(player.name) wins!")
        } else {
            // Rule variation: Rolling a 6 grants an extra turn
            if diceRoll != 6 {
                nextTurn()
            } else {
                addToLog("\(player.name) rolled a 6 and gets another turn!")
            }
        }
    }
    
    // Internal logic to update a player's position and handle board effects
    private func movePlayer(_ player: Player, by steps: Int) {
        let newSquare = player.currentSquare + steps
        
        // Rule variation: Exact roll required to land on 100
        if newSquare > 100 {
            addToLog("\(player.name) needs an exact roll to reach 100.")
            return
        }
        
        // Apply basic movement
        player.currentSquare = newSquare
        
        // Check if landing on a snake or ladder
        for element in boardElements {
            if element.startSquare == player.currentSquare {
                // Apply the move to the end of the element
                player.currentSquare = element.endSquare
                let typeName = element.type == .ladder ? "ladder" : "snake"
                addToLog("\(player.name) landed on a \(typeName)! Moved to \(player.currentSquare)")
                break // Only land on one element per move
            }
        }
    }
    
    // Switches turn to the next player in the list
    private func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    // Adds a message to the game log and keeps it trimmed to recent events
    private func addToLog(_ message: String) {
        gameLog.append(message)
        // Keep only the 10 most recent messages
        if gameLog.count > 10 {
            gameLog.removeFirst()
        }
    }
}
