import SwiftUI

struct RewardGamePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 20) {
#if os(macOS)
                HStack {
                    Button("← Назад") {
                        router.goHome()
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Text("Выбери игру")
                        .font(.headline)

                    Spacer()

                    Color.clear.frame(width: 80, height: 1)
                }
                .padding(.horizontal)
#endif

                Spacer()

                Text("🎮")
                    .font(.system(size: 64))

                Text("Выбери бонусную игру")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                VStack(spacing: 14) {
                    gameButton(
                        emoji: "⭐️",
                        title: "Поймай звёзды",
                        subtitle: "Тапай по падающим звёздам, шарикам и конфетам"
                    ) {
#if os(macOS)
                        router.goToRewardGame()
#else
                        dismiss()
#endif
                    }

                    gameButton(
                        emoji: "🏎",
                        title: "Гонки",
                        subtitle: "Лови бонусы машинкой и объезжай бомбы"
                    ) {
#if os(macOS)
                        router.goToRaceGame()
#else
                        dismiss()
#endif
                    }

                    gameButton(
                        emoji: "🎾",
                        title: "Теннис",
                        subtitle: "Отбивай мяч и собирай бонусы"
                    ) {
#if os(macOS)
                        router.goToTennisGame()
#else
                        dismiss()
#endif
                    }
                }
                .frame(maxWidth: 560)

                Spacer()

#if !os(macOS)
                HStack(spacing: 12) {
                    Button("Поймай звёзды") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Закрыть") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
#endif
            }
            .padding()
        }
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
    }
}
