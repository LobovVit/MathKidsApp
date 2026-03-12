import SwiftUI

struct TrainingView: View {
    @StateObject var viewModel: TrainingViewModel
    @EnvironmentObject var statsStore: StatsStore
    @EnvironmentObject var settingsStore: SettingsStore
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var showResult = false
    @State private var sessionResult: SessionResult?
    private var isPhoneLike: Bool { horizontalSizeClass == .compact }

    var body: some View {
        ZStack {
            KidBackgroundView()
            VStack(spacing: isPhoneLike ? 16 : 24) {
                HeaderBackView(title: viewModel.operation.title)
                if let task = viewModel.currentTask, !viewModel.finished {
                    ProgressHeaderView(progressText: viewModel.progressText, progressValue: viewModel.progressValue, streak: viewModel.currentStreak)
                    LevelBadgeView(level: viewModel.childProfile.selectedLevel)
                    Spacer(minLength: 8)
                    if let last = viewModel.lastAnswerWasCorrect {
                        Text(last ? "Правильно! 🎉" : "Попробуем дальше 💪")
                            .font(isPhoneLike ? .headline.bold() : .title2.bold())
                            .foregroundColor(last ? .green : .orange)
                    }
                    Text(task.questionText)
                        .font(.system(size: isPhoneLike ? 52 : 70, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    if viewModel.answerMode == .input {
                        NumberPadAnswerView(answerText: $viewModel.answerText) {
                            viewModel.submitTextAnswer(soundEnabled: settingsStore.settings.soundEnabled)
                            finishIfNeeded()
                        }
                    } else {
                        ChoiceAnswerView(options: task.options, chooseAction: { value in
                            viewModel.submitChoiceAnswer(value, soundEnabled: settingsStore.settings.soundEnabled)
                            finishIfNeeded()
                        }, compact: isPhoneLike)
                    }
                    Spacer(minLength: 8)
                }
            }
            .padding(isPhoneLike ? 12 : 20)
        }
        .sheet(isPresented: $showResult) {
            if let sessionResult { ResultView(result: sessionResult) }
        }
    }

    private func finishIfNeeded() {
        if viewModel.finished {
            let result = viewModel.buildResult()
            sessionResult = result
            statsStore.add(result: result)
            if settingsStore.settings.soundEnabled { SoundService.shared.playReward() }
            showResult = true
        }
    }
}
