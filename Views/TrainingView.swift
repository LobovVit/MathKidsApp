import SwiftUI

struct TrainingView: View {
    @StateObject var viewModel: TrainingViewModel
    @EnvironmentObject private var statsStore: StatsStore
    @EnvironmentObject private var settingsStore: SettingsStore
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var showResult = false
    @State private var sessionResult: SessionResult?

    private var isCompactWidth: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        ZStack {
            KidBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HeaderBackView(title: viewModel.operation.title)

                    if let task = viewModel.currentTask, !viewModel.finished {
                        ProgressHeaderView(
                            progressText: viewModel.progressText,
                            progressValue: viewModel.progressValue,
                            streak: viewModel.currentStreak
                        )

                        LevelBadgeView(level: viewModel.childProfile.selectedLevel)

                        if let last = viewModel.lastAnswerWasCorrect {
                            Text(last ? "Правильно! 🎉" : "Попробуем дальше 💪")
                                .font(.title3.bold())
                                .foregroundColor(last ? .green : .orange)
                        }

                        if viewModel.usesInteractiveColumnarMultiplication {
                            ColumnarMultiplicationTaskView(
                                left: task.left,
                                right: task.right,
                                partialRows: $viewModel.multiplicationPartialRows,
                                partialCarryRows: $viewModel.multiplicationPartialCarryRows,
                                carryDigits: $viewModel.multiplicationCarryDigits,
                                resultDigits: $viewModel.multiplicationResultDigits,
                                selectedRow: $viewModel.selectedMultiplicationRow,
                                selectedColumn: $viewModel.selectedMultiplicationColumn
                            )
                        } else if viewModel.usesInteractiveColumnarInput {
                            ColumnarInteractiveTaskView(
                                left: task.left,
                                right: task.right,
                                operation: task.operation,
                                answerDigits: $viewModel.columnarAnswerDigits,
                                carryDigits: $viewModel.columnarCarryDigits,
                                selectedColumn: $viewModel.selectedColumnIndex
                            )
                        } else if task.presentationStyle == .columnar {
                            ColumnarTaskView(
                                left: task.left,
                                right: task.right,
                                operation: task.operation
                            )
                        } else {
                            Text(task.questionText)
                                .font(.system(size: isCompactWidth ? 52 : 70, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        if viewModel.answerMode == .input {
                            if viewModel.usesInteractiveColumnarInput || viewModel.usesInteractiveColumnarMultiplication {
                                Button("Проверить") {
                                    viewModel.submitTextAnswer(soundEnabled: settingsStore.settings.soundEnabled)
                                    finishIfNeeded()
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                            } else {
                                NumberPadAnswerView(
                                    answerText: $viewModel.answerText,
                                    submitAction: {
                                        viewModel.submitTextAnswer(soundEnabled: settingsStore.settings.soundEnabled)
                                        finishIfNeeded()
                                    }
                                )
                            }
                        } else {
                            ChoiceAnswerView(
                                options: task.options,
                                chooseAction: { value in
                                    viewModel.submitChoiceAnswer(value, soundEnabled: settingsStore.settings.soundEnabled)
                                    finishIfNeeded()
                                },
                                compact: isCompactWidth
                            )
                        }
                    }
                }
                .frame(maxWidth: 760)
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
        }
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
            statsStore.add(result: result)
            if settingsStore.settings.soundEnabled {
                SoundService.shared.playReward()
            }
            showResult = true
        }
    }
}
