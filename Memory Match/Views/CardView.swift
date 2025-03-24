import SwiftUI

struct CardView: View {
    let card: MemoryGame.Card
    let themeColor: Color
    
    var body: some View {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                
                Group {
                    base.fill(.white)
                    base.strokeBorder(themeColor, lineWidth: 2)
                    Text(card.content)
                        .font(.system(size: 40))
                }
                .opacity(card.isFaceUp ? 1 : 0)
                
                base.fill(themeColor)
                    .opacity(card.isFaceUp ? 0 : 1)
            }
            .aspectRatio(2/3, contentMode: .fit)
            .rotation3DEffect(
                .degrees(card.isFaceUp ? 0 : 180),
                axis: (x: 0, y: 1, z: 0))
            .animation(.easeInOut(duration: 0.3), value: card.isFaceUp)
        }
}

extension MemoryGame {
    struct Card: Identifiable {
        let id: UUID
        var isFaceUp = false
        var isMatched = false
        let content: String
        
        init(content: String) {
            self.id = UUID()
            self.content = content
        }
    }
}
