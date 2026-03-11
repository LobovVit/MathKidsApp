import Combine
import Foundation
import SwiftUI

final class TrainingViewModel: ObservableObject {
    @Published private(set) var tasks: [TaskItem] = []
    @Published private(set) var currentIndex: Int = 0
    @Published var answerText: String = ""
    @Published private(set) var finished: Bool = false
    @Published private(set) var answers: [SessionAnswer] = []
    @Published private(set) var currentStreak: Int = 0
    @Published private(set) var bestStreak: Int = 0
    @Published var lastAnswerWasCorrect: Bool?
    @Published var showConfetti: Bool = false

    let operation: MathOperation
    let answerMode: AnswerMode
    let childProfile: ChildProfile

    private let generator = TaskGenerator()
    private let settings: AppSettings
    private let startedAt = Date()

    init(operation: MathOperation, settings: AppSettings, childProfile: ChildProfile) {
        self.operation = operation
        self.answerMode = settings.answerMode
        self.childProfile = childProfile
        self.settings = settings
        self.tasks = generator.generateTasks(
            operation: operation,
            level: childProfile.selectedLevel,
            allowNegativeSubtraction: settings.allowNegativeSubtraction,
            divisionOnlyIntegers: settings.divisionOnlyIntegers,
            answerMode: settings.answerMode
        )
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

    func submitTextAnswer(soundEnabled: Bool, animationsEnabled: Bool) {
        guard let task = currentTask else { return }
        let userAnswer = Int(answerText.trimmingCharacters(in: .whitespacesAndNewlines))
        processAnswer(userAnswer, for: task, soundEnabled: soundEnabled, animationsEnabled: animationsEnabled)
        answerText = ""
    }

    func submitChoiceAnswer(_ value: Int, soundEnabled: Bool, animationsEnabled: Bool) {
        guard let task = currentTask else { return }
        processAnswer(value, for: task, soundEnabled: soundEnabled, animationsEnabled: animationsEnabled)
    }

    private func processAnswer(_ userAnswer: Int?, for task: TaskItem, soundEnabled: Bool, animationsEnabled: Bool) {
        let isCorrect = userAnswer == task.correctAnswer
        lastAnswerWasCorrect = isCorrect

        if isCorrect {
            currentStreak += 1
            bestStreak = max(bestStreak, currentStreak)
            if soundEnabled { SoundService.shared.playCorrect() }
            if animationsEnabled {
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.showConfetti = false
                }
            }
        } else {
            currentStreak = 0
            if soundEnabled { SoundService.shared.playWrong() }
        }

        answers.append(SessionAnswer(task: task, userAnswer: userAnswer, isCorrect: isCorrect))

        if currentIndex + 1 < tasks.count {
            currentIndex += 1
        } else {
            finished = true
        }
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
