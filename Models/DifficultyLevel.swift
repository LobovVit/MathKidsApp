import Foundation

enum DifficultyLevel: String, CaseIterable, Codable, Identifiable {
    case easy
    case medium
    case hard
    case columnar

    var id: String { rawValue }

    var title: String {
        switch self {
        case .easy: return "Лёгкий"
        case .medium: return "Средний"
        case .hard: return "Сложный"
        case .columnar: return "В столбик"
        }
    }

    var emoji: String {
        switch self {
        case .easy: return "🌱"
        case .medium: return "🚀"
        case .hard: return "🏆"
        case .columnar: return "📝"
        }
    }

    var maxNumber: Int {
        switch self {
        case .easy: return 10
        case .medium: return 25
        case .hard: return 100
        case .columnar: return 999
        }
    }

    var questionsCount: Int {
        switch self {
        case .easy: return 8
        case .medium: return 12
        case .hard: return 15
        case .columnar: return 8
        }
    }
}
