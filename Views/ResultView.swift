import SwiftUI

struct ResultView: View {
    let result: SessionResult

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var router: AppRouter

    @State private var showRewardPicker = false
    @State private var showStarsGame = false
    @State private var showRaceGame = false

    private let rewardService = RewardService()

    private var canPlayRewardGame: Bool {
        result.accuracy >= 0.8
    }

    var body: some View {
        let reward = rewardService.reward(for: result)

        ZStack {
            if settingsStore.settings.animationsEnabled && reward.stars == 3 {
                ConfettiView()
            }

            VStack(spacing: 20) {
                Spacer()

                Text(reward.title)
                    .font(.largeTitle.bold())

                RewardBadgeView(stars: reward.stars)

                Text(reward.message)
                    .font(.title3)
                    .multilineTextAlignment(.center)

                Text("\(result.correctAnswers) из \(result.totalQuestions)")
                    .font(.system(size: 42, weight: .bold, design: .rounded))

                Text("Точность: \(Int(result.accuracy * 100))%")
                    .font(.title2)

                Text("Лучшая серия: \(result.bestStreak) 🔥")
                    .font(.headline)

                List(result.answers.indices, id: \.self) { index in
                    let answer = result.answers[index]

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(answer.task.questionText)
                                .font(.headline)
                            Text("Твой ответ: \(answer.userAnswer.map(String.init) ?? "—")")
                                .font(.subheadline)
                            Text("Правильный ответ: \(answer.task.correctAnswer)")
                                .font(.subheadline)
                        }

                        Spacer()

                        Text(answer.isCorrect ? "✅" : "❌")
                            .font(.title2)
                    }
                }

                HStack(spacing: 12) {
                    if canPlayRewardGame {
                        Button("Бонусная игра") {
#if os(macOS)
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                router.goToRewardGamePicker()
                            }
#else
                            showRewardPicker = true
#endif
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Button("Готово") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showRewardPicker) {
            RewardGameChoiceSheet(
                openStars: {
                    showRewardPicker = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        showStarsGame = true
                    }
                },
                openRace: {
                    showRewardPicker = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        showRaceGame = true
                    }
                }
            )
        }
        .sheet(isPresented: $showStarsGame) {
            RewardGameView()
        }
        .sheet(isPresented: $showRaceGame) {
            RaceGameView()
        }
    }
}

private struct RewardGameChoiceSheet: View {
    let openStars: () -> Void
    let openRace: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                KidBackgroundView()

                VStack(spacing: 16) {
                    Text("🎮")
                        .font(.system(size: 54))

                    Text("Выбери бонусную игру")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Button(action: openStars) {
                        choiceCard(
                            emoji: "⭐️",
                            title: "Поймай звёзды",
                            subtitle: "Тапай по падающим звёздам, шарикам и конфетам"
                        )
                    }
                    .buttonStyle(.plain)

                    Button(action: openRace) {
                        choiceCard(
                            emoji: "🏎",
                            title: "Гонки",
                            subtitle: "Лови бонусы машинкой и объезжай бомбы"
                        )
                    }
                    .buttonStyle(.plain)

                    Button("Закрыть") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 4)
                }
                .padding()
            }
        }
    }

    private func choiceCard(emoji: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Text(emoji)
                .font(.system(size: 34))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.9))
        )
    }
}
