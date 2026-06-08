//
//  GameMatch.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import Foundation
import Observation

/// The GameMatch class is our "ViewModel". 
/// It acts as the brain of the game, holding all the rules and the current state of play.
@Observable
class GameMatch {
    
    // MARK: - Stored properties (OUTPUTS for the UI)
    // These properties act as the "Outputs" of our game logic. 
    // The View reads these values to decide what to show the user.
    
    /// WHY USE AN ARRAY? We use an [Array] for players because we have a list of similar items.
    /// Arrays allow us to:
    /// 1. Keep the players in a specific order (Human first, then AI).
    /// 2. Use a loop to draw them all on the board.
    /// 3. Easily add more players in the future if we wanted a 4-player game.
    var players: [Player] = []
    
    /// WHY USE AN ARRAY? boardElements stores all 21 snakes and ladders.
    /// We use an array here so we can iterate (loop) through the list every time 
    /// a player moves to check: "Is the current square in this list?"
    var boardElements: [BoardElement] = []
    
    // An integer to keep track of whose turn it is.
    // OUTPUT: The UI uses this to display "Nathan's Turn" or "Computer's Turn".
    var currentPlayerIndex: Int = 0
    
    // OUTPUT: The UI reads this to show the dice image or number.
    var diceRoll: Int = 0
    
    // OUTPUT: The UI checks if this is not 'nil' to show the "Winner" message.
    var winningPlayer: Player? = nil
    
    /// WHY USE AN ARRAY? The game log is a list of events. 
    /// We use an array so we can keep adding new messages to the end and 
    /// remove the oldest ones from the front to keep the list a manageable size.
    var gameLog: [String] = []
    
    // MARK: - Computed properties
    
    // This is a "Calculated Output". It doesn't store data itself, but 
    // calculates which player is active based on the 'currentPlayerIndex'.
    var currentPlayer: Player {
        return players[currentPlayerIndex]
    }
    
    // MARK: - Initializer
    
    init() {
        setupBoard()
    }
    
    // MARK: - Functions
    
    /// Defines the specific locations of every snake and ladder.
    /// This function "outputs" a full list of board elements into our array.
    func setupBoard() {
        // We are populating our array with 21 different BoardElement objects.
        boardElements = [
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
    
    /// FUNCTION INPUT: 'playerName' is an input provided by the View.
    /// The function takes this string and uses it to customize the Player object.
    func startGame(playerName: String) {
        let human = Player(name: playerName, isAI: false)
        let ai = Player(name: "Computer", isAI: true)
        
        // INPUT -> STORAGE: We take our new players and store them in the array.
        players = [human, ai]
        currentPlayerIndex = 0
        winningPlayer = nil
        gameLog = ["Game started! \(playerName) vs Computer"]
    }
    
    /// Logic for rolling the dice.
    func rollDice() {
        guard winningPlayer == nil else { return }
        
        // INTERNAL INPUT: We generate a random number as an input for the move logic.
        diceRoll = Int.random(in: 1...6)
        
        let player = currentPlayer
        addToLog("\(player.name) rolled a \(diceRoll)")
        
        movePlayer(player, by: diceRoll)
        
        if player.currentSquare == 100 {
            winningPlayer = player
            addToLog("\(player.name) wins the game!")
        } else {
            if diceRoll != 6 {
                nextTurn()
            } else {
                addToLog("\(player.name) rolled a 6 and gets another turn!")
            }
        }
    }
    
    /// FUNCTION INPUTS: 
    /// 1. 'player' tells the function WHICH player to move.
    /// 2. 'steps' tells the function HOW FAR to move them.
    /// This allows one function to be used for both Human and AI moves.
    private func movePlayer(_ player: Player, by steps: Int) {
        let newSquare = player.currentSquare + steps
        
        if newSquare > 100 {
            addToLog("\(player.name) needs an exact roll to reach 100.")
            return
        }
        
        player.currentSquare = newSquare
        
        // ARRAY SEARCH: We loop through the boardElements array to see if the player 
        // landed on a special square.
        for element in boardElements {
            if element.startSquare == player.currentSquare {
                player.currentSquare = element.endSquare
                let typeName = element.type == .ladder ? "ladder" : "snake"
                addToLog("\(player.name) landed on a \(typeName)! Moved to \(player.currentSquare)")
                break 
            }
        }
    }
    
    private func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    /// FUNCTION INPUT: 'message' is the text we want to add to our log.
    private func addToLog(_ message: String) {
        // ARRAY MODIFICATION: We append the new message to the end of our list.
        gameLog.append(message)
        
        if gameLog.count > 10 {
            // ARRAY MODIFICATION: We remove the item at index 0 to keep the list short.
            gameLog.removeFirst()
        }
    }
}
