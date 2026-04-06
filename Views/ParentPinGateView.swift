import SwiftUI

struct ParentPinGateView: View {
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var router: AppRouter
    @State private var pin: String = ""
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 18) {
                HeaderBackView(title: "Родительский доступ2").padding(26)

                ParentPinCard(
                    title: "Введите PIN",
                    subtitle: "После ввода верного PIN откроется родительская панель."
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
                        if pin == settingsStore.settings.parentPin {
                            router.goToParentDashboard()
                        } else {
                            pin = ""
                            showError = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(pin.count != 4)
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
}
