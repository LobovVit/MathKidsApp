import SwiftUI

struct BigMenuCard: View {
    let emoji: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Text(emoji)
                .font(.system(size: 44))

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3.bold())

                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.65))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
        )
    }
}
