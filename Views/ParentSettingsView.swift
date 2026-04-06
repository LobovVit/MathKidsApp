import SwiftUI

struct ParentSettingsView: View {
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var router: AppRouter

    @State private var draftPin: String = ""
    @State private var confirmPin: String = ""
    @State private var stage: Stage = .enter
    @State private var infoText: String = ""

    private enum Stage {
        case enter
        case confirm
    }

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 18) {
                HeaderBackView(title: "PIN и защита").padding(26)

                ParentPinCard(
                    title: stage == .enter ? "Новый PIN" : "Подтвердите PIN",
                    subtitle: stage == .enter
                        ? "Придумайте 4-значный PIN для родительского экрана."
                        : "Введите тот же PIN ещё раз."
                ) {
                    PinDotsView(pin: stage == .enter ? draftPin : confirmPin)

                    if !infoText.isEmpty {
                        Text(infoText)
                            .foregroundColor(infoText.contains("сохранён") ? .green : .red)
                            .font(.subheadline.weight(.semibold))
                    }

                    PinKeypadView(
                        digitAction: appendDigit,
                        deleteAction: removeDigit
                    )

                    Button(stage == .enter ? "Продолжить" : "Сохранить") {
                        continueFlow()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(currentPin.count != 4)

                    Button("Сбросить PIN на 0000") {
                        settingsStore.settings.parentPin = "0000"
                        draftPin = ""
                        confirmPin = ""
                        stage = .enter
                        infoText = "PIN сброшен на 0000"
                    }
                    .buttonStyle(.bordered)
                }

                Button("На главный экран") {
                    router.goHome()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        
    }

    private var currentPin: String {
        stage == .enter ? draftPin : confirmPin
    }

    private func appendDigit(_ digit: String) {
        if stage == .enter {
            guard draftPin.count < 4 else { return }
            draftPin += digit
        } else {
            guard confirmPin.count < 4 else { return }
            confirmPin += digit
        }
        infoText = ""
    }

    private func removeDigit() {
        if stage == .enter {
            guard !draftPin.isEmpty else { return }
            draftPin.removeLast()
        } else {
            guard !confirmPin.isEmpty else { return }
            confirmPin.removeLast()
        }
        infoText = ""
    }

    private func continueFlow() {
        switch stage {
        case .enter:
            guard draftPin.count == 4 else { return }
            stage = .confirm
            infoText = ""
        case .confirm:
            guard confirmPin.count == 4 else { return }
            if draftPin == confirmPin {
                settingsStore.settings.parentPin = draftPin
                infoText = "PIN сохранён"
                draftPin = ""
                confirmPin = ""
                stage = .enter
            } else {
                infoText = "PIN не совпадает"
                confirmPin = ""
            }
        }
    }
}
