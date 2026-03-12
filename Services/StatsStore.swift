import Foundation
import Combine

final class StatsStore: ObservableObject {
    @Published private(set) var results: [SessionResult] = []
    private let key = "mathkids.results"

    init() { load() }

    func add(result: SessionResult) { results.insert(result, at: 0); save() }
    func clearAll() { results.removeAll(); save() }
    func results(for childID: UUID?) -> [SessionResult] { guard let childID else { return results }; return results.filter { $0.childID == childID } }
    func totalSolved(for childID: UUID?) -> Int { results(for: childID).reduce(0) { $0 + $1.totalQuestions } }
    func totalCorrect(for childID: UUID?) -> Int { results(for: childID).reduce(0) { $0 + $1.correctAnswers } }
    func accuracy(for childID: UUID?) -> Double { let total = totalSolved(for: childID); guard total > 0 else { return 0 }; return Double(totalCorrect(for: childID)) / Double(total) }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([SessionResult].self, from: data) { results = decoded } else { results = [] }
    }

    private func save() { guard let data = try? JSONEncoder().encode(results) else { return }; UserDefaults.standard.set(data, forKey: key) }
}
