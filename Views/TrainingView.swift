import SwiftUI

struct TrainingView: View {
    @StateObject var viewModel: TrainingViewModel
    @EnvironmentObject var statsStore: StatsStore
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var router: AppRouter

    @State private var showResult = false
    @State private var sessionResult: SessionResult?

    var body: some View {
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

            VStack(spacing: 24) {
                if let task = viewModel.currentTask, !viewModel.finished {
                    ProgressHeaderView(
                        progressText: viewModel.progressText,
                        progressValue: viewModel.progressValue,
                        streak: viewModel.currentStreak
                    )

                    LevelBadgeView(level: viewModel.childProfile.selectedLevel)

                    Spacer()

                    if let last = viewModel.lastAnswerWasCorrect {
                        Text(last ? "Правильно! 🎉" : "Попробуем дальше 💪")
                            .font(.title2.bold())
                            .foregroundColor(last ? .green : .orange)
                    }

                    Text(task.questionText)
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    if viewModel.answerMode == .input {
                        NumberPadAnswerView(answerText: $viewModel.answerText) {
                            viewModel.submitTextAnswer(
                                soundEnabled: settingsStore.settings.soundEnabled,
                                animationsEnabled: settingsStore.settings.animationsEnabled
                            )
                            finishIfNeeded()
                        }
                    } else {
                        ChoiceAnswerView(options: task.options) { value in
                            viewModel.submitChoiceAnswer(
                                value,
                                soundEnabled: settingsStore.settings.soundEnabled,
                                animationsEnabled: settingsStore.settings.animationsEnabled
                            )
                            finishIfNeeded()
                        }
                    }

                    Spacer()
                }
            }
            .padding()

            if viewModel.showConfetti {
                ConfettiView()
            }
        }
        .navigationTitle(viewModel.operation.title)
        .sheet(isPresented: $showResult) {
            if let sessionResult {
                ResultView(result: sessionResult)
            }
        }
    }

    private func finishIfNeeded() {
        if viewModel.finished {
            let result = viewModel.buildResult()
            sessionResult = result
            statsStore.add(result: result, syncEnabled: settingsStore.settings.iCloudSyncEnabled)
            if settingsStore.settings.soundEnabled { SoundService.shared.playReward() }
            showResult = true
        }
    }
}
