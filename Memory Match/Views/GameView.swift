import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: MemoryGame
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            headerView
            
            cardsGridView
            
            footerView
            
            if gameViewModel.gameOver {
                gameOverView
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("Back", systemImage: "arrow.left")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    gameViewModel.resetGame()
                    gameViewModel.startGame()
                } label: {
                    Label("Restart", systemImage: "arrow.clockwise")
                }
            }
        }
        .onAppear {
            if !gameViewModel.gameStarted {
                gameViewModel.startGame()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Score: \(gameViewModel.score)")
                    .font(.headline)
                
                Text("Streak: \(gameViewModel.streak)")
                    .font(.subheadline)
            }
            
            Spacer()
            
            if gameViewModel.timeRemaining > 0 {
                Text(timeRemainingFormatted)
                    .font(.title)
                    .foregroundColor(gameViewModel.timeRemaining <= 10 ? .red : .primary)
            }
        }
        .padding(.bottom)
    }
    
    private var cardsGridView: some View {
        let gridItemLayout = Array(
            repeating: GridItem(.flexible(), spacing: 5),
            count: getDifficultyColumns()
        )
        
        return ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 5) {
                ForEach(gameViewModel.cards) { card in
                    CardView(card: card, themeColor: gameViewModel.theme.color)
                        .onTapGesture {
                            gameViewModel.choose(card)
                        }
                }
            }
            .padding()
        }
    }
    
    private var footerView: some View {
        HStack {
            Text("Theme: \(gameViewModel.theme.name)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(gameViewModel.settings.gameMode.rawValue)
                .font(.caption)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(gameViewModel.settings.gameMode == .timeAttack ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                )
        }
        .padding(.top)
    }
    
    private var gameOverView: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("Final Score: \(gameViewModel.score)")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Button("Play Again") {
                    gameViewModel.resetGame()
                    gameViewModel.startGame()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(gameViewModel.theme.color)
                )
                .foregroundColor(.white)
                
                Button("Return to Menu") {
                    dismiss()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .foregroundColor(.white)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.8))
            )
            .shadow(radius: 10)
        }
        .transition(.opacity)
    }
    
    private var timeRemainingFormatted: String {
        let minutes = gameViewModel.timeRemaining / 60
        let seconds = gameViewModel.timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // Helper function to get columns based on difficulty
    private func getDifficultyColumns() -> Int {
        return gameViewModel.settings.difficulty.gridSize.columns
    }
} 