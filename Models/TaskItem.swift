import Foundation

struct TaskItem: Identifiable, Codable {
    let id: UUID
    let left: Int
    let right: Int
    let operation: MathOperation
    let correctAnswer: Int
    let options: [Int]

    init(
        id: UUID = UUID(),
        left: Int,
        right: Int,
        operation: MathOperation,
        correctAnswer: Int,
        options: [Int] = []
    ) {
        self.id = id
        self.left = left
        self.right = right
        self.operation = operation
        self.correctAnswer = correctAnswer
        self.options = options
    }

    var questionText: String {
        "\(left) \(operation.symbol) \(right)"
    }
}
