import SwiftUI

struct HomeView: View {
    @State private var gameSettings = GameSettings()
    @State private var showSettings = false
    @State private var showGame = false
    @State private var showLeaderboard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Memory Match")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    cardPreviewView
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        NavigationLink(destination: GameView(gameViewModel: MemoryGame(settings: gameSettings)), isActive: $showGame) {
                            EmptyView()
                        }
                        .hidden()
                        
                        Button {
                            showGame = true
                        } label: {
                            Text("Play")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(gameSettings.selectedTheme.color)
                                )
                                .shadow(radius: 5)
                        }
                        
                        Button {
                            showSettings = true
                        } label: {
                            Text("Settings")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.6))
                                )
                                .shadow(radius: 5)
                        }
                        .sheet(isPresented: $showSettings) {
                            SettingsView(settings: $gameSettings)
                        }
                        
                        Button {
                            showLeaderboard = true
                        } label: {
                            Text("Leaderboard")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.orange.opacity(0.6))
                                )
                                .shadow(radius: 5)
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Current Theme: \(gameSettings.selectedTheme.name)")
                            .foregroundColor(.white)
                        
                        Text("Difficulty: \(gameSettings.difficulty.rawValue)")
                            .foregroundColor(.white)
                        
                        Text("Mode: \(gameSettings.gameMode.rawValue)")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.2))
                    )
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var cardPreviewView: some View {
        HStack(spacing: 20) {
            ForEach(0..<3) { index in
                let isFlipped = index == 1 // middle card is flipped
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isFlipped ? Color.white : gameSettings.selectedTheme.color)
                        .frame(width: 70, height: 100)
                        .shadow(radius: 5)
                    
                    if isFlipped {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(gameSettings.selectedTheme.color, lineWidth: 3)
                            .frame(width: 70, height: 100)
                        
                        // Sample emoji from the current theme
                        if let emoji = gameSettings.selectedTheme.emojis.first {
                            Text(emoji)
                                .font(.system(size: 40))
                        }
                    }
                }
                .rotation3DEffect(
                    Angle.degrees(isFlipped ? 0 : 180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            }
        }
    }
} 

#Preview {
    HomeView()
}
