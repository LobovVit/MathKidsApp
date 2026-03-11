import Combine
import Foundation
import AVFoundation

final class SoundService {
    static let shared = SoundService()

    private var correctPlayer: AVAudioPlayer?
    private var wrongPlayer: AVAudioPlayer?
    private var rewardPlayer: AVAudioPlayer?

    private init() {
        correctPlayer = makePlayer(named: "correct", ext: "mp3")
        wrongPlayer = makePlayer(named: "wrong", ext: "mp3")
        rewardPlayer = makePlayer(named: "reward", ext: "mp3")
    }

    private func makePlayer(named: String, ext: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: named, withExtension: ext) else { return nil }
        return try? AVAudioPlayer(contentsOf: url)
    }

    func playCorrect() {
        correctPlayer?.currentTime = 0
        correctPlayer?.play()
    }

    func playWrong() {
        wrongPlayer?.currentTime = 0
        wrongPlayer?.play()
    }

    func playReward() {
        rewardPlayer?.currentTime = 0
        rewardPlayer?.play()
    }
}

