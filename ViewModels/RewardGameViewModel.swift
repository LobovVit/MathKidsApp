import Foundation
import Combine
import CoreGraphics

final class RewardGameViewModel: ObservableObject {
    @Published private(set) var items: [RewardGameItem] = []
    @Published private(set) var score: Int = 0
    @Published private(set) var isFinished: Bool = false
    @Published private(set) var bestScore: Int = 0

    private var spawnTimer: Timer?
    private var moveTimer: Timer?

    private let bestScoreKey = "mathkids.rewardgame.bestscore"

    init() {
        bestScore = UserDefaults.standard.integer(forKey: bestScoreKey)
    }

    func start(in width: CGFloat) {
        stopAllTimers()
        items.removeAll()
        score = 0
        isFinished = false

        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { [weak self] _ in
            self?.spawnItem(in: width)
        }

        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.moveItems()
        }

    }

    func tap(item: RewardGameItem) {
        score += item.points
        items.removeAll { $0.id == item.id }

        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
        }
    }

    func restart(in width: CGFloat) {
        start(in: width)
    }

    deinit {
        stopAllTimers()
    }

    private func spawnItem(in width: CGFloat) {
        guard !isFinished else { return }

        let types: [(String, Int)] = [
            ("⭐️", 1),
            ("🎈", 2),
            ("🍬", 3)
        ]

        guard let selected = types.randomElement() else { return }

        let safeWidth = max(width - 40, 60)
        let x = CGFloat.random(in: 30...safeWidth)

        let item = RewardGameItem(
            emoji: selected.0,
            x: x,
            y: -20,
            points: selected.1
        )

        items.append(item)
    }

    private func moveItems() {
        guard !isFinished else { return }

        for index in items.indices {
            items[index].y += 6
        }

        items.removeAll { $0.y > 900 }
    }

    private func finishGame() {
        isFinished = true
        stopAllTimers()
        items.removeAll()
    }

    private func stopAllTimers() {
        spawnTimer?.invalidate()
        moveTimer?.invalidate()
        spawnTimer = nil
        moveTimer = nil
    }
}
