import SwiftUI

struct TrainingView: View {
    @StateObject var viewModel: TrainingViewModel
    @EnvironmentObject private var statsStore: StatsStore
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var profileStore: ProfileStore
    @EnvironmentObject private var router: AppRouter

    @State private var showResult = false
    @State private var sessionResult: SessionResult?
    @State private var awardedPlaySeconds: Int = 0

    var body: some View {
        ZStack {
            KidBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
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

                        Group {
                            if viewModel.usesInteractiveColumnarDivision {
                                ColumnarDivisionTaskView(
                                    dividend: task.left,
                                    divisor: task.right,
                                    mode: $viewModel.divisionMode,
                                    quotientDigits: $viewModel.divisionQuotientDigits,
                                    productRows: $viewModel.divisionProductRows,
                                    remainderRows: $viewModel.divisionRemainderRows,
                                    bringDownRows: $viewModel.divisionBringDownRows,
                                    selectedRow: $viewModel.selectedDivisionRow,
                                    selectedColumn: $viewModel.selectedDivisionColumn
                                )
                            } else if viewModel.usesInteractiveColumnarMultiplication {
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
                                    .font(.system(size: 76, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }

                        if viewModel.answerMode == .input {
                            if viewModel.usesInteractiveColumnarInput || viewModel.usesInteractiveColumnarMultiplication || viewModel.usesInteractiveColumnarDivision {
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
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: 860)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showResult) {
            if let sessionResult {
                ResultView(result: sessionResult, awardedPlaySeconds: awardedPlaySeconds)
            }
        }
    }

    private func finishIfNeeded() {
        if viewModel.finished {
            let result = viewModel.buildResult()
            let rewardSeconds = viewModel.rewardedPlaySeconds()
            sessionResult = result
            awardedPlaySeconds = rewardSeconds
            statsStore.add(result: result)
            profileStore.addPlaySeconds(rewardSeconds, to: result.childID)
            if settingsStore.settings.soundEnabled {
                SoundService.shared.playReward()
            }
            showResult = true
        }
    }
}
