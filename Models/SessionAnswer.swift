import Foundation

struct SessionAnswer: Codable {
    let task: TaskItem
    let userAnswer: Int?
    let isCorrect: Bool
}
