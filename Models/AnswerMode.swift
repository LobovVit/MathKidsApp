import Foundation

enum AnswerMode: String, CaseIterable, Codable, Identifiable {
    case input, multipleChoice
    var id: String { rawValue }
    var title: String {
        switch self {
        case .input: return "Ввод ответа"
        case .multipleChoice: return "4 варианта"
        }
    }
}
