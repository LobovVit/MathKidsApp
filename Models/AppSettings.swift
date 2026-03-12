import Foundation

struct AppSettings: Codable { var divisionOnlyIntegers = true; var allowNegativeSubtraction = false; var answerMode: AnswerMode = .multipleChoice; var soundEnabled = true; var animationsEnabled = true; var iCloudSyncEnabled = true }
