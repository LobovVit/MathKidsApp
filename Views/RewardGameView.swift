import SwiftUI

struct RewardGameView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var profileStore: ProfileStore
    @StateObject private var viewModel = RewardGameViewModel()
    @StateObject private var playTimeSession = PlayTimeSession()
    @State private var started = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                KidBackgroundView()

                VStack(spacing: 16) {
                    BonusGameHeaderBar(
                        title: "Поймай звёзды",
                        scoreTitle: "⭐️",
                        scoreValue: "\(viewModel.score)",
                        timeValue: playTimeSession.formattedTime,
                        backAction: { router.goToRewardGamePicker() }
                    )

                    Spacer()

                    ZStack {
                        ForEach(viewModel.items) { item in
                            Button {
                                viewModel.tap(item: item)
                            } label: {
                                Text(item.emoji)
                                    .font(.system(size: 38))
                            }
                            .buttonStyle(.plain)
                            .position(x: item.x, y: item.y)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Spacer()
                }
                .padding()

                if viewModel.isFinished {
                    BonusGameResultCard(
                        title: "Супер! 🎉",
                        scoreText: "Ты собрал: \(viewModel.score)",
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
                viewModel.start(in: geo.size.width)
                playTimeSession.start(profileStore: profileStore) {
                    router.goHome()
                }
            }
            .onDisappear {
                playTimeSession.stop()
            }
        }
    }
}
