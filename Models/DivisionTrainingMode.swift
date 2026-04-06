import Foundation

enum DivisionTrainingMode: String, CaseIterable, Codable, Identifiable {
    case resultOnly
    case steps
    case full

    var id: String { rawValue }

    var title: String {
        switch self {
        case .resultOnly: return "Итог"
        case .steps: return "Шаги"
        case .full: return "Полный"
        }
    }
}
