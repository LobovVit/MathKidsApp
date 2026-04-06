import SwiftUI

struct TennisGameView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var profileStore: ProfileStore
    @StateObject private var viewModel = TennisGameViewModel()
    @StateObject private var playTimeSession = PlayTimeSession()
    @State private var started = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.18),
                        Color.blue.opacity(0.10),
                        Color.yellow.opacity(0.08)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 14) {
                    BonusGameHeaderBar(
                        title: "Теннис",
                        scoreTitle: "🎾",
                        scoreValue: "\(viewModel.score)",
                        timeValue: playTimeSession.formattedTime,
                        backAction: { router.goToRewardGamePicker() }
                    )

                    ZStack {
                        tennisCourt(size: geo.size)

                        ForEach(viewModel.bonuses) { bonus in
                            Text(bonus.emoji)
                                .font(.system(size: 30))
                                .position(x: bonus.x, y: bonus.y)
                        }

                        Circle()
                            .fill(viewModel.bounceFlash ? Color.yellow : Color.white)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
                            )
                            .position(x: viewModel.ballX, y: viewModel.ballY)
                            .shadow(radius: 2)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.85))
                            .frame(width: 96, height: 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                            .position(x: viewModel.paddleX, y: viewModel.paddleY)
                    }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                viewModel.movePaddle(to: value.location.x)
                            }
                    )
                }
                .padding()

                if viewModel.isFinished {
                    BonusGameResultCard(
                        title: "Супер! 🎉",
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

    private func tennisCourt(size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.green.opacity(0.72))

            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.white.opacity(0.9), lineWidth: 4)

            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.85))
                    .frame(height: 4)
                Spacer()
            }

            HStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 4)
                Spacer()
            }

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.65))
                .frame(width: size.width * 0.78, height: 3)
                .position(x: size.width / 2, y: size.height - 132)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}
