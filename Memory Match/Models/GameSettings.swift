import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy = "Easy (4x4)"
    case medium = "Medium (6x6)"
    case hard = "Hard (8x8)"
    
    var id: String { self.rawValue }
    
    var gridSize: (columns: Int, rows: Int) {
        switch self {
        case .easy: return (4, 4)
        case .medium: return (6, 6)
        case .hard: return (8, 8)
        }
    }
    
    var pairCount: Int {
        let (columns, rows) = gridSize
        return (columns * rows) / 2
    }
}

enum GameMode: String, CaseIterable, Identifiable {
    case classic = "Classic"
    case timeAttack = "Time Attack"
    
    var id: String { self.rawValue }
}

struct GameSettings {
    var selectedTheme: Theme = Theme.themes[0]
    var difficulty: Difficulty = .easy
    var gameMode: GameMode = .classic
    var soundEnabled: Bool = true
    
    // Update timeAttackDuration calculation
    var timeAttackDuration: Int {
        switch difficulty {
        case .easy: return 90    // 1.5 minutes
        case .medium: return 150 // 2.5 minutes
        case .hard: return 210   // 3.5 minutes
        }
    }

    // Add standard game duration
    var standardGameDuration: Int {
        switch difficulty {
        case .easy: return 120   // 2 minutes
        case .medium: return 180 // 3 minutes
        case .hard: return 240   // 4 minutes
        }
    }
} 