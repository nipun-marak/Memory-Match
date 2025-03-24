import Foundation
import SwiftUI

struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let emojis: [String]
    let color: Color
    
    static let themes: [Theme] = [
        Theme(name: "Animals", 
              emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🦄", "🐴", "🦓", "🦒", "🦘"],
              color: .green),
        Theme(name: "Fruits", 
              emojis: ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🥑", "🥦", "🌽"],
              color: .red),
        Theme(name: "Sports", 
              emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓", "🏸", "🏒", "🏑", "🥍", "🏏", "🪃", "🥅", "⛳️"],
              color: .blue),
        Theme(name: "Vehicles", 
              emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🚚", "🚛", "🚜", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔", "🚍"],
              color: .orange),
        Theme(name: "Faces", 
              emojis: ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "🥲", "☺️", "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗"],
              color: .yellow)
    ]
} 