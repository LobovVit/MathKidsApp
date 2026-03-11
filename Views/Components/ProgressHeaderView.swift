import SwiftUI

struct ProgressHeaderView: View {
    let progressText: String
    let progressValue: Double
    let streak: Int

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Пример \(progressText)")
                    .font(.headline)
                Spacer()
                Text("Серия: \(streak) 🔥")
                    .font(.headline)
            }
            ProgressView(value: progressValue)
        }
        .padding(.horizontal)
    }
}
