import SwiftUI

struct ParentGateView: View {
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var router: AppRouter
    @State private var pin: String = ""
    @State private var showError: Bool = false

    private var savedPin: String {
        settingsStore.settings.parentPin
    }

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 18) {
                HeaderBackView(title: "Родительский доступ").padding(26)

                ParentPinCard(
                    title: "Введите PIN",
                    subtitle: "Этот экран защищает родительские настройки и статистику."
                ) {
                    PinDotsView(pin: pin)

                    if showError {
                        Text("Неверный PIN-код")
                            .foregroundColor(.red)
                            .font(.subheadline.weight(.semibold))
                    }

                    PinKeypadView(
                        digitAction: appendDigit,
                        deleteAction: removeDigit
                    )

                    Button("Открыть") {
                        unlock()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(pin.count != 4)

                    Text("PIN по умолчанию: 0000")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        
    }

    private func appendDigit(_ digit: String) {
        guard pin.count < 4 else { return }
        pin += digit
        showError = false
    }

    private func removeDigit() {
        guard !pin.isEmpty else { return }
        pin.removeLast()
        showError = false
    }

    private func unlock() {
        if pin == savedPin {
            pin = ""
            showError = false
            router.goToParentDashboard()
        } else {
            pin = ""
            showError = true
        }
    }
}
