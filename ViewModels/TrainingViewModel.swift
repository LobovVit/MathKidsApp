import Foundation
import Combine

final class TrainingViewModel: ObservableObject {
    @Published private(set) var tasks: [TaskItem] = []
    @Published private(set) var currentIndex: Int = 0
    @Published var answerText: String = ""
    @Published private(set) var finished: Bool = false
    @Published private(set) var answers: [SessionAnswer] = []
    @Published private(set) var currentStreak: Int = 0
    @Published private(set) var bestStreak: Int = 0
    @Published var lastAnswerWasCorrect: Bool?

    @Published var columnarAnswerDigits: [String] = []
    @Published var columnarCarryDigits: [String] = []
    @Published var selectedColumnIndex: Int? = nil

    @Published var multiplicationPartialRows: [[String]] = []
    @Published var multiplicationPartialCarryRows: [[String]] = []
    @Published var multiplicationCarryDigits: [String] = []
    @Published var multiplicationResultDigits: [String] = []
    @Published var selectedMultiplicationRow: Int? = nil
    @Published var selectedMultiplicationColumn: Int? = nil

    @Published var divisionMode: DivisionTrainingMode = .steps
    @Published var divisionQuotientDigits: [String] = []
    @Published var divisionProductRows: [[String]] = []
    @Published var divisionRemainderRows: [[String]] = []
    @Published var divisionBringDownRows: [[String]] = []
    @Published var selectedDivisionRow: Int? = nil
    @Published var selectedDivisionColumn: Int? = nil

    let operation: MathOperation
    let answerMode: AnswerMode
    let childProfile: ChildProfile

    private let generator = TaskGenerator()
    private let startedAt = Date()

    init(operation: MathOperation, settings: AppSettings, childProfile: ChildProfile) {
        self.operation = operation
        self.childProfile = childProfile
        self.answerMode = childProfile.selectedLevel == .columnar ? .input : settings.answerMode
        self.tasks = generator.generateTasks(
            operation: operation,
            level: childProfile.selectedLevel,
            allowNegativeSubtraction: settings.allowNegativeSubtraction,
            divisionOnlyIntegers: settings.divisionOnlyIntegers,
            answerMode: self.answerMode
        )
        setupColumnarStateIfNeeded()
    }

    var currentTask: TaskItem? {
        guard currentIndex < tasks.count else { return nil }
        return tasks[currentIndex]
    }

    var progressText: String {
        "\(min(currentIndex + 1, tasks.count)) / \(tasks.count)"
    }

    var progressValue: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(currentIndex) / Double(tasks.count)
    }

    var usesInteractiveColumnarInput: Bool {
        guard let task = currentTask else { return false }
        return childProfile.selectedLevel == .columnar &&
            task.presentationStyle == .columnar &&
            (task.operation == .addition || task.operation == .subtraction)
    }

    var usesInteractiveColumnarMultiplication: Bool {
        guard let task = currentTask else { return false }
        return childProfile.selectedLevel == .columnar &&
            task.presentationStyle == .columnar &&
            task.operation == .multiplication
    }

    var usesInteractiveColumnarDivision: Bool {
        guard let task = currentTask else { return false }
        return childProfile.selectedLevel == .columnar &&
            task.presentationStyle == .columnar &&
            task.operation == .division
    }

    func submitTextAnswer(soundEnabled: Bool) {
        guard let task = currentTask else { return }

        let userAnswer: Int?
        if usesInteractiveColumnarInput {
            userAnswer = buildColumnarAnswer()
        } else if usesInteractiveColumnarMultiplication {
            userAnswer = buildMultiplicationAnswer()
        } else if usesInteractiveColumnarDivision {
            userAnswer = buildDivisionAnswer()
        } else {
            userAnswer = Int(answerText.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        processAnswer(userAnswer, for: task, soundEnabled: soundEnabled)
        answerText = ""
    }

    func submitChoiceAnswer(_ value: Int, soundEnabled: Bool) {
        guard let task = currentTask else { return }
        processAnswer(value, for: task, soundEnabled: soundEnabled)
    }

    private func processAnswer(_ userAnswer: Int?, for task: TaskItem, soundEnabled: Bool) {
        let isCorrect = userAnswer == task.correctAnswer
        lastAnswerWasCorrect = isCorrect

        if isCorrect {
            currentStreak += 1
            bestStreak = max(bestStreak, currentStreak)
            if soundEnabled { SoundService.shared.playCorrect() }
        } else {
            currentStreak = 0
            if soundEnabled { SoundService.shared.playWrong() }
        }

        answers.append(SessionAnswer(task: task, userAnswer: userAnswer, isCorrect: isCorrect))

        if currentIndex + 1 < tasks.count {
            currentIndex += 1
            setupColumnarStateIfNeeded()
        } else {
            finished = true
        }
    }

    private func setupColumnarStateIfNeeded() {
        resetColumnarState()

        guard let task = currentTask,
              childProfile.selectedLevel == .columnar,
              task.presentationStyle == .columnar else {
            return
        }

        switch task.operation {
        case .addition, .subtraction:
            let digitsCount = max(String(task.left).count, String(task.right).count)
            let answerCount = task.operation == .addition
                ? max(digitsCount, String(task.correctAnswer).count)
                : digitsCount

            columnarAnswerDigits = Array(repeating: "", count: answerCount)
            columnarCarryDigits = Array(repeating: "", count: answerCount)
            selectedColumnIndex = answerCount - 1

        case .multiplication:
            let topDigits = String(task.left).count
            let bottomDigits = String(task.right).count
            let finalWidth = max(String(task.correctAnswer).count, topDigits + bottomDigits)

            multiplicationPartialRows = Array(repeating: Array(repeating: "", count: finalWidth), count: bottomDigits)
            multiplicationPartialCarryRows = Array(repeating: Array(repeating: "", count: finalWidth), count: bottomDigits)
            multiplicationCarryDigits = Array(repeating: "", count: finalWidth)
            multiplicationResultDigits = Array(repeating: "", count: finalWidth)
            selectedMultiplicationRow = 0
            selectedMultiplicationColumn = finalWidth - 1

        case .division:
            let dividendDigits = String(task.left).count
            let quotientDigits = String(task.correctAnswer).count
            let steps = max(1, quotientDigits)

            divisionQuotientDigits = Array(repeating: "", count: quotientDigits)
            divisionProductRows = Array(repeating: Array(repeating: "", count: dividendDigits), count: steps)
            divisionRemainderRows = Array(repeating: Array(repeating: "", count: dividendDigits), count: steps)
            divisionBringDownRows = Array(repeating: Array(repeating: "", count: dividendDigits), count: max(0, steps - 1))
            selectedDivisionRow = 0
            selectedDivisionColumn = quotientDigits - 1
        }
    }

    private func resetColumnarState() {
        columnarAnswerDigits = []
        columnarCarryDigits = []
        selectedColumnIndex = nil

        multiplicationPartialRows = []
        multiplicationPartialCarryRows = []
        multiplicationCarryDigits = []
        multiplicationResultDigits = []
        selectedMultiplicationRow = nil
        selectedMultiplicationColumn = nil

        divisionQuotientDigits = []
        divisionProductRows = []
        divisionRemainderRows = []
        divisionBringDownRows = []
        selectedDivisionRow = nil
        selectedDivisionColumn = nil
    }

    private func buildColumnarAnswer() -> Int? {
        let joined = columnarAnswerDigits.joined().trimmingCharacters(in: .whitespacesAndNewlines)
        return joined.isEmpty ? nil : Int(joined)
    }

    private func buildMultiplicationAnswer() -> Int? {
        guard let task = currentTask else { return nil }
        if String(task.right).count == 1 {
            let joined = multiplicationPartialRows.first?.joined().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return joined.isEmpty ? nil : Int(joined)
        }
        let joined = multiplicationResultDigits.joined().trimmingCharacters(in: .whitespacesAndNewlines)
        return joined.isEmpty ? nil : Int(joined)
    }

    private func buildDivisionAnswer() -> Int? {
        let joined = divisionQuotientDigits.joined().trimmingCharacters(in: .whitespacesAndNewlines)
        return joined.isEmpty ? nil : Int(joined)
    }

    func buildResult() -> SessionResult {
        let correct = answers.filter { $0.isCorrect }.count
        return SessionResult(
            childID: childProfile.id,
            childName: childProfile.name,
            operation: operation,
            difficulty: childProfile.selectedLevel,
            totalQuestions: tasks.count,
            correctAnswers: correct,
            answers: answers,
            bestStreak: bestStreak,
            duration: Date().timeIntervalSince(startedAt)
        )
    }
}
