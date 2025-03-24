import Foundation
import SwiftUI

class MemoryGame: ObservableObject {
    @Published private(set) var cards: [Card] = []
    @Published private(set) var score: Int = 0
    @Published private(set) var streak: Int = 0
    @Published private(set) var timeRemaining: Int = 0
    @Published private(set) var gameOver: Bool = false
    @Published private(set) var gameStarted: Bool = false
    
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
        
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        // Can't choose already matched or face up cards
        guard !cards[index].isMatched && !cards[index].isFaceUp else { return }
        
        // Play card flip sound
        if settings.soundEnabled {
            SoundManager.shared.playSound(.flip)
        }
        
        // Track if we've seen this card before
        if !seenCards.contains(card.id) {
            seenCards.insert(card.id)
        }
        
        // If we already have one card face up, check for match
        if let potentialMatchIndex = cards.indices.filter({ cards[$0].isFaceUp && !cards[$0].isMatched }).first {
            // Check if this is a match
            if cards[potentialMatchIndex].content == cards[index].content {
                // It's a match!
                cards[potentialMatchIndex].isMatched = true
                cards[index].isMatched = true
                
                // Play match sound
                if settings.soundEnabled {
                    SoundManager.shared.playSound(.match)
                }
                
                // Update score and streak
                streak += 1
                score += max(5, 5 * streak) // Higher score for streaks
                
                // Check if all pairs are matched
                remainingPairs -= 1
                if remainingPairs == 0 {
                    endGame()
                }
            } else {
                // Not a match
                streak = 0
                
                // Play non-match sound
                if settings.soundEnabled {
                    SoundManager.shared.playSound(.noMatch)
                }
                
                // Penalty if we've seen both cards before
                if seenCards.contains(cards[potentialMatchIndex].id) && seenCards.contains(card.id) {
                    score = max(0, score - 2)
                }
            }
            
            // Turn the card face up immediately
            var updatedCard = cards[index]
            updatedCard.isFaceUp = true
            cards[index] = updatedCard
            
            // Delay turning cards face down if not a match
            if !cards[index].isMatched {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                    guard let self = self else { return }
                    
                    // Turn both cards face down
                    var updatedCards = self.cards
                    for i in updatedCards.indices {
                        if !updatedCards[i].isMatched {
                            updatedCards[i].isFaceUp = false
                        }
                    }
                    self.cards = updatedCards
                }
            }
        } else {
            // First card of potential pair - turn face up
            var updatedCard = cards[index]
            updatedCard.isFaceUp = true
            cards[index] = updatedCard
        }
    }
    
    func updateSettings(_ newSettings: GameSettings) {
        let settings = newSettings
        SoundManager.shared.setSoundEnabled(settings.soundEnabled)
        resetGame()
    }
} 
