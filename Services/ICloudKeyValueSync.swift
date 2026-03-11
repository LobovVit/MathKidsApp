//
//  ICloudKeyValueSync.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import Foundation

final class ICloudKeyValueSync {
    static let shared = ICloudKeyValueSync()
    private let store = NSUbiquitousKeyValueStore.default

    private init() {}

    func push<T: Encodable>(_ value: T, forKey key: String, enabled: Bool) {
        guard enabled else { return }
        guard let data = try? JSONEncoder().encode(value) else { return }
        store.set(data, forKey: key)
        store.synchronize()
    }

    func pull<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = store.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
