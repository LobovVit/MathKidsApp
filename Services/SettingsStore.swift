import Foundation
import Combine

final class SettingsStore: ObservableObject {
    @Published var settings: AppSettings { didSet { save() } }
    private let key = "mathkids.settings"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        } else { settings = AppSettings() }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        UserDefaults.standard.set(data, forKey: key)
        if settings.iCloudSyncEnabled { ICloudKeyValueSync.shared.set(settings, forKey: key) }
    }

    func loadFromICloudIfNeeded() {
        guard settings.iCloudSyncEnabled,
              let cloud: AppSettings = ICloudKeyValueSync.shared.get(AppSettings.self, forKey: key) else { return }
        settings = cloud
    }
}
