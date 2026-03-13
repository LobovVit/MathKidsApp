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
                                .font(.system(size: isCompactWidth ? 52 : 70, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
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
                                },
                                compact: isCompactWidth
                            )
                        }
                    }
                }
                .frame(maxWidth: 820)
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

    private func buildDivisionSteps(dividend: Int, divisor: Int) -> [DivisionStep] {
        let digits = String(dividend).map { Int(String($0)) ?? 0 }
        var steps: [DivisionStep] = []

        var current = 0
        var started = false
        var quotientColumn = 0

        for i in digits.indices {
            current = current * 10 + digits[i]

            if !started && current < divisor {
                continue
            }

            started = true
            let digit = current / divisor
            let product = digit * divisor
            let remainder = current - product
            let nextDigit = i + 1 < digits.count ? digits[i + 1] : nil
            let partialText = String(current)

            let step = DivisionStep(
                partialDividend: current,
                quotientDigit: digit,
                product: product,
                remainder: remainder,
                bringDownDigit: nextDigit,
                quotientColumn: quotientColumn,
                workStartColumn: i - partialText.count + 1,
                workWidth: partialText.count
            )
            steps.append(step)

            quotientColumn += 1
            current = remainder
        }

        return steps
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
