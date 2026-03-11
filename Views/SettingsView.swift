import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var router: AppRouter
    var body: some View {
        Form {
            HStack {
                Button("← Назад") {
                    router.goHome()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding(.horizontal)
            
            Section(header: Text("Ответы")) {
                Picker("Режим ответа", selection: $settingsStore.settings.answerMode) {
                    ForEach(AnswerMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
            }

            Section(header: Text("Обучение")) {
                Toggle("Только целое деление", isOn: $settingsStore.settings.divisionOnlyIntegers)
                Toggle("Разрешить отрицательные ответы в вычитании", isOn: $settingsStore.settings.allowNegativeSubtraction)
            }

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
