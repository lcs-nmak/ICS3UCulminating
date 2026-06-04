//
//  GameView.swift
//  ICS3UCulminating
//
//  Created by Gemini CLI on 2026-06-01.
//

import SwiftUI

struct GameView: View {
    
    // MARK: - Stored properties
    
    // The ViewModel that manages the game state and logic.
    // Because it is @Observable, this view will automatically refresh
    // whenever any of its properties (like player positions or the log) change.
    @State private var game = GameMatch()
    
    // State to hold the player's name during setup
    @State private var playerName: String = "Player 1"
    
    // Track if the game has started
    @State private var hasGameStarted: Bool = false
    
    // MARK: - Computed properties
    
    var body: some View {
        VStack(spacing: 20) {
            if !hasGameStarted {
                setupView
            } else {
                gameView
            }
        }
        .padding()
    }
    
    // View for entering player name and starting the game
    var setupView: some View {
        VStack(spacing: 20) {
            Text("Snakes and Ladders")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Enter your name", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
            
            Button("Start Game") {
                game.startGame(playerName: playerName)
                hasGameStarted = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    // The main game interface
    var gameView: some View {
        VStack(spacing: 20) {
            // Game Status Header
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
            
            // Simple Board Representation (10x10 Grid)
            // We use a LazyVGrid to display the 100 squares
            let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 10)
            
            LazyVGrid(columns: columns, spacing: 2) {
                // In Snakes and Ladders, square 1 is usually bottom-left.
                // For this basic view, we'll just list them 1-100.
                ForEach(1...100, id: \.self) { squareNumber in
                    ZStack {
                        Rectangle()
                            .fill(squareColor(for: squareNumber))
                            .aspectRatio(1, contentMode: .fit)
                        
                        Text("\(squareNumber)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        
                        // Show players on this square
                        HStack(spacing: 2) {
                            ForEach(game.players) { player in
                                if player.currentSquare == squareNumber {
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
            
            // Dice and Controls
            VStack {
                if game.diceRoll > 0 {
                    Text("🎲 Rolled: \(game.diceRoll)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Button(action: {
                    game.rollDice()
                    
                    // If it becomes the AI's turn, we trigger a small delay
                    if game.currentPlayer.isAI && game.winningPlayer == nil {
                        runAITurn()
                    }
                }) {
                    Text(game.currentPlayer.isAI ? "Computer is thinking..." : "Roll Dice")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                // Disable button if game is over or if it's AI's turn
                .disabled(game.winningPlayer != nil || game.currentPlayer.isAI)
            }
            .padding()
            
            // Game Log
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
            
            Button("Reset Game") {
                hasGameStarted = false
            }
            .font(.caption)
            .padding(.top)
        }
    }
    
    // MARK: - Functions
    
    // Helper to color squares that have snakes or ladders
    private func squareColor(for square: Int) -> Color {
        for element in game.boardElements {
            if element.startSquare == square {
                return element.type == .ladder ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
            }
        }
        return Color.white
    }
    
    // Logic to handle AI turns with a visual delay
    private func runAITurn() {
        // We use DispatchQueue to pause so the human can see the result of their turn
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            game.rollDice()
            
            // If the AI rolls a 6, it gets another turn
            if game.currentPlayer.isAI && game.winningPlayer == nil {
                runAITurn()
            }
        }
    }
}

#Preview {
    GameView()
}
