import Combine
import Foundation
import SwiftUI

final class SettingsStore: ObservableObject {
    @Published var settings: AppSettings {
        didSet {
            save()
            ICloudKeyValueSync.shared.push(settings, forKey: key, enabled: settings.iCloudSyncEnabled)
        }
    }

    private let key = "mathkids.v4.settings"

    init() {
        if let localData = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: localData) {
            settings = decoded
        } else if let cloud: AppSettings = ICloudKeyValueSync.shared.pull(AppSettings.self, forKey: key) {
            settings = cloud
        } else {
            settings = AppSettings()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
