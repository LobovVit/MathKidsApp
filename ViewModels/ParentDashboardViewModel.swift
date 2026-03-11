import Combine
import Foundation

final class ParentDashboardViewModel: ObservableObject {
    func weakestOperation(from results: [SessionResult]) -> String {
        let grouped = Dictionary(grouping: results, by: { $0.operation })
        let accuracies: [(MathOperation, Double)] = grouped.map { operation, items in
            let total = items.reduce(0) { $0 + $1.totalQuestions }
            let correct = items.reduce(0) { $0 + $1.correctAnswers }
            let accuracy = total > 0 ? Double(correct) / Double(total) : 0
            return (operation, accuracy)
        }
        return accuracies.sorted(by: { $0.1 < $1.1 }).first?.0.title ?? "Пока нет данных"
    }

    func totalTrainingTime(from results: [SessionResult]) -> String {
        let totalSeconds = results.reduce(0.0) { $0 + $1.duration }
        let minutes = Int(totalSeconds / 60)
        return "\(minutes) мин"
    }

    func progressPoints(from results: [SessionResult]) -> [ProgressPoint] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return results
            .prefix(7)
            .reversed()
            .map { ProgressPoint(label: formatter.string(from: $0.date), value: $0.accuracy * 100) }
    }
}

