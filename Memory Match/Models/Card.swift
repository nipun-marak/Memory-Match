import Foundation
import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let content: String
    var isMatched: Bool = false
    var isFaceUp: Bool = false
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
} 