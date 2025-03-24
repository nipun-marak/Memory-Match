import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [URL: AVAudioPlayer] = [:]
    private var isSoundEnabled = true
    
    private init() {
        // Private initializer for singleton
    }
    
    func setSoundEnabled(_ enabled: Bool) {
        isSoundEnabled = enabled
    }
    
    func playSound(_ sound: GameSound) {
        guard isSoundEnabled else { return }
        
        if let path = Bundle.main.path(forResource: sound.rawValue, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            
            if let audioPlayer = audioPlayers[url] {
                audioPlayer.currentTime = 0
                audioPlayer.play()
            } else {
                do {
                    let audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer.prepareToPlay()
                    audioPlayers[url] = audioPlayer
                    audioPlayer.play()
                } catch {
                    print("Error playing sound: \(error.localizedDescription)")
                }
            }
        }
    }
}

enum GameSound: String {
    case flip = "card_flip"
    case match = "card_match"
    case noMatch = "card_nomatch"
    case gameOver = "game_over"
    case win = "game_win"
    case tick = "timer_tick"
} 