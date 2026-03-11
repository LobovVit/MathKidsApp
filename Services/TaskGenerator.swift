import Foundation

struct TaskGenerator {
    func generateTasks(
        operation: MathOperation,
        level: DifficultyLevel,
        allowNegativeSubtraction: Bool,
        divisionOnlyIntegers: Bool,
        answerMode: AnswerMode
    ) -> [TaskItem] {
        (0..<level.questionsCount).map { _ in
            let baseTask = generateBaseTask(
                operation: operation,
                maxNumber: level.maxNumber,
                allowNegativeSubtraction: allowNegativeSubtraction,
                divisionOnlyIntegers: divisionOnlyIntegers
            )

            if answerMode == .multipleChoice {
                let options = generateOptions(correctAnswer: baseTask.correctAnswer)
                return TaskItem(
                    left: baseTask.left,
                    right: baseTask.right,
                    operation: baseTask.operation,
                    correctAnswer: baseTask.correctAnswer,
                    options: options
                )
            }

            return baseTask
        }
    }

    private func generateBaseTask(
        operation: MathOperation,
        maxNumber: Int,
        allowNegativeSubtraction: Bool,
        divisionOnlyIntegers: Bool
    ) -> TaskItem {
        switch operation {
        case .addition:
            let a = Int.random(in: 0...maxNumber)
            let b = Int.random(in: 0...maxNumber)
            return TaskItem(left: a, right: b, operation: .addition, correctAnswer: a + b)

        case .subtraction:
            var a = Int.random(in: 0...maxNumber)
            var b = Int.random(in: 0...maxNumber)

            if !allowNegativeSubtraction && b > a {
                swap(&a, &b)
            }

            return TaskItem(left: a, right: b, operation: .subtraction, correctAnswer: a - b)

        case .multiplication:
            let range = max(2, min(maxNumber, 12))
            let a = Int.random(in: 0...range)
            let b = Int.random(in: 0...range)
            return TaskItem(left: a, right: b, operation: .multiplication, correctAnswer: a * b)

        case .division:
            let divisor = Int.random(in: 1...max(1, min(maxNumber, 12)))

            if divisionOnlyIntegers {
                let result = Int.random(in: 0...maxNumber)
                let dividend = divisor * result
                return TaskItem(left: dividend, right: divisor, operation: .division, correctAnswer: result)
            } else {
                let dividend = Int.random(in: 0...maxNumber)
                return TaskItem(left: dividend, right: divisor, operation: .division, correctAnswer: dividend / divisor)
            }
        }
    }

    private func generateOptions(correctAnswer: Int) -> [Int] {
        var values = Set<Int>()
        values.insert(correctAnswer)

        while values.count < 4 {
            let delta = Int.random(in: -8...8)
            let candidate = max(0, correctAnswer + (delta == 0 ? 2 : delta))
            values.insert(candidate)
        }

        return values.shuffled()
    }
}
