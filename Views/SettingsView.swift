import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settingsStore: SettingsStore

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 14) {
                HeaderBackView(title: "Настройки")

                Form {
                    Section("Ответы") {
                        Picker("Режим ответа", selection: $settingsStore.settings.answerMode) {
                            ForEach(AnswerMode.allCases) { mode in
                                Text(mode.title)
                                    .tag(mode)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    Section("Обучение") {
                        Toggle("Только целое деление", isOn: $settingsStore.settings.divisionOnlyIntegers)
                        Toggle("Разрешить отрицательные ответы в вычитании", isOn: $settingsStore.settings.allowNegativeSubtraction)
                    }

                    Section("Оформление и звук") {
                        Toggle("Включить звуки", isOn: $settingsStore.settings.soundEnabled)
                        Toggle("Включить анимации", isOn: $settingsStore.settings.animationsEnabled)
                    }

                    Section("Синхронизация") {
                        Toggle("iCloud sync", isOn: $settingsStore.settings.iCloudSyncEnabled)
                    }
                }
            }
        }
    }
}
