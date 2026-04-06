import SwiftUI

struct HeaderBackView: View {
    let title: String
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        HStack {
            Button("← Назад") {
                router.goBack()
            }
            .buttonStyle(.bordered)

            Spacer()

            Text(title)
                .font(.headline)

            Spacer()

            Color.clear.frame(width: 86, height: 1)
        }
        .padding(.horizontal)
    }
}
