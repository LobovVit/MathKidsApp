import SwiftUI

struct RewardGamePickerView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var profileStore: ProfileStore

    private var hasPlayTime: Bool {
        profileStore.profile.playTimeSeconds > 0
    }

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 20) {
                HeaderBackView(title: "Выбор игры")

                Spacer()

                Text("🎮")
                    .font(.system(size: 64))

                Text("Выбери бонусную игру")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text("Доступно времени: \(profileStore.profile.formattedPlayTime)")
                    .font(.headline)
                    .foregroundColor(hasPlayTime ? .primary : .secondary)

                VStack(spacing: 14) {
                    gameButton(
                        emoji: "⭐️",
                        title: "Поймай звёзды",
                        subtitle: "Тапай по падающим звёздам, шарикам и конфетам"
                    ) {
                        router.goToRewardGame()
                    }
                    .disabled(!hasPlayTime)

                    gameButton(
                        emoji: "🏎",
                        title: "Гонки",
                        subtitle: "Лови бонусы машинкой и объезжай бомбы"
                    ) {
                        router.goToRaceGame()
                    }
                    .disabled(!hasPlayTime)

                    gameButton(
                        emoji: "🎾",
                        title: "Теннис",
                        subtitle: "Отбивай мяч и собирай бонусы"
                    ) {
                        router.goToTennisGame()
                    }
                    .disabled(!hasPlayTime)

                    gameButton(
                        emoji: "🧱",
                        title: "BlockGarden",
                        subtitle: "Строй мир из блоков и сохраняй свои постройки"
                    ) {
                        router.goToBlockGarden()
                    }
                    .disabled(!hasPlayTime)
                }
                .frame(maxWidth: 560)

                Spacer()

                HStack(spacing: 12) {
                    Button("На главный экран") {
                        router.goHome()
                    }
                    .buttonStyle(.bordered)

                    Button("Поймай звёзды") {
                        router.goToRewardGame()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!hasPlayTime)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func gameButton(
        emoji: String,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.88))
            )
        }
        .buttonStyle(.plain)
        .opacity(hasPlayTime ? 1 : 0.55)
    }
}
