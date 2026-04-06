import Foundation

enum TaskPresentationStyle: String, Codable {
    case inline
    case columnar
}

struct TaskItem: Identifiable, Codable {
    let id: UUID
    let left: Int
    let right: Int
    let operation: MathOperation
    let correctAnswer: Int
    let options: [Int]
    let presentationStyle: TaskPresentationStyle

    init(
        id: UUID = UUID(),
        left: Int,
        right: Int,
        operation: MathOperation,
        correctAnswer: Int,
        options: [Int] = [],
        presentationStyle: TaskPresentationStyle = .inline
    ) {
        self.id = id
        self.left = left
        self.right = right
        self.operation = operation
        self.correctAnswer = correctAnswer
        self.options = options
        self.presentationStyle = presentationStyle
    }

    var questionText: String {
        "\(left) \(operation.symbol) \(right)"
    }

    var leftDigits: [Int] {
        String(left).compactMap { Int(String($0)) }
    }

    var rightDigits: [Int] {
        String(right).compactMap { Int(String($0)) }
    }
}
