import Foundation

struct SessionResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let childID: UUID
    let childName: String
    let operation: MathOperation
    let difficulty: DifficultyLevel
    let totalQuestions: Int
    let correctAnswers: Int
    let answers: [SessionAnswer]
    let bestStreak: Int
    let duration: TimeInterval

    init(id: UUID = UUID(),
         date: Date = Date(),
         childID: UUID,
         childName: String,
         operation: MathOperation,
         difficulty: DifficultyLevel,
         totalQuestions: Int,
         correctAnswers: Int,
         answers: [SessionAnswer],
         bestStreak: Int,
         duration: TimeInterval)
    {
        self.id = id
        self.date = date
        self.childID = childID
        self.childName = childName
        self.operation = operation
        self.difficulty = difficulty
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
        self.answers = answers
        self.bestStreak = bestStreak
        self.duration = duration
    }

    var accuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }
}
