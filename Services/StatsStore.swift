import Combine
import Foundation
import SwiftUI

final class StatsStore: ObservableObject {
    @Published private(set) var results: [SessionResult] = []

    private let key = "mathkid.v3.results"

    init() {
        load()
    }

    func add(result: SessionResult) {
        results.insert(result, at: 0)
        save()
    }

    func clearAll() {
        results.removeAll()
        save()
    }

    func totalSolved(for operation: MathOperation? = nil) -> Int {
        filtered(operation).reduce(0) { $0 + $1.totalQuestions }
    }

    func totalCorrect(for operation: MathOperation? = nil) -> Int {
        filtered(operation).reduce(0) { $0 + $1.correctAnswers }
    }

    func accuracy(for operation: MathOperation? = nil) -> Double {
        let total = totalSolved(for: operation)
        guard total > 0 else { return 0 }
        return Double(totalCorrect(for: operation)) / Double(total)
    }

    private func filtered(_ operation: MathOperation?) -> [SessionResult] {
        guard let operation else { return results }
        return results.filter { $0.operation == operation }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([SessionResult].self, from: data) else {
            results = []
            return
        }
        results = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(results) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
