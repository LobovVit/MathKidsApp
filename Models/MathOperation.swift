import Foundation

enum MathOperation: String, CaseIterable, Codable, Identifiable {
    case addition
    case subtraction
    case multiplication
    case division

    var id: String { rawValue }

    var title: String {
        switch self {
        case .addition: return "Сложение"
        case .subtraction: return "Вычитание"
        case .multiplication: return "Умножение"
        case .division: return "Деление"
        }
    }

    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "−"
        case .multiplication: return "×"
        case .division: return "÷"
        }
    }

    var emoji: String {
        switch self {
        case .addition: return "➕"
        case .subtraction: return "➖"
        case .multiplication: return "✖️"
        case .division: return "➗"
        }
    }
}
