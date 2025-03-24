import Foundation
import SwiftUI

class MemoryGame: ObservableObject {
    @Published var cards: [Card] = []
    @Published var score: Int = 0
    @Published var streak: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var gameOver: Bool = false
    @Published var gameStarted: Bool = false
    private var indexOfFaceUpCard: Int?
    
    @Published var settings: GameSettings
    private var timer: Timer?
    private var seenCards: Set<UUID> = []
    private var remainingPairs: Int = 0
    
    var theme: Theme {
        settings.selectedTheme
    }
    
    init(settings: GameSettings) {
        self.settings = settings
        resetGame()
        SoundManager.shared.setSoundEnabled(settings.soundEnabled)
    }
    
    func resetGame() {
        // Reset game state
        score = 0
        streak = 0
        seenCards = []
        gameOver = false
        gameStarted = false
        
        // Configure time based on game mode
        if settings.gameMode == .timeAttack {
            timeRemaining = settings.timeAttackDuration
        } else {
            timeRemaining = 0
        }
        
        // Create cards
        let pairCount = settings.difficulty.pairCount
        remainingPairs = pairCount
        
        let availableEmojis = settings.selectedTheme.emojis.shuffled()
        let selectedEmojis = Array(availableEmojis.prefix(pairCount))
        
        // Create pairs
        var newCards = [Card]()
        for emoji in selectedEmojis {
            newCards.append(Card(content: emoji))
            newCards.append(Card(content: emoji))
        }
        
        // Shuffle and assign
        cards = newCards.shuffled()

        // Set time based on game mode and difficulty
        timeRemaining = settings.gameMode == .timeAttack 
            ? settings.timeAttackDuration 
            : settings.standardGameDuration
        
        // Start timer for all game modes
        if gameStarted {
            startTimer()
        }
    }
    
    func startGame() {
        gameStarted = true
        
        if settings.gameMode == .timeAttack {
            startTimer()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                if self.timeRemaining <= 10 && self.settings.soundEnabled {
                    SoundManager.shared.playSound(.tick)
                }
                
                if self.timeRemaining == 0 && self.settings.gameMode == .timeAttack {
                    SoundManager.shared.playSound(.gameOver)
                    self.endGame()
                }
            }
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        gameOver = true
        
        if remainingPairs == 0 {
            SoundManager.shared.playSound(.win)
        } else {
            SoundManager.shared.playSound(.gameOver)
        }
    }
    
    func choose(_ card: Card) {
        guard !gameOver else { return }
        
        // Ensure game is started when first card is chosen
        if !gameStarted {
            startGame()
        }
        
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
                      !cards[chosenIndex].isFaceUp,
                      !cards[chosenIndex].isMatched else { return }
        
        var newCards = cards
                newCards[chosenIndex].isFaceUp = true
                cards = newCards
        
        // Can't choose already matched or face up cards
//        guard !cards[index].isMatched && !cards[index].isFaceUp else { return }
        
        // Play card flip sound
        if settings.soundEnabled {
            SoundManager.shared.playSound(.flip)
        }
        
        // Track if we've seen this card before
        if !seenCards.contains(card.id) {
            seenCards.insert(card.id)
        }
        
        // If we already have one card face up, check for match
        if let potentialMatchIndex = indexOfFaceUpCard {
                    // Second card selection
                    if newCards[chosenIndex].content == newCards[potentialMatchIndex].content {
                        // Match found
                        newCards[chosenIndex].isMatched = true
                        newCards[potentialMatchIndex].isMatched = true
                        streak += 1
                        score += 10 * streak  // Base 10 points per match multiplied by streak
                        remainingPairs -= 1

                        // Check for game completion
                        if remainingPairs == 0 {
                            endGame()
                        }
                    } else {
                        // No match - penalty for wrong pair
                        streak = 0
                        score = max(0, score - 5)

                        // No match - flip back after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                            var updatedCards = cards
                            updatedCards[chosenIndex].isFaceUp = false
                            updatedCards[potentialMatchIndex].isFaceUp = false
                            cards = updatedCards
                            streak = 0
                        }
                    }
                    indexOfFaceUpCard = nil
                } else {
                    // First card selection
                    indexOfFaceUpCard = chosenIndex
                    streak = 1
                    // score += 1
                }
            }
    
    func updateSettings(_ newSettings: GameSettings) {
        let settings = newSettings
        SoundManager.shared.setSoundEnabled(settings.soundEnabled)
        resetGame()
    }
} 
