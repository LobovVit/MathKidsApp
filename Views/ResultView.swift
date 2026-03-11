import SwiftUI

struct ResultView: View {
    let result: SessionResult
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var router: AppRouter
    private let rewardService = RewardService()
    @State private var showConfetti = true

    var body: some View {
        let reward = rewardService.reward(for: result)

        NavigationView {
            ZStack {
                HStack {
                    Button("← Назад") {
                        router.goHome()
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                }
                .padding(.horizontal)
                KidBackgroundView()
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
                                Text(answer.task.questionText).font(.headline)
                                Text("Твой ответ: \(answer.userAnswer.map(String.init) ?? "—")")
                                    .font(.subheadline)
                                Text("Правильный ответ: \(answer.task.correctAnswer)")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(answer.isCorrect ? "✅" : "❌")
                                .font(.title2)
                        }
                        .padding(.vertical, 4)
                    }
                    Button("Готово") {
                        presentationMode.wrappedValue.dismiss()
                    }
                        .buttonStyle(DefaultButtonStyle())
                        .controlSize(.large)
                    Spacer()
                }
                .padding()
                if showConfetti { ConfettiView() }
            }
            .navigationTitle("Результат")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showConfetti = false
                }
            }
        }
    }
}
