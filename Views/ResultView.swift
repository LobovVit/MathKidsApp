import SwiftUI

struct ResultView: View {
    let result: SessionResult
    let awardedPlaySeconds: Int

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var profileStore: ProfileStore
    @EnvironmentObject private var router: AppRouter

    private let rewardService = RewardService()

    @State private var showConfetti = true

    private var canPlayBonusGame: Bool {
        profileStore.profile.playTimeSeconds > 0
    }

    var body: some View {
        let reward = rewardService.reward(for: result)

        ZStack {
            KidBackgroundView()

            if settingsStore.settings.animationsEnabled && showConfetti {
                ConfettiView()
            }

            VStack(spacing: 18) {
                HStack {
                    Button("← Назад") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                }
                .padding(.horizontal)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        VStack(spacing: 14) {
                            Text(reward.title)
                                .font(.largeTitle.bold())

                            RewardBadgeView(stars: reward.stars)

                            Text(reward.message)
                                .font(.title3)
                                .multilineTextAlignment(.center)

                            HStack(spacing: 16) {
                                statPill("\(result.correctAnswers) из \(result.totalQuestions)")
                                statPill("Точность: \(Int(result.accuracy * 100))%")
                                statPill("Серия: \(result.bestStreak) 🔥")
                            }

                            if awardedPlaySeconds > 0 {
                                HStack(spacing: 16) {
                                    statPill("Игровое время: +\(awardedPlaySeconds) сек")
                                    statPill("Баланс: \(profileStore.profile.formattedPlayTime)")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.92))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )

                        VStack(spacing: 10) {
                            ForEach(result.answers.indices, id: \.self) { index in
                                let answer = result.answers[index]

                                HStack(alignment: .top, spacing: 12) {
                                    Text(answer.isCorrect ? "✅" : "❌")
                                        .font(.title2)

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(answer.task.questionText)
                                            .font(.headline)
                                        Text("Твой ответ: \(answer.userAnswer.map(String.init) ?? "—")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("Правильный ответ: \(answer.task.correctAnswer)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.88))
                                )
                            }
                        }

                        HStack(spacing: 12) {
                            if canPlayBonusGame {
                                Button("Бонусная игра") {
                                    dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        router.goToRewardGamePicker()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }

                            Button("Готово") {
                                dismiss()
                            }
                            .buttonStyle(.bordered)
                        }
                        .controlSize(.large)
                    }
                    .frame(maxWidth: 760)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                showConfetti = false
            }
        }
    }

    private func statPill(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.white.opacity(0.88)))
    }
}
