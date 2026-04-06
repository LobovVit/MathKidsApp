import Foundation
import Combine
import CoreGraphics

final class RaceGameViewModel: ObservableObject {
    @Published private(set) var items: [RaceItem] = []
    @Published private(set) var score: Int = 0
    @Published private(set) var isFinished: Bool = false
    @Published private(set) var bestScore: Int = 0

    @Published var carX: CGFloat = 160
    @Published var roadPhase: CGFloat = 0
    @Published var laneScroll: CGFloat = 0
    @Published var carTilt: Double = 0
    @Published private(set) var carY: CGFloat = 0

    private var spawnTimer: Timer?
    private var moveTimer: Timer?

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
        isFinished = false
        carX = width / 2
        carY = max(height - 170, height * 0.68)
        roadPhase = 0
        laneScroll = 0
        carTilt = 0

        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { [weak self] _ in
            self?.spawnItem()
        }

        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] _ in
            self?.tick()
        }

    }

    func moveCar(to x: CGFloat) {
        let minX: CGFloat = 48
        let maxX: CGFloat = max(minX, sceneWidth - 48)
        let newX = min(max(x, minX), maxX)
        carTilt = Double((newX - carX) / 10.0)
        carX = newX
    }

    func restart(in width: CGFloat, height: CGFloat) {
        start(in: width, height: height)
    }

    func roadCenter(at y: CGFloat) -> CGFloat {
        let center = sceneWidth / 2
        let wave1 = sin((y / 160.0) + roadPhase) * 34
        let wave2 = sin((y / 90.0) + roadPhase * 0.7) * 12
        return center + wave1 + wave2
    }

    func laneOffset(at y: CGFloat) -> CGFloat {
        sin((y / 170.0) + roadPhase) * 6
    }

    deinit {
        stopAllTimers()
    }

    private func tick() {
        guard !isFinished else { return }

        roadPhase += 0.05
        laneScroll += 8
        if laneScroll > 80 { laneScroll = 0 }

        for index in items.indices {
            items[index].y += 7
        }

        let hitBoxX: CGFloat = 40
        let hitBoxY: CGFloat = 42

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

        carTilt *= 0.82
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

        let spawnY: CGFloat = -20
        let roadCenterX = roadCenter(at: 120)
        let laneShift = CGFloat.random(in: -70...70)
        let x = min(max(roadCenterX + laneShift, 34), sceneWidth - 34)

        let item = RaceItem(
            emoji: selected.0,
            x: x,
            y: spawnY,
            points: selected.1,
            isHazard: selected.2
        )

        items.append(item)
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
