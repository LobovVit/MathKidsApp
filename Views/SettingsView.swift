import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var router: AppRouter

    var body: some View {
        Form {
            HeaderBackView(title: "Настройки")

            Section(header: Text("Оформление и звук")) {
                Toggle("Включить звуки", isOn: $settingsStore.settings.soundEnabled)
                Toggle("Включить анимации", isOn: $settingsStore.settings.animationsEnabled)
            }

            Section(
                header: Text("Синхронизация"),
                footer: Text("Для работы включи capability iCloud -> Key-value storage в Xcode.")
            ) {
                Toggle("iCloud sync", isOn: $settingsStore.settings.iCloudSyncEnabled)
            }
        }
        .navigationTitle("Настройки")
    }
}
