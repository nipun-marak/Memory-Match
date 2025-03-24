import SwiftUI

struct SettingsView: View {
    @Binding var settings: GameSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Theme")) {
                    ForEach(Theme.themes) { theme in
                        Button {
                            settings.selectedTheme = theme
                        } label: {
                            HStack {
                                Text(theme.name)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if settings.selectedTheme.id == theme.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(theme.color)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Difficulty")) {
                    ForEach(Difficulty.allCases) { difficulty in
                        Button {
                            settings.difficulty = difficulty
                        } label: {
                            HStack {
                                Text(difficulty.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if settings.difficulty == difficulty {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Game Mode")) {
                    ForEach(GameMode.allCases) { mode in
                        Button {
                            settings.gameMode = mode
                        } label: {
                            HStack {
                                Text(mode.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if settings.gameMode == mode {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Toggle("Sound Effects", isOn: $settings.soundEnabled)
                }
            }
            .navigationTitle("Game Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 