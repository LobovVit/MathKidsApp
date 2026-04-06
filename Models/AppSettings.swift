import Foundation

struct AppSettings: Codable {
    var divisionOnlyIntegers: Bool = true
    var allowNegativeSubtraction: Bool = false
    var answerMode: AnswerMode = .multipleChoice
    var soundEnabled: Bool = true
    var animationsEnabled: Bool = true
    var iCloudSyncEnabled: Bool = true

    // Родительский PIN хранится вместе с остальными настройками приложения.
    var parentPin: String = "0000"
}
