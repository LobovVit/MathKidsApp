import Combine
import Foundation
import SwiftUI

final class StatsStore: ObservableObject {
    @Published private(set) var results: [SessionResult] = []

    private let key = "mathkids.v4.results"

    init() {
        if let localData = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([SessionResult].self, from: localData) {
            results = decoded
        } else if let cloud: [SessionResult] = ICloudKeyValueSync.shared.pull([SessionResult].self, forKey: key) {
            results = cloud
        }
    }

    func add(result: SessionResult, syncEnabled: Bool) {
        results.insert(result, at: 0)
        save(syncEnabled: syncEnabled)
    }

    func clearAll(syncEnabled: Bool) {
        results.removeAll()
        save(syncEnabled: syncEnabled)
    }

    func totalSolved(for childID: UUID? = nil, operation: MathOperation? = nil) -> Int {
        filtered(childID: childID, operation: operation).reduce(0) { $0 + $1.totalQuestions }
    }

    func totalCorrect(for childID: UUID? = nil, operation: MathOperation? = nil) -> Int {
        filtered(childID: childID, operation: operation).reduce(0) { $0 + $1.correctAnswers }
    }

    func accuracy(for childID: UUID? = nil, operation: MathOperation? = nil) -> Double {
        let total = totalSolved(for: childID, operation: operation)
        guard total > 0 else { return 0 }
        return Double(totalCorrect(for: childID, operation: operation)) / Double(total)
    }

    func results(for childID: UUID) -> [SessionResult] {
        results.filter { $0.childID == childID }
    }

    private func filtered(childID: UUID?, operation: MathOperation?) -> [SessionResult] {
        results.filter { result in
            let childOK = childID == nil || result.childID == childID
            let opOK = operation == nil || result.operation == operation
            return childOK && opOK
        }
    }

    private func save(syncEnabled: Bool) {
        guard let data = try? JSONEncoder().encode(results) else { return }
        UserDefaults.standard.set(data, forKey: key)
        ICloudKeyValueSync.shared.push(results, forKey: key, enabled: syncEnabled)
    }
}
