import Foundation
import Combine
import CoreGraphics

final class RaceGameViewModel: ObservableObject {
    @Published private(set) var items: [RaceItem] = []
    @Published private(set) var score: Int = 0
    @Published private(set) var timeLeft: Int = 20
    @Published private(set) var isFinished: Bool = false
    @Published private(set) var bestScore: Int = 0
    @Published var carX: CGFloat = 160

    private var spawnTimer: Timer?
    private var moveTimer: Timer?
    private var gameTimer: Timer?

    private let bestScoreKey = "mathkids.racegame.bestscore"
    private var sceneWidth: CGFloat = 320
    private var sceneHeight: CGFloat = 600

    init() {
        bestScore = UserDefaults.standard.integer(forKey: bestScoreKey)
    }

    func start(in width: CGFloat, height: CGFloat) {
        stopAllTimers()
        sceneWidth = width
        sceneHeight = height
        items.removeAll()
        score = 0
        timeLeft = 20
        isFinished = false
        carX = width / 2

        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { [weak self] _ in
            self?.spawnItem()
        }

        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] _ in
            self?.moveItemsAndCheckCollisions()
        }

        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.timeLeft -= 1
            if self.timeLeft <= 0 {
                timer.invalidate()
                self.finishGame()
            }
        }
    }

    func moveCar(to x: CGFloat) {
        let minX: CGFloat = 34
        let maxX: CGFloat = max(minX, sceneWidth - 34)
        carX = min(max(x, minX), maxX)
    }

    func restart(in width: CGFloat, height: CGFloat) {
        start(in: width, height: height)
    }

    deinit {
        stopAllTimers()
    }

    private func spawnItem() {
        guard !isFinished else { return }

        let types: [(String, Int, Bool)] = [
            ("⭐️", 1, false),
            ("💰", 2, false),
            ("🎈", 3, false),
            ("💣", -2, true)
        ]

        guard let selected = types.randomElement() else { return }

        let x = CGFloat.random(in: 34...max(34, sceneWidth - 34))

        let item = RaceItem(
            emoji: selected.0,
            x: x,
            y: -20,
            points: selected.1,
            isHazard: selected.2
        )

        items.append(item)
    }

    private func moveItemsAndCheckCollisions() {
        guard !isFinished else { return }

        let carY = sceneHeight - 110
        let hitBoxX: CGFloat = 36
        let hitBoxY: CGFloat = 42

        for index in items.indices {
            items[index].y += 7
        }

        for item in items {
            let dx = abs(item.x - carX)
            let dy = abs(item.y - carY)

            if dx < hitBoxX && dy < hitBoxY {
                score += item.points
                if score < 0 { score = 0 }

                if score > bestScore {
                    bestScore = score
                    UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
                }

                items.removeAll { $0.id == item.id }
            }
        }

        items.removeAll { $0.y > sceneHeight + 40 }
    }

    private func finishGame() {
        isFinished = true
        stopAllTimers()
        items.removeAll()
    }

    private func stopAllTimers() {
        spawnTimer?.invalidate()
        moveTimer?.invalidate()
        gameTimer?.invalidate()
        spawnTimer = nil
        moveTimer = nil
        gameTimer = nil
    }
}
