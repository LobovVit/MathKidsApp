import Foundation

enum DifficultyLevel: String, CaseIterable, Codable, Identifiable {
    case easy
    case medium
    case hard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy: return "Лёгкий"
        case .medium: return "Средний"
        case .hard: return "Сложный"
        }
    }

    var emoji: String {
        switch self {
        case .easy: return "🌱"
        case .medium: return "🚀"
        case .hard: return "🏆"
        }
    }

    var maxNumber: Int {
        switch self {
        case .easy: return 10
        case .medium: return 25
        case .hard: return 100
        }
    }

    var questionsCount: Int {
        switch self {
        case .easy: return 8
        case .medium: return 12
        case .hard: return 15
        }
    }
}
