//
//  SoundManager.swift
//  DialedIn
//
//  Created by Hunter Tratar on 9/1/25.
//

import AVKit

class SoundManager {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(sound: SoundOptions) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
            print("⚠️ Sound file not found: \(sound.rawValue).mp3")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}

enum SoundOptions: String, CaseIterable {
    case nextPhase
    case animationFinish
}
