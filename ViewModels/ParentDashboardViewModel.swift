import Foundation
import Combine

final class ParentDashboardViewModel: ObservableObject {
    func weakestOperation(from results: [SessionResult]) -> String {
        let grouped = Dictionary(grouping: results, by: { $0.operation })
        let accuracies: [(MathOperation, Double)] = grouped.map { operation, items in
            let total = items.reduce(0) { $0 + $1.totalQuestions }
            let correct = items.reduce(0) { $0 + $1.correctAnswers }
            let accuracy = total > 0 ? Double(correct) / Double(total) : 0
            return (operation, accuracy)
        }
        return accuracies.sorted(by: { $0.1 < $1.1 }).first?.0.title ?? "Недостаточно данных"
    }

    func totalTrainingTime(from results: [SessionResult]) -> String {
        format(seconds: Int(results.reduce(0.0) { $0 + $1.duration }))
    }

    func averageTrainingTime(from results: [SessionResult]) -> String {
        guard !results.isEmpty else { return "0 сек" }
        let totalSeconds = results.reduce(0.0) { $0 + $1.duration }
        return format(seconds: Int(totalSeconds / Double(results.count)))
    }

    func lastTrainingTime(from results: [SessionResult]) -> String {
        guard let last = results.sorted(by: { $0.date > $1.date }).first else { return "—" }
        return format(seconds: Int(last.duration))
    }

    func chartItems(from results: [SessionResult]) -> [SimpleBarChartItem] {
        MathOperation.allCases.map { operation in
            let items = results.filter { $0.operation == operation }
            let total = items.reduce(0) { $0 + $1.totalQuestions }
            let correct = items.reduce(0) { $0 + $1.correctAnswers }
            let accuracy = total > 0 ? (Double(correct) / Double(total)) * 100 : 0
            return SimpleBarChartItem(title: operation.title, value: accuracy)
        }
    }

    private func format(seconds totalSeconds: Int) -> String {
        if totalSeconds < 60 {
            return "\(totalSeconds) сек"
        }
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        if seconds == 0 {
            return "\(minutes) мин"
        } else {
            return "\(minutes) мин \(seconds) сек"
        }
    }
}
