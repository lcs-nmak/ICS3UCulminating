# Snakes and Ladders - Game Overview

This is a SwiftUI-based implementation of the classic board game **Snakes and Ladders**, featuring a single player vs. an AI opponent.

## Game Mechanics

- **Board:** 100 squares (1 to 100).
- **Players:** 1 Human, 1 AI (Computer).
- **Movement:** Roll a 6-sided die to move forward.
- **Ladders:** Landing on the base of a ladder moves you up to its top.
- **Snakes:** Landing on a snake's head slides you down to its tail.

### Rule Variations Included
1. **Extra Turn on 6:** Rolling a 6 allows the player to roll again immediately.
2. **Exact Roll to Win:** A player must land exactly on square 100 to win. If the roll is too high, the player does not move.

## Technical Architecture

The project follows a **MVVM** (Model-View-ViewModel) pattern using Apple's modern **Observation** framework:

- **Model (`Player`, `BoardElement`):** Pure data structures representing the state of entities.
- **ViewModel (`GameMatch`):** Contains the game logic, turn management, and board configuration. It is marked `@Observable` to drive UI updates automatically.
- **View:** (To be implemented) SwiftUI views that render the board and game controls.

---

## Example Game Session (Step-by-Step)

In this session, **Nathan** (Human) plays against the **Computer** (AI).

1. **Game Start:** 
   - Nathan and Computer both start at Square 1.
   - *Log:* "Game started! Nathan vs Computer"

2. **Turn 1 (Nathan):**
   - Nathan rolls a **1**. Moves to Square 2.
   - Square 2 is the base of a **ladder** to Square 38.
   - *Log:* "Nathan rolled a 1"
   - *Log:* "Nathan landed on a ladder! Moved to 38"
   - *Next Turn:* Computer.

3. **Turn 2 (Computer):**
   - Computer rolls a **3**. Moves to Square 4.
   - *Log:* "Computer rolled a 3"
   - *Next Turn:* Nathan.

4. **Turn 3 (Nathan):**
   - Nathan rolls a **6**. Moves from 38 to 44.
   - *Log:* "Nathan rolled a 6"
   - *Log:* "Nathan rolled a 6 and gets another turn!"
   - Nathan rolls again, gets a **2**. Moves from 44 to 46.
   - Square 46 is a **snake's head** down to Square 25.
   - *Log:* "Nathan rolled a 2"
   - *Log:* "Nathan landed on a snake! Moved to 25"
   - *Next Turn:* Computer.

5. **... Fast Forward to Near End ...**

6. **Turn 20 (Nathan):**
   - Nathan is on Square 97.
   - Nathan rolls a **5**. (97 + 5 = 102).
   - *Log:* "Nathan rolled a 5"
   - *Log:* "Nathan needs an exact roll to reach 100."
   - Nathan stays on Square 97.
   - *Next Turn:* Computer.

7. **Turn 21 (Computer):**
   - Computer is on Square 94.
   - Computer rolls a **6**. (94 + 6 = 100).
   - *Log:* "Computer rolled a 6"
   - *Log:* "Computer wins!"
   - **Game Over.**
