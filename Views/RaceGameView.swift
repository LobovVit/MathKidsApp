import SwiftUI

struct RaceGameView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var profileStore: ProfileStore
    @StateObject private var viewModel = RaceGameViewModel()
    @StateObject private var playTimeSession = PlayTimeSession()
    @State private var started = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.18),
                        Color.cyan.opacity(0.10),
                        Color.purple.opacity(0.12)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 14) {
                    BonusGameHeaderBar(
                        title: "Гонки",
                        scoreTitle: "🏁",
                        scoreValue: "\(viewModel.score)",
                        timeValue: playTimeSession.formattedTime,
                        backAction: { router.goToRewardGamePicker() }
                    )

                    ZStack {
                        roadBackground(size: geo.size)

                        ForEach(viewModel.items) { item in
                            Text(item.emoji)
                                .font(.system(size: 34))
                                .position(x: item.x, y: item.y)
                                .shadow(radius: 2)
                        }

                        Text("🚗")
                            .font(.system(size: 42))
                            .rotationEffect(.degrees(viewModel.carTilt))
                            .position(x: viewModel.carX, y: viewModel.carY)
                            .shadow(radius: 4)
                    }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                viewModel.moveCar(to: value.location.x)
                            }
                    )
                }
                .padding()

                if viewModel.isFinished {
                    BonusGameResultCard(
                        title: "Финиш! 🏁",
                        scoreText: "Ты набрал: \(viewModel.score)",
                        bestScoreText: "Лучший результат: \(viewModel.bestScore)",
                        primaryTitle: "К играм",
                        primaryAction: { router.goToRewardGamePicker() },
                        secondaryTitle: "На главную",
                        secondaryAction: { router.goHome() }
                    )
                }
            }
            .onAppear {
                guard !started else { return }
                started = true
                viewModel.start(in: geo.size.width, height: geo.size.height)
                playTimeSession.start(profileStore: profileStore) {
                    router.goHome()
                }
            }
            .onDisappear {
                playTimeSession.stop()
            }
        }
    }

    private func roadBackground(size: CGSize) -> some View {
        ZStack {
            HStack {
                Color.green.opacity(0.28)
                Color.green.opacity(0.28)
            }

            ForEach(Array(0..<10), id: \.self) { index in
                let segmentHeight: CGFloat = 120
                let yBase = CGFloat(index) * segmentHeight - 40
                let midY = yBase + (segmentHeight / 2)
                let centerX = viewModel.roadCenter(at: midY)

                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.black.opacity(0.80))
                    .frame(width: min(size.width * 0.58, 290), height: segmentHeight + 8)
                    .position(x: centerX, y: yBase + 70)
            }

            ForEach(Array(0..<18), id: \.self) { index in
                let y = CGFloat(index) * 70 - viewModel.laneScroll
                let centerX = viewModel.roadCenter(at: y)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 8, height: 34)
                    .position(x: centerX + viewModel.laneOffset(at: y), y: y)
            }

            ForEach(Array(0..<14), id: \.self) { index in
                let y = CGFloat(index) * 55
                let centerX = viewModel.roadCenter(at: y)
                let roadHalfWidth = min(size.width * 0.58, 290) / 2

                Circle()
                    .fill(Color.yellow.opacity(0.25))
                    .frame(width: 8, height: 8)
                    .position(x: centerX - roadHalfWidth - 10, y: y)

                Circle()
                    .fill(Color.yellow.opacity(0.25))
                    .frame(width: 8, height: 8)
                    .position(x: centerX + roadHalfWidth + 10, y: y)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}
