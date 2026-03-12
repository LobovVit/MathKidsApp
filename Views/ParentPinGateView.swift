import SwiftUI

struct ParentPinGateView: View {
    @EnvironmentObject var authStore: ParentAuthStore
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            KidBackgroundView()
            VStack(spacing: 20) {
                HeaderBackView(title: "Родительский доступ")
                Text("Введите PIN").font(.largeTitle.bold())
                SecureField("PIN", text: $authStore.enteredPin)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 220)
                if let error = authStore.errorMessage { Text(error).foregroundColor(.red) }
                Button("Открыть") {
                    authStore.unlock()
                    if authStore.isUnlocked { router.goToParentDashboard() }
                }
                .buttonStyle(.borderedProminent)
                Text("PIN по умолчанию: 0000").font(.caption).foregroundColor(.secondary)
            }
            .padding()
        }
    }
}
