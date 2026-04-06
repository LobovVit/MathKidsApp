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
            if level == .columnar {
                return generateColumnarTask(operation: operation)
            }

            let task = generateBaseTask(
                operation: operation,
                maxNumber: level.maxNumber,
                allowNegativeSubtraction: allowNegativeSubtraction,
                divisionOnlyIntegers: divisionOnlyIntegers
            )

            if answerMode == .multipleChoice {
                return TaskItem(
                    left: task.left,
                    right: task.right,
                    operation: task.operation,
                    correctAnswer: task.correctAnswer,
                    options: generateOptions(correctAnswer: task.correctAnswer),
                    presentationStyle: .inline
                )
            } else {
                return task
            }
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
            if !allowNegativeSubtraction && b > a { swap(&a, &b) }
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
                return TaskItem(left: divisor * result, right: divisor, operation: .division, correctAnswer: result)
            } else {
                let dividend = Int.random(in: 0...maxNumber)
                return TaskItem(left: dividend, right: divisor, operation: .division, correctAnswer: dividend / divisor)
            }
        }
    }

    private func generateColumnarTask(operation: MathOperation) -> TaskItem {
        switch operation {
        case .addition:
            let a = Int.random(in: 12...999)
            let b = Int.random(in: 12...999)
            return TaskItem(
                left: a,
                right: b,
                operation: .addition,
                correctAnswer: a + b,
                presentationStyle: .columnar
            )

        case .subtraction:
            var a = Int.random(in: 20...999)
            var b = Int.random(in: 10...999)
            if b > a { swap(&a, &b) }
            return TaskItem(
                left: a,
                right: b,
                operation: .subtraction,
                correctAnswer: a - b,
                presentationStyle: .columnar
            )

        case .multiplication:
            let a = Int.random(in: 12...99)
            let b: Int
            if Bool.random() {
                b = Int.random(in: 2...9)
            } else {
                b = Int.random(in: 10...25)
            }
            return TaskItem(
                left: a,
                right: b,
                operation: .multiplication,
                correctAnswer: a * b,
                presentationStyle: .columnar
            )

        case .division:
            let divisor = Int.random(in: 2...9)
            let result = Int.random(in: 2...99)
            let dividend = divisor * result
            return TaskItem(
                left: dividend,
                right: divisor,
                operation: .division,
                correctAnswer: result,
                presentationStyle: .columnar
            )
        }
    }

    private func generateOptions(correctAnswer: Int) -> [Int] {
        var values = Set<Int>()
        values.insert(correctAnswer)
        while values.count < 4 {
            let delta = Int.random(in: -8...8)
            values.insert(max(0, correctAnswer + (delta == 0 ? 2 : delta)))
        }
        return values.shuffled()
    }
}
