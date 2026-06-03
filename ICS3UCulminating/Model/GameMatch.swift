//
//  GameMatch.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation
import Observation

@Observable
class GameMatch {
    
    // MARK: - Stored properties
    var players: [Player] = []
    var boardElements: [BoardElement] = []
    var currentPlayerIndex: Int = 0
    var diceRoll: Int = 0
    var winningPlayer: Player? = nil
    var gameLog: [String] = []
    
    // MARK: - Computed properties
    var currentPlayer: Player {
        return players[currentPlayerIndex]
    }
    
    // MARK: - Initializer
    init() {
        setupBoard()
    }
    
    // MARK: - Functions
    
    func setupBoard() {
        // Standard Snakes and Ladders (some examples)
        boardElements = [
            // Ladders
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
            
            // Snakes
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
    
    func startGame(playerName: String) {
        let human = Player(name: playerName, isAI: false)
        let ai = Player(name: "Computer", isAI: true)
        players = [human, ai]
        currentPlayerIndex = 0
        winningPlayer = nil
        gameLog = ["Game started! \(playerName) vs Computer"]
    }
    
    func rollDice() {
        guard winningPlayer == nil else { return }
        
        diceRoll = Int.random(in: 1...6)
        let player = currentPlayer
        addToLog("\(player.name) rolled a \(diceRoll)")
        
        movePlayer(player, by: diceRoll)
        
        if player.currentSquare == 100 {
            winningPlayer = player
            addToLog("\(player.name) wins!")
        } else {
            // If roll was 6, player gets another turn (based on variations)
            if diceRoll != 6 {
                nextTurn()
            } else {
                addToLog("\(player.name) rolled a 6 and gets another turn!")
            }
        }
    }
    
    private func movePlayer(_ player: Player, by steps: Int) {
        let newSquare = player.currentSquare + steps
        
        // Exact roll variation
        if newSquare > 100 {
            addToLog("\(player.name) needs an exact roll to reach 100.")
            return
        }
        
        player.currentSquare = newSquare
        
        // Check for snakes or ladders
        for element in boardElements {
            if element.startSquare == player.currentSquare {
                player.currentSquare = element.endSquare
                addToLog("\(player.name) landed on a \(element.type == .ladder ? "ladder" : "snake")! Moved to \(player.currentSquare)")
                break
            }
        }
    }
    
    private func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    private func addToLog(_ message: String) {
        gameLog.append(message)
        // Keep log at a reasonable size
        if gameLog.count > 10 {
            gameLog.removeFirst()
        }
    }
}
