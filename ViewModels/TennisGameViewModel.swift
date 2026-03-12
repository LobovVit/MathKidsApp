import Foundation
import Combine
import CoreGraphics

final class TennisGameViewModel: ObservableObject {
    @Published var paddleX: CGFloat = 160
    @Published private(set) var ballX: CGFloat = 160
    @Published private(set) var ballY: CGFloat = 180
    @Published private(set) var score: Int = 0
    @Published private(set) var bestScore: Int = 0
    @Published private(set) var timeLeft: Int = 20
    @Published private(set) var isFinished: Bool = false
    @Published private(set) var bonuses: [TennisBonusItem] = []
    @Published private(set) var bounceFlash: Bool = false

    private var vx: CGFloat = 4.5
    private var vy: CGFloat = 5.5
    private var tickTimer: Timer?
    private var gameTimer: Timer?
    private var bonusTimer: Timer?

    private var sceneWidth: CGFloat = 320
    private var sceneHeight: CGFloat = 600
    private let bestScoreKey = "mathkids.tennisgame.bestscore"

    init() {
        bestScore = UserDefaults.standard.integer(forKey: bestScoreKey)
    }

    func start(in width: CGFloat, height: CGFloat) {
        stopAllTimers()
        sceneWidth = width
        sceneHeight = height
        paddleX = width / 2
        ballX = width / 2
        ballY = height * 0.38
        vx = Bool.random() ? 4.5 : -4.5
        vy = 5.5
        score = 0
        timeLeft = 20
        isFinished = false
        bonuses.removeAll()
        bounceFlash = false

        tickTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            self?.tick()
        }

        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.timeLeft -= 1
            if self.timeLeft <= 0 {
                timer.invalidate()
                self.finishGame()
            }
        }

        bonusTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true) { [weak self] _ in
            self?.spawnBonus()
        }
    }

    func movePaddle(to x: CGFloat) {
        let minX: CGFloat = 48
        let maxX: CGFloat = max(minX, sceneWidth - 48)
        paddleX = min(max(x, minX), maxX)
    }

    func restart(in width: CGFloat, height: CGFloat) {
        start(in: width, height: height)
    }

    deinit {
        stopAllTimers()
    }

    private func tick() {
        guard !isFinished else { return }

        ballX += vx
        ballY += vy

        if ballX <= 18 || ballX >= sceneWidth - 18 {
            vx *= -1
        }

        if ballY <= 18 {
            vy = abs(vy)
        }

        let paddleY = sceneHeight - 110
        let paddleHalfWidth: CGFloat = 46
        let paddleHeight: CGFloat = 16

        let hitsPaddleHorizontally = ballX >= (paddleX - paddleHalfWidth) && ballX <= (paddleX + paddleHalfWidth)
        let hitsPaddleVertically = ballY >= (paddleY - paddleHeight) && ballY <= (paddleY + paddleHeight)

        if vy > 0 && hitsPaddleHorizontally && hitsPaddleVertically {
            vy = -abs(vy) - 0.15
            let offset = (ballX - paddleX) / paddleHalfWidth
            vx += offset * 1.2
            vx = max(min(vx, 8), -8)
            bounceFlash = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) { [weak self] in
                self?.bounceFlash = false
            }
        }

        if ballY > sceneHeight + 20 {
            // мягкий рестарт мяча, без проигрыша
            ballX = sceneWidth / 2
            ballY = sceneHeight * 0.35
            vx = Bool.random() ? 4.5 : -4.5
            vy = -5.0
        }

        for index in bonuses.indices {
            bonuses[index].y += 3.2
        }

        for bonus in bonuses {
            let dx = abs(bonus.x - ballX)
            let dy = abs(bonus.y - ballY)
            if dx < 28 && dy < 28 {
                score += bonus.points
                if score > bestScore {
                    bestScore = score
                    UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
                }
                bonuses.removeAll { $0.id == bonus.id }
            }
        }

        bonuses.removeAll { $0.y > sceneHeight + 40 }
    }

    private func spawnBonus() {
        guard !isFinished else { return }
        let types: [(String, Int)] = [("⭐️", 1), ("🍬", 2), ("🎈", 3)]
        guard let selected = types.randomElement() else { return }
        let item = TennisBonusItem(
            emoji: selected.0,
            x: CGFloat.random(in: 32...(sceneWidth - 32)),
            y: 40,
            points: selected.1
        )
        bonuses.append(item)
    }

    private func finishGame() {
        isFinished = true
        stopAllTimers()
        bonuses.removeAll()
    }

    private func stopAllTimers() {
        tickTimer?.invalidate()
        gameTimer?.invalidate()
        bonusTimer?.invalidate()
        tickTimer = nil
        gameTimer = nil
        bonusTimer = nil
    }
}
