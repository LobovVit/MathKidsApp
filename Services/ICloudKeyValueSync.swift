import Foundation

final class ICloudKeyValueSync {
    static let shared = ICloudKeyValueSync()
    private let store = NSUbiquitousKeyValueStore.default
    private init() {}

    func set<DataType: Codable>(_ value: DataType, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        store.set(data, forKey: key)
        store.synchronize()
    }

    func get<DataType: Codable>(_ type: DataType.Type, forKey key: String) -> DataType? {
        guard let data = store.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
