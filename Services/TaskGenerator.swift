import Foundation

struct TaskGenerator {
    func generateTasks(operation: MathOperation, level: DifficultyLevel, allowNegativeSubtraction: Bool, divisionOnlyIntegers: Bool, answerMode: AnswerMode) -> [TaskItem] {
        (0..<level.questionsCount).map { _ in
            let task = generateBaseTask(operation: operation, maxNumber: level.maxNumber, allowNegativeSubtraction: allowNegativeSubtraction, divisionOnlyIntegers: divisionOnlyIntegers)
            if answerMode == .multipleChoice {
                return TaskItem(left: task.left, right: task.right, operation: task.operation, correctAnswer: task.correctAnswer, options: generateOptions(correctAnswer: task.correctAnswer))
            } else { return task }
        }
    }

    private func generateBaseTask(operation: MathOperation, maxNumber: Int, allowNegativeSubtraction: Bool, divisionOnlyIntegers: Bool) -> TaskItem {
        switch operation {
        case .addition:
            let a = Int.random(in: 0...maxNumber), b = Int.random(in: 0...maxNumber)
            return TaskItem(left: a, right: b, operation: operation, correctAnswer: a + b)
        case .subtraction:
            var a = Int.random(in: 0...maxNumber), b = Int.random(in: 0...maxNumber)
            if !allowNegativeSubtraction && b > a { swap(&a, &b) }
            return TaskItem(left: a, right: b, operation: operation, correctAnswer: a - b)
        case .multiplication:
            let r = max(2, min(maxNumber, 12))
            let a = Int.random(in: 0...r), b = Int.random(in: 0...r)
            return TaskItem(left: a, right: b, operation: operation, correctAnswer: a * b)
        case .division:
            let divisor = Int.random(in: 1...max(1, min(maxNumber, 12)))
            if divisionOnlyIntegers {
                let result = Int.random(in: 0...maxNumber)
                return TaskItem(left: divisor * result, right: divisor, operation: operation, correctAnswer: result)
            } else {
                let dividend = Int.random(in: 0...maxNumber)
                return TaskItem(left: dividend, right: divisor, operation: operation, correctAnswer: dividend / divisor)
            }
        }
    }

    private func generateOptions(correctAnswer: Int) -> [Int] {
        var values = Set<Int>(); values.insert(correctAnswer)
        while values.count < 4 {
            let delta = Int.random(in: -8...8)
            values.insert(max(0, correctAnswer + (delta == 0 ? 2 : delta)))
        }
        return values.shuffled()
    }
}
