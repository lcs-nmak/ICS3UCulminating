//
//  GameView.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import SwiftUI

/// GameView is the "View" layer of our app.
/// It defines what the user sees on the screen and how they interact with the game.
struct GameView: View {
    
    // MARK: - Stored properties
    
    // The @State property wrapper tells SwiftUI to manage the memory for this object.
    // Because 'GameMatch' is @Observable, SwiftUI will watch for changes and 
    // automatically re-draw this view whenever the game state updates.
    @State private var game = GameMatch()
    
    // A temporary string to hold the text the user types into the name field.
    @State private var playerName: String = "Player 1"
    
    // A boolean to toggle between the "Setup" screen and the actual "Game" screen.
    @State private var hasGameStarted: Bool = false
    
    // MARK: - Computed properties
    
    // The 'body' property defines the hierarchy of views shown on screen.
    var body: some View {
        VStack(spacing: 20) {
            // We use an 'if' statement to decide which screen to show.
            if !hasGameStarted {
                // Show the name entry screen if the game hasn't started yet.
                setupView
            } else {
                // Show the board and controls once the game has started.
                gameView
            }
        }
        .padding() // Adds some breathing room around the edges.
    }
    
    /// A sub-view specifically for the initial setup phase.
    var setupView: some View {
        VStack(spacing: 20) {
            Text("Snakes and Ladders")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // 'TextField' allows the user to type. 
            // The '$playerName' syntax creates a "two-way binding", meaning:
            // 1. When the user types, 'playerName' is updated.
            // 2. If 'playerName' is changed in code, the text box updates too.
            TextField("Enter your name", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
            
            Button("Start Game") {
                // When clicked, we tell the ViewModel to initialize the players.
                game.startGame(playerName: playerName)
                // Then we switch the screen.
                hasGameStarted = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    /// The main game interface showing the board, dice, and log.
    var gameView: some View {
        VStack(spacing: 20) {
            
            // --- HEADER ---
            // Displays whose turn it is and if someone has won.
            HStack {
                Text(game.currentPlayer.name + "'s Turn")
                    .font(.headline)
                
                Spacer()
                
                if let winner = game.winningPlayer {
                    Text("Winner: \(winner.name)!")
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            
            // --- THE BOARD ---
            // We represent the 100 squares using a grid.
            // 'GridItem(.flexible())' means each column will expand to fill the available width.
            let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 10)
            
            LazyVGrid(columns: columns, spacing: 2) {
                // 'ForEach' creates 100 individual squares.
                ForEach(1...100, id: \.self) { squareNumber in
                    ZStack {
                        // The background color of the square.
                        Rectangle()
                            .fill(squareColor(for: squareNumber))
                            .aspectRatio(1, contentMode: .fit)
                        
                        // The number in the corner of the square.
                        Text("\(squareNumber)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        
                        // PLAYER INDICATORS:
                        // We check if any players are currently sitting on this square number.
                        HStack(spacing: 2) {
                            ForEach(game.players) { player in
                                if player.currentSquare == squareNumber {
                                    // Blue for the user, Red for the Computer.
                                    Circle()
                                        .fill(player.isAI ? Color.red : Color.blue)
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    }
                }
            }
            .border(Color.black, width: 1)
            
            // --- CONTROLS ---
            VStack {
                // Only show the dice emoji if someone has rolled.
                if game.diceRoll > 0 {
                    Text("🎲 Rolled: \(game.diceRoll)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Button(action: {
                    // Tell the ViewModel to roll the dice.
                    game.rollDice()
                    
                    // If it is now the AI's turn, we trigger the automatic logic.
                    if game.currentPlayer.isAI && game.winningPlayer == nil {
                        runAITurn()
                    }
                }) {
                    // The button text changes based on who is moving.
                    Text(game.currentPlayer.isAI ? "Computer is thinking..." : "Roll Dice")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                // We disable the button if the game is over or if it's the AI's turn.
                .disabled(game.winningPlayer != nil || game.currentPlayer.isAI)
            }
            .padding()
            
            // --- LOG ---
            // Shows a list of recent messages.
            VStack(alignment: .leading) {
                Text("Game Log")
                    .font(.caption)
                    .fontWeight(.bold)
                
                Divider()
                
                ForEach(game.gameLog, id: \.self) { message in
                    Text(message)
                        .font(.system(size: 12, design: .monospaced))
                        .padding(.vertical, 1)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Allows the user to go back to the name entry screen.
            Button("Reset Game") {
                hasGameStarted = false
            }
            .font(.caption)
            .padding(.top)
        }
    }
    
    // MARK: - Functions
    
    /// Determines the background color for a square.
    /// Green for ladders, Red for snakes, White for everything else.
    private func squareColor(for square: Int) -> Color {
        for element in game.boardElements {
            if element.startSquare == square {
                return element.type == .ladder ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
            }
        }
        return Color.white
    }
    
    /// Logic to handle AI turns automatically.
    private func runAITurn() {
        // We add a 1.5 second delay so the game doesn't feel instant.
        // This gives the human time to see what they rolled before the computer moves.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            game.rollDice()
            
            // In Snakes and Ladders, if the AI rolls a 6, it gets another turn.
            // We call this function again to handle that extra turn.
            if game.currentPlayer.isAI && game.winningPlayer == nil {
                runAITurn()
            }
        }
    }
}

// The Preview provider allows us to see our UI in the Xcode canvas as we build it.
#Preview {
    GameView()
}
