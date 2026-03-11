import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore

    var body: some View {
        Form {
            Section("Ответы") {
                Picker("Режим ответа", selection: $settingsStore.settings.answerMode) {
                    ForEach(AnswerMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
            }

            Section("Обучение") {
                Toggle("Только целое деление", isOn: $settingsStore.settings.divisionOnlyIntegers)
                Toggle("Разрешить отрицательные ответы в вычитании", isOn: $settingsStore.settings.allowNegativeSubtraction)
            }

            Section("Оформление и звук") {
                Toggle("Включить звуки", isOn: $settingsStore.settings.soundEnabled)
                Toggle("Включить анимации", isOn: $settingsStore.settings.animationsEnabled)
            }
        }
        .navigationTitle("Настройки")
    }
}
